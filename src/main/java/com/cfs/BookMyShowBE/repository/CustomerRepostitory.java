package com.cfs.BookMyShowBE.repository;

import com.cfs.BookMyShowBE.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CustomerRepostitory extends JpaRepository<Customer,Long> {

    boolean existsByEmail(String email);
    boolean existsByPhone(String phone);
    Optional<Customer> findByEmail(String mail);
    Optional<Customer> findByPhone(String phone);
}
