-- DISTINCT--
SELECT distinct first_name, age 
FROM parks_and_recreation.employee_demographics;

-- WHERE--
select *
FROM parks_and_recreation. employee_salary
Where salary < 50000 ;

-- AND OR NOT LOGICAL OPERATOR--
select *
FROM parks_and_recreation. employee_demographics
Where birth_date > '1985-01-01'
AND gender = 'Male'
;

-- LIKE STATMENT-- -- % and _ --
select *
FROM parks_and_recreation. employee_demographics
where first_name LIKE 'a___%'
;

-- Group by
select gender, AVG(age), max(age), min(age), count(age)
FROM parks_and_recreation. employee_demographics
GROUP BY gender
;

-- Order by
select *
FROM parks_and_recreation. employee_demographics
Order by gender, age DESC
;

-- HAVING VS WHERE
select gender, AVG (age) 
FROM parks_and_recreation. employee_demographics
Group by gender
having Avg(age) > 40
;

Select occupation , AVG(salary)
FROM parks_and_recreation. employee_salary
Where occupation Like '%manager%'
group by occupation
Having Avg(salary) > 70000
;

-- Limit and alisaing
select *
FROM parks_and_recreation. employee_demographics
order by age Desc
Limit 3
;

select gender , avg(age)  avg_age
FROM parks_and_recreation. employee_demographics
group by gender
Having avg_age > 40
;

-- Joins 
select dem.employee_id,age,occupation,salary
FROM parks_and_recreation. employee_demographics as dem
Inner join parks_and_recreation. employee_salary as sal 
on dem.employee_id = sal.employee_id
;

-- outer join
select *
FROM parks_and_recreation. employee_demographics as dem
right join parks_and_recreation. employee_salary as sal 
on dem.employee_id = sal.employee_id
;

-- self join
select emp1.employee_id as emp_santa, emp1.first_name as first_name_santa, emp1.last_name as last_name_santa,
emp2.employee_id as emp, emp2.first_name as first_name_emp, emp2.last_name as last_name_emp
FROM parks_and_recreation. employee_salary as emp1
Join parks_and_recreation. employee_salary as emp2
	on emp1.employee_id +1=emp2.employee_id
    ;

-- joining multiple together

select *
FROM parks_and_recreation. employee_demographics as dem
Inner join parks_and_recreation. employee_salary as sal 
on dem.employee_id = sal.employee_id
inner join parks_and_recreation.parks_departments as pd
on sal.dept_id=pd.department_id
;

-- unions
select first_name,last_name, 'old man' as label
FROM parks_and_recreation. employee_demographics
where age > 40 and gender ='male'
Union 
select first_name,last_name, 'old lady' as label
FROM parks_and_recreation. employee_demographics
where age > 40 and gender ='female'
Union
select first_name,last_name, 'highly paid employee' as label
FROM parks_and_recreation. employee_salary
where salary > 65000 
order by first_name,last_name
;

-- string functions
select first_name,left(first_name, 4),birth_date,
substring(birth_date,6,2) as birth_month
FROM parks_and_recreation. employee_demographics
;

select first_name,last_name,
Concat(first_name,' ',last_name) as Full_name
FROM parks_and_recreation. employee_demographics
;

-- Case statment
select first_name,last_name,age,
case
when age <= 30 Then 'young'
when age between 31 and 50 then 'old' 
end as age_bracket
FROM parks_and_recreation. employee_demographics
;
-- pay increase and bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- finance = 10% bonus

Select first_name, last_name, salary,
case
When salary < 50000 Then salary * 1.05
When salary > 50000 Then salary * 1.07
end as new_salary,
case 
when dept_id=6 then salary*.10
end as Bonuses
FROM parks_and_recreation. employee_salary
;

-- Subqueries
Select *
FROM parks_and_recreation. employee_demographics
where employee_id in ( select employee_id
							from parks_and_recreation. employee_salary
                            where dept_id=1
)
;

select first_name,salary,
(select Avg(salary)
from parks_and_recreation.employee_salary)
from parks_and_recreation.employee_salary
;

Select gender, avg(age), min(age),max(age),count(age)
FROM parks_and_recreation. employee_demographics
group by gender;

-- windows function

select dem.employee_id,dem.first_name, dem.last_name ,gender, salary,
row_number() Over (partition by gender order by salary desc) as row_num,
rank () Over (partition by gender order by salary desc) as rank_num,
dense_rank() Over (partition by gender order by salary desc ) as dense_rank_num
from parks_and_recreation.employee_demographics as dem
Join parks_and_recreation.employee_salary as sal
on dem.employee_id=sal.employee_id
;

-- Common table expression

with cte_example as
(
Select gender, avg(salary), min(salary),max(salary),count(salary)
FROM parks_and_recreation.employee_demographics as dem
Join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id
group by gender
)
select *
From cte_example
;

-- temporary tables

create temporary table salary_over_50k 
(id int,
first_name varchar(50),
last_name varchar(50),
salary decimal(1000,4)
);

INSERT INTO salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

select* 
from salary_over_50k;

--  stored procedure

create procedure large_salaries()
select * 
	from employee_salary
	where salary >= 50000
;

Call large_salaries();

Delimiter //

create procedure large_salaries3()
BEGIN
select * 
	from employee_salary
	where salary >= 50000;
select * 
	from employee_salary
	where salary >= 10000;
    
End //
Delimiter ;

Call  large_salaries3()

-- triggers and event--

Select *
from employee_demographics;

Select*
from employee_salary;

delimiter //
create trigger employee_insert
	after insert on employee_salary
    for each row
Begin
	Insert into employee_demographics (employee_id,first_name,last_name)
    values(new.employee_id,new.first_name,new.last_name);
End //
Delimiter ;

Insert into employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
values(13,'Ralph','Matteo','CEO',100000,Null);


-- events

select*
from employee_demographics;

Delimiter //
create event delete_retirees
on schedule every 30 second
Do
Begin
	delete 
    from employee_demographics
    where age>=60;
End //
Delimiter ;

