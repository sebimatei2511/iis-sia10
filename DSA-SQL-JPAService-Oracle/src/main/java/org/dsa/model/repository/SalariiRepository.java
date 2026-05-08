package org.dsa.model.repository;


import org.dsa.model.entity.Salarii;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SalariiRepository extends JpaRepository<Salarii, String> {
    // Spring va genera automat: SELECT * FROM SALARIES_DATA WHERE COUNTRY = ?
   // java.util.List<Salarii> findByCountry(String country);

    // Spring va genera automat: SELECT * FROM SALARIES_DATA WHERE SALARY_2020 > ?
   // java.util.List<Salarii> findBySalary2020GreaterThan(Double salary);
}