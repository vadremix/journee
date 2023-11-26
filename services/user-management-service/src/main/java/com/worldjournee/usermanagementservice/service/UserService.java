package com.worldjournee.usermanagementservice.service;

import com.worldjournee.usermanagementservice.model.User;
import com.worldjournee.usermanagementservice.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User saveUser(User user) {
        user.setPassword(encodePassword(user.getPassword()));

        try {
            return userRepository.save(user);
        } catch (Exception|Error e) {
            throw new RuntimeException("Username or email already exists");
        }
    }

    private String encodePassword(String password) {
        return passwordEncoder.encode(password);
    }
}
