-- creating states table
CREATE TABLE states (
  state_id SERIAL PRIMARY KEY, 
	state_name VARCHAR (100) NOT NULL
);

-- creating the department table 
CREATE TABLE department (
	dept_id SERIAL PRIMARY KEY,
	dept_name VARCHAR(100) NOT NULL
);

-- creating the salary table 


-- Create the Sales table
CREATE TABLE sales (
   sale_id SERIAL PRIMARY KEY, 
	product_name VARCHAR(100) NOT NULL, 
	sale_amount NUMERIC (10,2) NOT NULL, 
	state_id INT NOT NULL, 
	FOREIGN KEY (state_id) REFERENCES states(state_id)
	
);

-- creating the employee table 

CREATE TABLE employee (
emp_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50) NOT NULL, 
	last_name VARCHAR(50) NOT NULL,
	dept_id INT NOT NULL, 
	FOREIGN KEY (dept_id) REFERENCES department(dept_id)

);


-- DROP TABLE IF EXISTS salary;

ALTER TABLE employee 
ADD COLUMN salary NUMERIC (10,2) NOT NULL;


--populating the department tables 

INSERT INTO department (dept_id, dept_name) VALUES 
(1,'Marketing'),
(2,'Sales'), 
(4,'Finance'),
(3,'Human Resources');

--populating the states tables

INSERT INTO states (state_name, state_id) VALUES 
('California',1), 
('New York',2),
('Texas',3), 
('Florida',4);

INSERT INTO employee (emp_id, first_name, last_name, dept_id, salary) VALUES 
(1,'John', 'Doe',1,6000),
(2, 'Jane', 'Smith',2,70000), 
(3,'Michael', 'Johnson', 3, 80000),
(4,'Emily', 'Williams', 4,65000);

INSERT INTO sales (sale_id, product_name,sale_amount,state_id) VALUES 
(1,'iphone',10000,1),
(2,'ipad',15000,3),
(3,'Macbook',20000,2),
(4,'Apple Watch',34000,4);



-- SELECT table_name 
-- FROM information_schema.tables 
-- WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

-- basic subquery using the WHERE clause 

SELECT * FROM employee
WHERE dept_id IN (SELECT dept_id FROM department WHERE dept_name='Sales');

-- the above query selects all employees who belong to the Sales department.
-- The subquery retrieves the department ID for the Sales department and the
-- the outer query selects all the information from the Sales department 
-- for all employees whose department id matches the sales department 

-- Subquery in WHERE clause 

-- subqueries in the SELECT clause are used to calculate a value 
-- based on the result of another query 
SELECT emp_id, 
		(SELECT AVG (salary) FROM employee) AS avg_salary
		
FROM employee;

-- the above query retrieves the 'emp_id' of each employee along with the 
-- average salary of all employees.The subquery calmculates the average 
-- salary and the outer query returns each employee's 'emp_id' along 
-- with the calculated average salary 

-- correlated subquery:Correlated subqueries are nested queries in which 
-- the inner query references a column from the outer query 

SELECT emp_id, 
			(SELECT dept_name FROM department
			WHERE department.dept_id = employee.dept_id ) AS dept_name
FROM employee


INSERT INTO employee( emp_id, first_name, last_name, dept_id, salary) VALUES
(5, 'Alice', 'Johnson', 2, 100000),
(6, 'Kriel', 'Johnson', 1, 30000),
(7, 'Siya', 'Kolisi', 3, 40000),
(8, 'Jun', 'Xie', 4, 56000),
(9, 'Cory', 'Jane', 1, 93000),
(10, 'Michael', 'Hooper', 3, 570000),
(11, 'Tendai', 'Mtawarira', 4, 75000),
(12, 'Damian', 'De Alande', 2, 51000);



INSERT INTO sales (sale_id, product_name,sale_amount,state_id) VALUES 
(5,'iphone',10000,2),
(6,'ipad',15000,4),
(7,'Apple Watch',20000,3),
(8,'Macbook',34000,1);

select * from sales



-- in this above query,the inner query references the 'dept_id' 
-- column from the outer 'employee' table.It retrieves the department 
-- name for each employee based on the 'dept_id'
			
 -- Next is a correlated subquery in which the names of employees whose 
 -- salary is greater than the average salary of their department 
 

SELECT emp_id, first_name || ' ' || last_name AS employee_name, salary
FROM employee AS e 
WHERE salary > (
    SELECT avg (salary)
    FROM employee 
	WHERE dept_id = e.dept_id
);

-- the above nested query matches the dept_id in the department table
-- with the dept_id in the employee table and in so doing will calculate 
-- the average salary for each department.Then the outer query will select 
-- the emp_id, first_name, last_name for the employees whose salary is 
-- greater than the average salary 


-- to include the calculated average salary for each department in the 
-- query result, we can use a subquery to calculate the average salary 
-- for each department and then join the result of the subquery with the 
-- 'employee' and 'department' tables 


SELECT e.emp_id, e.first_name || ' ' || e.last_name as employee_name, 
e.salary,d.dept_name,d.dept_id, avg_salary.avg_dept_salary
FROM employee as e 
JOIN department as d ON e.dept_id = d.dept_id
JOIN (
       SELECT dept_id, avg(salary) as avg_dept_salary
	   FROM employee 
	   GROUP BY dept_id
 ) as  avg_salary ON e.dept_id = avg_salary.dept_id;
 
 
 -- the below query will return the average salary value for each 
 -- department based on the condition that only employees whose 
 -- salaries surpass the average salary of their department is 
 -- SELECTED 
 
 SELECT e.emp_id, 
        e.first_name || ' ' || e.last_name as emp_name, 
		e.salary, 
		d.dept_name, 
		d.dept_id, 
		avg_salary.avg_dept_salary
 FROM employee as e
 JOIN department as d on e.dept_id = d.dept_id
 JOIN (
    SELECT dept_id, avg(salary) AS avg_dept_salary
	 FROM employee
	 GROUP BY dept_id
 ) as avg_salary ON e.dept_id = avg_salary.dept_id
 WHERE e.salary > avg_salary.avg_dept_salary


-- subquery with aggregations: for instance in this context we 
-- find the total sales amount for every state and with the state names

SELECT state_name, 
			(SELECT SUM(sale_amount) FROM sales WHERE state_id = s.state_id) as total_sales

FROM states as s;

-- the above query utilizes a subquery with aggregation to calculate the 
-- total sales amount ('SUM(sale_amount)') for every state ('WHERE state_id = 
 -- s.state_id') correlates the subquery with the outer query .
 
 
-- a subquery  with JOIN and HAVING.For example when we want to find 
-- the departments with at least 2 employees earning a salary higher 
-- than the department's average salary;we can use JOIN and HAVING 


--Subquery with INTERSECT:Suppose we want to find employees who have made 
-- iphone and Macbook sales 

SELECT sale_id
FROM sales 
WHERE product_name IN ('Macbook') 
INTERSECT 
SELECT sale_id
FROM sales 
WHERE product_name IN ('iphone')












































































































