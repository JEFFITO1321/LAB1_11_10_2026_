
-- ZADANIE 1
SELECT first_name, last_name, salary,
RANK() OVER (ORDER BY salary DESC) AS ranking
FROM employees;

-- ZADANIE 2
SELECT first_name, last_name, salary,
SUM(salary) OVER () AS suma_pensji
FROM employees;

-- ZADANIE 3
SELECT e.last_name, p.product_name,
SUM(s.quantity * s.unit_price) AS wartosc_sprzedazy,
RANK() OVER (ORDER BY SUM(s.quantity * s.unit_price) DESC) AS ranking
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
JOIN products p ON s.product_id = p.product_id
GROUP BY e.last_name, p.product_name;

-- ZADANIE 4
SELECT e.last_name, p.product_name, s.unit_price, s.quantity,
SUM(s.quantity) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date)) AS liczba_sztuk_dziennie,
SUM(s.quantity * s.unit_price) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date)) AS suma_dzienna,
LAG(s.unit_price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS poprzednia_cena,
LEAD(s.unit_price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS kolejna_cena
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN products p ON s.product_id = p.product_id;

-- ZADANIE 5
SELECT p.product_name, s.unit_price,
TRUNC(s.sale_date, 'MM') AS miesiac,
SUM(s.quantity * s.unit_price) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM')) AS suma_miesieczna,
SUM(s.quantity * s.unit_price) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM') ORDER BY s.sale_date, s.sale_id) AS suma_narastajaca
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- ZADANIE 6
SELECT p.product_name, c.category_name,
TRUNC(s.sale_date) AS dzien,
MAX(CASE WHEN EXTRACT(YEAR FROM s.sale_date) = 2022 THEN s.unit_price END) AS cena_2022,
MAX(CASE WHEN EXTRACT(YEAR FROM s.sale_date) = 2023 THEN s.unit_price END) AS cena_2023,
MAX(CASE WHEN EXTRACT(YEAR FROM s.sale_date) = 2023 THEN s.unit_price END) -
MAX(CASE WHEN EXTRACT(YEAR FROM s.sale_date) = 2022 THEN s.unit_price END) AS roznica_cen
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE EXTRACT(YEAR FROM s.sale_date) IN (2022, 2023)
GROUP BY p.product_name, c.category_name, TRUNC(s.sale_date);

-- ZADANIE 7
SELECT c.category_name, p.product_name, p.price,
MIN(p.price) OVER (PARTITION BY p.category_id) AS minimalna_cena,
MAX(p.price) OVER (PARTITION BY p.category_id) AS maksymalna_cena,
MAX(p.price) OVER (PARTITION BY p.category_id) -
MIN(p.price) OVER (PARTITION BY p.category_id) AS roznica_cen
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- ZADANIE 8
SELECT p.product_name, s.unit_price,
AVG(s.unit_price) OVER (
PARTITION BY s.product_id
ORDER BY s.sale_date
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
) AS srednia_kroczaca
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- ZADANIE 9
SELECT p.product_name, c.category_name, p.price,
ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price) AS ranking_row_number,
DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.price) AS ranking_dense_rank
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- ZADANIE 10
SELECT e.last_name, p.product_name,
s.quantity * s.unit_price AS wartosc_sprzedazy,
SUM(s.quantity * s.unit_price) OVER (
PARTITION BY s.employee_id
ORDER BY s.sale_date, s.sale_id
) AS suma_narastajaca,
RANK() OVER (ORDER BY s.quantity * s.unit_price DESC) AS ranking_globalny
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN products p ON s.product_id = p.product_id;

-- ZADANIE 11
SELECT DISTINCT e.first_name, e.last_name, e.job_title
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id;
