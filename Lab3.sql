-- ZADANIE 1
CREATE OR REPLACE VIEW v_wysokie_pensja AS
SELECT '*'
FROM employees
WHERE salary > 6000;


-- ZADANIE 2
CREATE OR REPLACE VIEW v_wysokie_pensja AS
SELECT '*'
FROM employees
WHERE salary > 12000;


-- ZADANIE 3
DROP VIEW v_wysokie_pensja;


-- ZADANIE 4
CREATE OR REPLACE VIEW v_finance AS
SELECT
    e.employee_id,
    e.last_name,
    e.first_name
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';


-- ZADANIE 5
CREATE OR REPLACE VIEW v_finance AS
SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    job_id,
    email,
    hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000;


-- ZADANIE 6
CREATE OR REPLACE VIEW v_zarobki AS
SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    job_id,
    email,
    hire_date
FROM employees;

INSERT INTO v_zarobki
(employee_id, last_name, first_name, salary,
 job_id, email, hire_date)
VALUES
(300, 'Kowalski', 'Jan', 7000,
 'IT_PROG', 'JKOWALSKI', SYSDATE);

UPDATE v_zarobki
SET salary = 8000
WHERE employee_id = 300;

DELETE FROM v_zarobki
WHERE employee_id = 300;


-- Zadanie 7
CREATE OR REPLACE VIEW v_dzialy_pracownicy AS
SELECT
    DEPARTMENT_ID AS department_id,
    COUNT(EMPLOYEE_ID) AS liczba_pracownikow,
    ROUND(AVG(SALARY), 2) AS srednia_pensja,
    MAX(SALARY) AS najwyzsza_pensja
GROUP BY DEPARTMENT_ID
HAVING COUNT(EMPLOYEE_ID) >= 4;

INSERT INTO v_dzialy_pracownicy
VALUES (300, 'IT', 4, 6000, 10000);

-- ZADANIE 8
CREATE OR REPLACE VIEW v_zarobki_check AS
SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    job_id,
    email,
    hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000
WITH CHECK OPTION;

INSERT INTO v_zarobki_check
(employee_id, last_name, first_name, salary,
 job_id, email, hire_date)
VALUES
(301, 'Nowak', 'Anna', 8000,
 'IT_PROG', 'ANOWAK', SYSDATE);

INSERT INTO v_zarobki_check
(employee_id, last_name, first_name, salary,
 job_id, email, hire_date)
VALUES
(302, 'Wisniewski', 'Piotr', 15000,
 'IT_PROG', 'PWISNIEWSKI', SYSDATE);


-- ZADANIE 9
CREATE MATERIALIZED VIEW v_managerowie AS
SELECT DISTINCT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.employee_id IN (
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
);


-- ZADANIE 10
CREATE OR REPLACE VIEW v_najlepiej_oplacani AS
SELECT
    EMPLYEE_ID,
    first_name,
    last_name,
    salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 10 ROWS ONLY;