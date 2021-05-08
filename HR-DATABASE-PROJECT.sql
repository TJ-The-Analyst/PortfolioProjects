-- COMPLETED IN: MySQL Workbench --

CREATE DATABASE HR_DATABASE_PROJECT;
USE HR_DATABASE_PROJECT;
SET FOREIGN_KEY_CHECKS=0;


CREATE TABLE employee
(
	emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);

CREATE TABLE branch 
(
	branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch (branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client
(
	client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with
(
	emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier 
(
	branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- CORPORATE

INSERT INTO employee VALUES(100, 'John', 'Doe', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Mary', 'Stue', '1961-05-11', 'F', 110000, 100, 1);


-- DENVER

INSERT INTO employee VALUES(102, 'Mike', 'Manly', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Denver', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Daniela', 'Masters', '1971-06-25', 'F', '63000', 102, 2);
INSERT INTO employee VALUES(104, 'Jenna', 'Johnson', '1980-02-05', 'F', '55000', 102, 2);
INSERT INTO employee VALUES(105, 'Malcolm', 'Robinson', '1958-02-19', 'M', '69000', 102, 2);


-- BOSTON

INSERT INTO employee VALUES(106, 'Joey', 'Manning', '1969-02-05', 'M', '78000', 100, 3);

INSERT INTO branch VALUES(3, 'Boston', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Ando', 'Stone', '1973-07-22', 'M', '65000', 106, 3);
INSERT INTO employee VALUES(108, 'Martin', 'DeCaprio', '1978-10-01', 'M', '71000', 106, 3);


-- BRANCH SUPPLIER

INSERT INTO branch_supplier VALUES(2, 'Stannis Steel', 'Steel');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Machine Parts');
INSERT INTO branch_supplier VALUES(3, 'Patriot Produce', 'Produce');
INSERT INTO branch_supplier VALUES(2, 'J.T Forms & Labels', 'Custom');
INSERT INTO branch_supplier VALUES(3, 'All Admin', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Arthur Aluminum', 'Aluminum');
INSERT INTO branch_supplier VALUES(3, 'Denver Labels', 'Custom Forms');


-- CLIENT

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEX', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Denver Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);


-- WORKS_WITH

INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


-- FIND ALL...

SELECT * FROM employee;

SELECT * FROM works_with;

SELECT * FROM client;

SELECT * FROM branch_supplier;

SELECT * FROM employee
ORDER BY salary DESC;

SELECT * FROM employee
ORDER BY sex, first_name, last_name;

SELECT * FROM employee
LIMIT 5;

SELECT first_name, last_name
FROM employee;

SELECT first_name AS forename, last_name AS surname
FROM employee;

SELECT DISTINCT sex
FROM employee;

SELECT DISTINCT branch_id
FROM employee;


-- FUNCTIONS

SELECT COUNT(emp_id)
FROM employee;

SELECT COUNT(super_id)
FROM employee;

SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1970-01-01';

SELECT AVG(salary)
FROM employee;

SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

SELECT SUM(salary)
FROM employee;

SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;


-- WILDCARDS

-- Find Any Clients's who are an LLC
SELECT * FROM client
WHERE client_name LIKE '%LLC';


-- find any branch suppliers that are in the label business
SELECT * FROM branch_supplier
WHERE supplier_name LIKE '%Label%';


-- find any employee born in October
SELECT * FROM employee
WHERE birth_day LIKE '____-02%';


-- find any clients who are schools
SELECT * FROM client
WHERE client_name LIKE '%school%';

-- UNIONS

-- find a list of employee and branch names
SELECT first_name AS Company_Names
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM client;


-- find a lis of all clients & branch suppliers' names
SELECT client_name, branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;


-- find a list of all moeny spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- JOINS

INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

-- find all branches and the names of thier managers

-- Inner Join
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;


-- Left Join
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id
ORDER BY branch_name DESC;


-- Right Join
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- NESTED QUERIES

-- find names of all employees who have sold over 30,000 to a singe=le client
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN 
(
SELECT works_with.emp_id
FROM works_with
WHERE total_sales > 30000
);


-- find all clients who are handled by the branch that Mike Manly manages
-- assume you know Mike's ID

SELECT client.client_name
FROM client
WHERE client.branch_id = 
(
SELECT branch.branch_id
FROM branch
WHERE branch.mgr_id = 102
LIMIT 1
);

-- TRIGGERS

CREATE TABLE trigger_test
(
	message VARCHAR(100)
);

DELIMITER $$
CREATE
	TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
		INSERT INTO trigger_test VALUES('added new employee');
	END$$
DELIMITER ;


-- add in another employee to test
INSERT INTO employee
VALUES(109, 'Alan', 'Humphrey', '1968-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;

DELIMITER $$
CREATE
	TRIGGER my_trigger1 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
		INSERT INTO trigger_test VALUES(NEW.first_name);
	END$$
DELIMITER ;


-- allow the trigger to return the first name of newly added employees
INSERT INTO employee
VALUES(110, 'Kenny', 'Lauler', '1978-02-19', 'M', 69000, 106, 3);


-- triggers using conditonals
DELIMITER $$
CREATE
	TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
		IF NEW.sex = 'M' THEN
			INSERT INTO trigger_test VALUE('added male employee');
		ELSEIF NEW.sex = 'F' THEN
			INSERT INTO trigger_test VALUES('added female employee');
		ELSE
			INSERT INTO trigger_test VALUES('added other employee');
		END IF;
	END$$
DELIMITER ;

INSERT INTO employee
VALUES(111, 'Patty', 'McClean', '1988-02-19', 'F', 69000, 106, 3);

SET FOREIGN_KEY_CHECKS=1;
