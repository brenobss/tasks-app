package com.brenodev.tasks.repository;

import com.brenodev.tasks.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
