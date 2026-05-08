package org.dsa.model.repository;

import org.dsa.model.entity.CostLiving;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CostLivingRepository extends JpaRepository<CostLiving, Integer> {
    // JpaRepository ofera automat metodele findAll(), findById() etc.
}