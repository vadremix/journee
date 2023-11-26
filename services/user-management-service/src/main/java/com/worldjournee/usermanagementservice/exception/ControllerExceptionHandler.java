package com.worldjournee.usermanagementservice.exception;

import com.google.gson.Gson;
import com.worldjournee.usermanagementservice.validation.ValidationErrorResponse;
import com.worldjournee.usermanagementservice.validation.Violation;
import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class ControllerExceptionHandler {
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    ResponseEntity<String> onRuntimeException(
            RuntimeException e) {

        Map<String, String> exceptionMessage = new HashMap<>();
        exceptionMessage.put("error", e.getMessage());

        Gson gson = new Gson();
        return ResponseEntity.badRequest()
                .contentType(MediaType.APPLICATION_PROBLEM_JSON)
                .body(gson.toJson(exceptionMessage));
    }

    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    ValidationErrorResponse onConstraintValidationException(
            ConstraintViolationException e) {

        ValidationErrorResponse error = new ValidationErrorResponse();

        e.getConstraintViolations().stream().map(
                violation -> new Violation(violation.getPropertyPath().toString(), violation.getMessage()))
                .forEach(error::addViolation);
        return error;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    ValidationErrorResponse onMethodArgumentNotValidException(
            MethodArgumentNotValidException e) {

        ValidationErrorResponse error = new ValidationErrorResponse();

        for (FieldError fieldError : e.getBindingResult().getFieldErrors()) {
            error.addViolation(
                new Violation(fieldError.getField(), fieldError.getDefaultMessage()));
        }
        return error;
    }
}
