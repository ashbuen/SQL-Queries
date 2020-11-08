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
    "dept_name" VARCHAR   NOT NULL
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
CREATE VIEW employee_name_title AS
SELECT e.emp_no, e.emp_title, e.first_name, e.last_name, t.title
FROM employees AS e
INNER JOIN titles AS t ON
e.emp_title=t.title;

SELECT *
FROM employee_name_title
WHERE emp_no IN(
SELECT emp_no 
FROM dept_manager
WHERE dept_no IN(
SELECT dept_name
)
)

SELECT dept_name FROM departments
WHERE dept_no IN(
	SELECT dept_no
	FROM dept_manager
	WHERE emp_no IN(
	SELECT emp_no
	FROM employees
	WHERE first_name IN(
	SELECT first_name 
	FROM employees
	WHERE last_name IN(
	SELECT last_name
	FROM employees 
	WHERE emp_title IN(
	SELECT emp_title
	FROM employees
	WHERE emp_title IN(
	SELECT title
	FROM titles
	WHERE title LIKE 'manager'
	)
	)
	)
	)
	)
);
-- 4.