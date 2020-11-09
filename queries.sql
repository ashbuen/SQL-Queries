-- Queries --
-- 1
CREATE VIEW employee_salary AS
SELECT e.emp_no, e.first_name, e.last_name, e.sex, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON
e.emp_no=s.emp_no;

SELECT * FROM employee_salary;

-- 2
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986';

-- 3
CREATE VIEW departments_and_employees AS
SELECT de.emp_no, de.dept_no, d.dept_name
FROM dept_emp AS de
INNER JOIN departments AS d ON
de.dept_no=d.dept_no;

SELECT * FROM departments_and_employees;

CREATE VIEW departments_info AS
SELECT dae.emp_no, dae.dept_no, dae.dept_name
FROM departments_and_employees AS dae
INNER JOIN dept_manager AS dm ON
dae.emp_no=dm.emp_no;

SELECT * FROM departments_info;
CREATE VIEW managers AS
SELECT di.emp_no, di.dept_no, di.dept_name, e.first_name, e.last_name, e.emp_title
FROM departments_info AS di
INNER JOIN employees AS e ON
di.emp_no=e.emp_no;

CREATE VIEW managers_info AS
SELECT m.emp_no, m.dept_no, m.dept_name, m.first_name, m.last_name, t.title
FROM managers AS m
INNER JOIN titles AS t ON
m.emp_title=t.title_id;

SELECT * 
FROM managers_info
WHERE title LIKE '%Manager';

-- 4
CREATE VIEW employee_departments AS
SELECT di.emp_no, di.dept_name, e.first_name, e.last_name
FROM departments_info AS di
INNER JOIN employees AS e ON
di.emp_no=e.emp_no;

SELECT * 
FROM employee_departments;

-- 5
CREATE VIEW last_names_B AS
SELECT first_name, last_name, sex 
FROM employees
WHERE last_name LIKE ('B%');
SELECT * FROM last_names_B;

CREATE VIEW first_name_Hercules AS
SELECT first_name, last_name, sex 
FROM employees
WHERE first_name LIKE '%Hercules';
SELECT * FROM first_name_Hercules;

CREATE VIEW Hercules_B AS
SELECT f.first_name, l.last_name, f.sex
FROM first_name_Hercules as f
INNER JOIN last_names_B AS l ON
f.first_name=l.first_name;

SELECT * FROM Hercules_B;

-- 6
SELECT first_name, last_name, emp_no, dept_name 
FROM employee_departments
WHERE dept_name = 'Sales';

-- 7
SELECT first_name, last_name, emp_no, dept_name 
FROM employee_departments
WHERE dept_name = 'Sales'
UNION 
SELECT first_name, last_name, emp_no, dept_name 
FROM employee_departments
WHERE dept_name LIKE 'Development';

-- 8
SELECT COUNT(last_name) AS last_name_count, last_name 
FROM employees
GROUP BY last_name
ORDER BY (last_name_count) DESC;