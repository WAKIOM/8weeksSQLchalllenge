/*We define an employee's total earnings to be their monthly  salary * months  worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2  space-separated integers. The Employee table containing employee data for a company is described as follows:   employee_id, name, months, salary.  where employee_id is an employee's ID number, name is their name, months is the total number of months they've been working for the company, and salary is the their monthly salary. The maximum earnings value is 69952. The only employee with earnings  is Kimberly = 69952, so we print the maximum earnings value (69952) and a count of the number of employees who have earned 69952 (which is 1 ) as two space-separated values.... WRITE AN SQL QUERY to solve this */


SELECT MAX(total_earnings) AS max_earnings, COUNT(*) employees_earning_max
-- subquery to calculate salary * months
FROM (
    SELECT salary * months AS total_earnings
    FROM Employee
) AS earnings
-- Filter for where total earnings equal to maximum earnings
WHERE total_earnings = (
    SELECT MAX(salary * months) AS max_earnings
    FROM Employee
);
