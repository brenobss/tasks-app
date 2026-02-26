package com.brenodev.tasks.repository;

import com.brenodev.tasks.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaskRepository extends JpaRepository<Task, Long> {
}
