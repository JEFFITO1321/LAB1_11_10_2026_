SELECT table_name
FROM user_tables
ORDER BY table_name;

-- ZADANIE 1
SELECT last_name || ' - ' || salary AS wynagrodzenie
FROM employees
WHERE departament_id IN (20, 50)
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name ASC;


-- ZADANIE 2 (przy &kolumna wpisz np. departament_id)
SELECT hire_date, last_name, &kolumna
FROM employees
WHERE manager_id IS NOT NULL
AND hire_date >= DATE '2005-01-01'
AND hire_date < DATE '2006-01-01'
ORDER BY &kolumna;


-- ZADANIE 3 (przy &czesc_imienia wpisz np. an)
SELECT first_name || ' ' || last_name AS imie_nazwisko,
       salary,
       phone_number
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e'
AND LOWER(first_name) LIKE '%' || LOWER('&czesc_imienia') || '%'
ORDER BY 1 DESC, 2 ASC;


-- ZADANIE 4
SELECT first_name,
       last_name,
       liczba_miesiecy,
       CASE
           WHEN liczba_miesiecy < 150  THEN salary * 0.10
           WHEN liczba_miesiecy <= 200 THEN salary * 0.20
           ELSE salary * 0.30
       END AS wysokosc_dodatku
FROM (
    SELECT first_name,
           last_name,
           salary,
           ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS liczba_miesiecy
    FROM employees
)
ORDER BY liczba_miesiecy;


-- ZADANIE 5
SELECT departament_id,
       SUM(salary) AS suma_zarobkow,
       ROUND(AVG(salary)) AS srednie_zarobki
FROM employees
GROUP BY departament_id
HAVING MIN(salary) > 5000;


-- ZADANIE 6
SELECT e.last_name,
       e.departament_id,
       d.departament_name,
       e.job_id
FROM employees e
JOIN departamens d
ON e.departament_id = d.departament_id
JOIN locations l
ON d.location_id = l.locations_id
WHERE l.city = 'Toronto';


-- ZADANIE 7
SELECT e1.first_name,
       e1.last_name,
       e2.first_name AS wspolpracownik,
       e2.last_name AS nazwisko_wspolpracownika
FROM employees e1
JOIN employees e2
ON e1.departament_id = e2.departament_id
WHERE e1.first_name = 'Jennifer'
AND e1.ROWID <> e2.ROWID;


-- ZADANIE 8
SELECT d.departament_id,
       d.departament_name
FROM departamens d
LEFT JOIN employees e
ON d.departament_id = e.departament_id
WHERE e.departament_id IS NULL;


-- ZADANIE 9
WITH job_grades (grade_level, lowest_sal, highest_sal) AS (
    SELECT 'A', 1000, 2999 FROM dual
    UNION ALL SELECT 'B', 3000, 5999 FROM dual
    UNION ALL SELECT 'C', 6000, 9999 FROM dual
    UNION ALL SELECT 'D', 10000, 14999 FROM dual
    UNION ALL SELECT 'E', 15000, 24999 FROM dual
    UNION ALL SELECT 'F', 25000, 40000 FROM dual
)
SELECT e.first_name,
       e.last_name,
       e.job_id,
       d.departament_name,
       e.salary,
       g.grade_level
FROM employees e
LEFT JOIN departamens d
ON e.departament_id = d.departament_id
JOIN job_grades g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal;

-- ZADANIE 10
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;


-- ZADANIE 11
WITH emp (id, imie, nazwisko, email, telefon, data_zatr, job, pensja, menedzer, dept) AS (
    SELECT * FROM employees
)
SELECT id AS employee_id,
       imie AS first_name,
       nazwisko AS last_name
FROM emp
WHERE dept IN (
    SELECT dept
    FROM emp
    WHERE LOWER(nazwisko) LIKE '%u%'
);


-- ZADANIE 12
SELECT first_name,
       last_name,
       hire_date
FROM employees
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) > (
    SELECT AVG(MONTHS_BETWEEN(SYSDATE, hire_date))
    FROM employees
);


-- ZADANIE 13
SELECT d.departament_name,
       COUNT(e.departament_id) AS liczba_pracownikow,
       AVG(e.salary) AS srednie_wynagrodzenie
FROM departamens d
LEFT JOIN employees e
ON d.departament_id = e.departament_id
GROUP BY d.departament_id, d.departament_name
ORDER BY liczba_pracownikow DESC;


-- ZADANIE 14
SELECT first_name,
       last_name
FROM employees
WHERE salary < (
    SELECT MIN(e.salary)
    FROM employees e
    JOIN departamens d
    ON e.departament_id = d.departament_id
    WHERE d.departament_name = 'IT'
);


-- ZADANIE 15
SELECT DISTINCT d.departament_id,
       d.departament_name
FROM departamens d
JOIN employees e
ON d.departament_id = e.departament_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
);


-- ZADANIE 16
SELECT j.job_title,
       AVG(e.salary) AS srednie_zarobki
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
GROUP BY j.job_id, j.job_title
ORDER BY srednie_zarobki DESC
FETCH FIRST 5 ROWS ONLY;


-- ZADANIE 17
SELECT r.region_name,
       COUNT(DISTINCT c.country_id) AS liczba_krajow,
       COUNT(e.departament_id) AS liczba_pracownikow
FROM regions r
LEFT JOIN country c
ON r.region_id = c.region_id
LEFT JOIN locations l
ON c.country_id = l.country_id
LEFT JOIN departamens d
ON l.locations_id = d.location_id
LEFT JOIN employees e
ON d.departament_id = e.departament_id
GROUP BY r.region_id, r.region_name;


-- ZADANIE 18
WITH emp (id, imie, nazwisko, email, telefon, data_zatr, job, pensja, menedzer, dept) AS (
    SELECT * FROM employees
)
SELECT e.imie AS first_name,
       e.nazwisko AS last_name,
       e.pensja AS salary,
       m.imie AS imie_menedzera,
       m.nazwisko AS nazwisko_menedzera,
       m.pensja AS zarobki_menedzera
FROM emp e
JOIN emp m
ON e.menedzer = m.id
WHERE e.pensja > m.pensja;

-- ZADANIE 19
SELECT TO_CHAR(hire_date, 'MONTH') AS miesiac,
       COUNT(*) AS liczba_pracownikow
FROM employees
GROUP BY TO_CHAR(hire_date, 'MM'),
         TO_CHAR(hire_date, 'MONTH')
ORDER BY TO_CHAR(hire_date, 'MM');


-- ZADANIE 20
SELECT d.departament_name,
       AVG(e.salary) AS srednie_wynagrodzenie
FROM departamens d
JOIN employees e
ON d.departament_id = e.departament_id
GROUP BY d.departament_id, d.departament_name
ORDER BY srednie_wynagrodzenie DESC
FETCH FIRST 3 ROWS ONLY;