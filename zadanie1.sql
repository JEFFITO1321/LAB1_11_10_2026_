
--punkt 1

CREATE TABLE REGIONS (
    region_id NUMBER PRIMARY KEY,
    region_name VARCHAR2(50)
);

CREATE TABLE COUNTRIES (
    country_id CHAR(2) PRIMARY KEY,
    country_name VARCHAR2(50),
    region_id NUMBER
);

CREATE TABLE LOCATIONS (
    location_id NUMBER PRIMARY KEY,
    street_address VARCHAR2(50),
    postal_code VARCHAR2(20),
    city VARCHAR2(30),
    state_province VARCHAR2(25),
    country_id CHAR(2)
);

CREATE TABLE DEPARTMENTS (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50),
    manager_id NUMBER,
    location_id NUMBER
);

CREATE TABLE JOBS (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(50),
    min_salary NUMBER,
    max_salary NUMBER,
    CONSTRAINT chk_salaries
        CHECK (max_salary - min_salary >= 2000)
);

CREATE TABLE EMPLOYEES (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100),
    phone_number VARCHAR2(20),
    hire_date DATE,
    job_id VARCHAR2(10),
    salary NUMBER,
    manager_id NUMBER,
    department_id NUMBER
);

CREATE TABLE JOB_HISTORY (
    employee_id NUMBER,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR2(10),
    department_id NUMBER,
    CONSTRAINT pk_job_history
        PRIMARY KEY (employee_id, start_date)
);




ALTER TABLE COUNTRIES
ADD CONSTRAINT fk_countries_region
FOREIGN KEY (region_id)
REFERENCES REGIONS(region_id);

ALTER TABLE LOCATIONS
ADD CONSTRAINT fk_locations_country
FOREIGN KEY (country_id)
REFERENCES COUNTRIES(country_id);

ALTER TABLE DEPARTMENTS
ADD CONSTRAINT fk_depts_location
FOREIGN KEY (location_id)
REFERENCES LOCATIONS(location_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_emps_job
FOREIGN KEY (job_id)
REFERENCES JOBS(job_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_emps_manager
FOREIGN KEY (manager_id)
REFERENCES EMPLOYEES(employee_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_emps_dept
FOREIGN KEY (department_id)
REFERENCES DEPARTMENTS(department_id);

ALTER TABLE DEPARTMENTS
ADD CONSTRAINT fk_depts_manager
FOREIGN KEY (manager_id)
REFERENCES EMPLOYEES(employee_id);

ALTER TABLE JOB_HISTORY
ADD CONSTRAINT fk_jh_employee
FOREIGN KEY (employee_id)
REFERENCES EMPLOYEES(employee_id);

ALTER TABLE JOB_HISTORY
ADD CONSTRAINT fk_jh_job
FOREIGN KEY (job_id)
REFERENCES JOBS(job_id);

ALTER TABLE JOB_HISTORY
ADD CONSTRAINT fk_jh_dept
FOREIGN KEY (department_id)
REFERENCES DEPARTMENTS(department_id);


--punkt 2

INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
VALUES ('IT_PROG', 'Programista', 4000, 8000);

INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
VALUES ('HR_REP', 'Specjalista ds. HR', 3000, 6000);

INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
VALUES ('SA_REP', 'Przedstawiciel Handlowy', 3500, 7500);

INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
VALUES ('FI_MGR', 'Menedzer Finansowy', 8000, 15000);


-- punkt 3
INSERT INTO EMPLOYEES
(employee_id, first_name, last_name, email,
 hire_date, job_id, salary)
VALUES
(1, 'Jan', 'Kowalski', 'jkowalski@gmail.com',
 TO_DATE('2022-01-10', 'YYYY-MM-DD'),
 'IT_PROG', 5000);

INSERT INTO EMPLOYEES
(employee_id, first_name, last_name, email,
 hire_date, job_id, salary)
VALUES
(2, 'Anna', 'Nowak', 'anowak@gmail.com',
 TO_DATE('2022-02-23', 'YYYY-MM-DD'),
 'HR_REP', 4000);

INSERT INTO EMPLOYEES
(employee_id, first_name, last_name, email,
 hire_date, job_id, salary)
VALUES
(3, 'Piotr', 'Piotrowski', 'ppiotrowski@gmail.com',
 TO_DATE('2023-04-08', 'YYYY-MM-DD'),
 'SA_REP', 4500);

INSERT INTO EMPLOYEES
(employee_id, first_name, last_name, email,
 hire_date, job_id, salary)
VALUES
(4, 'Mirek', 'Bazych', 'mbazych@gmail.com',
 TO_DATE('2021-11-23', 'YYYY-MM-DD'),
 'IT_PROG', 6000);


-- punkt 4

UPDATE EMPLOYEES
SET manager_id = 1
WHERE employee_id IN (2, 3);


--punkt 5

UPDATE JOBS
SET min_salary = min_salary + 500,
    max_salary = max_salary + 500
WHERE LOWER(job_title) LIKE '%b%'
   OR LOWER(job_title) LIKE '%s%';


--punkt 6

DELETE FROM JOBS
WHERE max_salary > 9000;

--Punkt 7

DROP TABLE JOB_HISTORY;


SELECT *
FROM RECYCLEBIN
WHERE ORIGINAL_NAME = 'JOB_HISTORY';


FLASHBACK TABLE JOB_HISTORY TO BEFORE DROP;



SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;
SELECT * FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM EMPLOYEES;
SELECT * FROM JOB_HISTORY;

COMMIT;
