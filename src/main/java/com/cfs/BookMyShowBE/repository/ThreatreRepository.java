package com.cfs.BookMyShowBE.repository;

import com.cfs.BookMyShowBE.entity.Theatre;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ThreatreRepository extends JpaRepository<Theatre,Long> {

    List<Theatre> findByCityIgnoreCaseOrderByName(String city);

    Optional<Theatre> findByNameAndCity(String name, String city);
}
