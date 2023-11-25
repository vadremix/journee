package com.worldjournee.usermanagementservice.repository;

import com.worldjournee.usermanagementservice.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

}
