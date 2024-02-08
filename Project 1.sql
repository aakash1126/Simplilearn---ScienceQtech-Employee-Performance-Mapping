-- Task 1 -- Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.

Create Database Project;
Create Database Employee;

use project;
use Employee;

describe data_science_team;
describe proj_table;
describe Employee.emp_record_table;

Select * from data_science_team;
select * from proj_table;
Select * from emp_record_table;

-- Task 2 -- Create an ER diagram for the given employee database.
-- ER Diagram I have uploaded on the LMS Portal.  

-- Task 3 -- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.

select Emp_id, first_name, last_name, gender,dept
       from Employee.emp_record_table 
            order by dept;

-- Task 4 -- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
             # less than two
             # greater than four 
             # between two and four 

select Emp_id, first_name, last_name, gender,dept, emp_rating,
case
when emp_rating < 2 then 'Less then 2'
when emp_rating <= 4 then 'Between two and four'
when emp_rating > 4 then 'Greater than four'
end as Rating_status
       from employee.emp_record_table order by emp_rating;

-- Task 5 -- Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.

select concat(First_name,' ',last_name) as Name 
       from employee.emp_record_table
	        where dept = 'Finance';

-- Task 6 -- Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

select e.EMP_ID,e.FIRST_NAME,m.EMP_ID as ManagersID, m.FIRST_NAME as ManagerName
	from employee.emp_record_table e JOIN employee.emp_record_table m ON e.MANAGER_ID = m.EMP_ID;
    

-- Task 7 -- Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

select * from emp_record_table
              where dept = 'Finance'
         Union
select * from emp_record_table
              where dept = 'Healthcare';

-- Task 8 -- Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.

select emp_id, first_name, last_name, role, dept, emp_rating, 
			   max(emp_rating) over (partition by dept order by emp_rating desc) as Maximum_Rating
		       from emp_record_table;

-- TASK 9 -- Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

select role, salary, min(salary) over (partition by role) as Minimum_Salary,
                     max(salary) over (partition by role) as Maximum_Salary
                     from emp_record_table;

-- Task 10 -- Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

select emp_id, first_name, last_name, exp, 
       dense_rank() over (order by exp desc) as Dense_Ranking
												from emp_record_table;

-- Task 11 -- Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.

create view  emp_salary as 
             select emp_id, first_name, last_name, role, country, salary from emp_record_table
                    where salary > 6000;

select * from emp_salary;

-- Task 12 -- Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

select emp_id, first_name, last_name, role from 
               (select * from emp_record_table where exp > 10) as Exp_10;

-- Task 13 -- Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.

call Emp_exp (3);

-- Task 14 -- Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.

DELIMITER $$
USE `sadiqdb`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Task14`(eid   varchar(5)) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	declare ex int;
    declare r varchar(80);
    declare vrole varchar(100);
    declare flag varchar(10);
    select exp,ROLE into ex,VROLE from project.data_science_team where emp_ID = eid;
  
		if ex > 12 and ex < 16 then
			if VROLE = 'Manager' then
				set flag = 'Yes';
			else
				set flag = 'No';
			end if;
			# set r = 'Manager';
		elseif ex > 10 and ex <= 12 then 
			if VROLE = 'LEAD DATA SCIENTIST' then
				set flag = 'Yes';
			else
				set flag = 'No';
			end if;
			#set r = 'LEAD DATA SCIENTIST';
		elseif ex > 5 and ex <=10 then 
			if VROLE = 'SENIOR DATA SCIENTIST' then
				set flag = 'Yes';
			else
				set flag = 'No';
			end if;
			#set r ='SENIOR DATA SCIENTIST';
		elseif ex > 2 and ex <=5 then
			if VROLE = 'ASSOCIATE DATA SCIENTIST' then
				set flag = 'Yes';
			else
				set flag = 'No';
			end if;
			#set r = 'ASSOCIATE DATA SCIENTIST';
		elseif ex <= 2 then
			if VROLE = 'JUNIOR DATA SCIENTIST' then
				set flag = 'Yes';
			else
				set flag = 'No';
			end if;
			#set r = 'JUNIOR DATA SCIENTIST';
		end if;
	

RETURN flag;
END$$

DELIMITER ;
;

SELECT *,Task14(Emp_ID) FROM project.data_science_team;


-- Task 15 -- Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

select * from employee.emp_record_table
              where first_name = 'Eric';

## Before index query the cost and performance is found to be at 2.15 sec
create index First_name on emp_record_table(first_name);

-- Checking indexes
show indexes from emp_record_table;

-- Fetching details using index
select * from emp_record_table where first_name = 'Eric';

## After creating index query the cost and performance is only 0.35 sec

-- Task 16 -- Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

select emp_id, first_name, last_name, salary,emp_rating, round((0.05 * salary * emp_rating),0) as Bonus
       from emp_record_table;

          
-- Task 17 -- Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

select emp_id, first_name, last_name, country, continent, 
               round(avg(salary) over (partition by continent order by country),0) as Average_Salary
                                      from emp_record_table;













