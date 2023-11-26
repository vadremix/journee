package com.worldjournee.usermanagementservice.unit;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import com.worldjournee.usermanagementservice.model.User;
import com.worldjournee.usermanagementservice.repository.UserRepository;
import com.worldjournee.usermanagementservice.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("test1");
        user.setEmail("john.smith@gmail.com");
        user.setPassword("password");
    }

    @Test
    void testSaveUserWithValidInputs() {
        when(passwordEncoder.encode(anyString())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(user);

        User createdUser = this.userService.saveUser(user);

        verify(passwordEncoder).encode(anyString());
        verify(userRepository).save(user);

        assertEquals("encodedPassword", createdUser.getPassword());
    }

//    @Test
//    void testSaveUserWithNullPassword() {
//        user.setPassword(null);
//
//        assertThrows(NullPointerException.class, () -> {
//            this.userService.saveUser(user);
//        });
//    }
//
//    @Test
//    void testSaveUserWithNullUsername() {
//        user.setUsername(null);
//
//        assertThrows(NullPointerException.class, () -> {
//            this.userService.saveUser(user);
//        });
//    }
//
//    @Test
//    void testSaveUserWithInvalidEmail() {
//        user.setEmail("invalidEmail");
//
//        assertThrows(IllegalArgumentException.class, () -> {
//            this.userService.saveUser(user);
//        });
//    }
}