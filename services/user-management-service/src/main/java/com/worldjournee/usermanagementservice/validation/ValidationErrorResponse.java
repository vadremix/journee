package com.worldjournee.usermanagementservice.validation;

import java.util.ArrayList;
import java.util.List;

public class ValidationErrorResponse {
    private List<Violation> violations = new ArrayList<>();

    public List<Violation> getViolations() {
        return violations;
    }

    public void addViolation(Violation violation) {
        violations.add(violation);
    }
}
