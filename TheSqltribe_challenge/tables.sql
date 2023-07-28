-- select the schema that you want to create the tables in
USE units;
-- Create table
CREATE TABLE IF NOT EXISTS Customers(
		customer_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_name VARCHAR(50),
        age INT,
        gender VARCHAR(10)
);

-- using auto increment to generate primary key values which start from 1001
ALTER TABLE Customers AUTO_INCREMENT = 1001;
-- insert values into the table
INSERT INTO Customers(customer_name, age, gender)
VALUES  ('John Doe', 35, 'Male'),
		('Jane Smith', 28, 'Female'),
        ('Mike Johnson', 40, 'Male'),
        ('Lisa Brown', 22, 'Female'),
        ('Mark Davis', 45, 'Male'),
        ('Emma White', 31, 'Male'),
        ('Chris Lee', 37, 'Male'),
        ('Sarah Clark', 29, 'Female');
CREATE TABLE IF NOT EXISTS Sales(
		sales_id INT AUTO_INCREMENT PRIMARY KEY,
        product_id INT,
        customer_id INT,
        sales_date DATE,
        sale_amount NUMERIC);

INSERT INTO Sales(product_id, customer_id, sales_date, sale_amount)
VALUES  (101, 1001, '2023-01-01', 200 ),
		(102, 1002, '2023-01-02', 350),
        (103, 1003, '2023-01-03', 120 ),
        (101, 1004, '2023-01-04', 180 ),
        (104, 1005, '2023-01-04', 400 ),
        (102, 1006, '2023-01-05', 250 ),
        (105, 1002, '2023-01-06', 300 ),
        (101, 1007, '2023-01-06', 220 ),
        (103, 1003, '2023-01-07', 180 ),
        (104, 1008, '2023-01-07', 380 );
