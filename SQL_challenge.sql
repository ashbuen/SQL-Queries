-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/XSrAIt
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title" VARCHAR   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
	CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_name"
     )
);

CREATE TABLE "salaries" (
    "emp_no" VARCHAR   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "salaries" ("");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_emp" ("");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_manager" ("");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("");

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Run all tables to ensure proper data was extracted --
SELECT * FROM departments
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM titles

-- 1. List employee number, full name, sex, and salary --
SELECT emp_no, first_name, last_name, sex FROM employees 
SELECT emp_no, salary FROM salaries

-- 2. List full name and hire date for employees hired in 1986 --
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986';

-- 3. List manager's full name with employee number, dept number, dept name --
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

SELECT * FROM managers_info
WHERE title LIKE '%Manager'

-- 4. List dept of each employee with employee number, full name, and department name --
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

CREATE VIEW employee_departments AS
SELECT di.emp_no, di.dept_no, di.dept_name, e.first_name, e.last_name
FROM departments_info AS di
INNER JOIN employees AS e ON
di.emp_no=e.emp_no;

SELECT * FROM employee_departments

-- 5. List full name and sex of employees with first name "Hercules" and last name begins with "B" --
CREATE VIEW last_names_B AS
SELECT first_name, last_name, sex FROM employees
WHERE last_name LIKE ('B%')
SELECT * FROM last_names_B

CREATE VIEW first_name_Hercules AS
SELECT first_name, last_name, sex FROM employees
WHERE first_name LIKE '%Hercules'
SELECT * FROM first_name_Hercules

CREATE VIEW Hercules_B AS
SELECT f.first_name, l.last_name, f.sex
FROM first_name_Hercules as f
INNER JOIN last_names_B AS l ON
f.first_name=l.first_name

SELECT * FROM Hercules_B

-- 6. List all employees in sales department with full name, employee number and department name --
SELECT first_name, last_name, emp_no FROM employees



-- 7. List all employees in sales AND development departments with employee number, full name, and department name --
SELECT first_name, last_name, emp_no, dept_name 
FROM employee_departments
WHERE dept_name LIKE '%development'

-- 8. List frequency count of employees last name in DESC 
SELECT COUNT(last_name) AS last_name_count, last_name FROM employees
GROUP BY last_name
ORDER BY (last_name_count) DESC

-- -- -- -- -- -- -- -- -- -- -- -- BONUS -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

