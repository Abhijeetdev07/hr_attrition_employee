CREATE DATABASE hr_employee_attrition_details;
use hr_employee_attrition_details;

-- basic analyze

select * from hr_employee_attrition_clean;

select count(*) from hr_employee_attrition_clean;

alter table hr_employee_attrition_clean rename to hr_attrition;

select * from hr_attrition;

SELECT COUNT(*) FROM hr_attrition;

describe hr_attrition;

SELECT COUNT(*) AS total_columns 
FROM information_schema.columns 
WHERE table_name = 'hr_attrition';



-- business query

-- Display the first 10 rows from the table.
SELECT * FROM hr_attrition LIMIT 10;


-- Find the total number of employees in the company.
SELECT COUNT(8) AS Total_Employees FROM hr_attrition;


-- List all unique departments.
SELECT DISTINCT(department) FROM hr_attrition;


-- Show how many employees have left the company and how many are still working.
SELECT  attrition, COUNT(attrition) as employees_count FROM hr_attrition GROUP BY attrition;


-- Retrieve the list of employees who work overtime.
SELECT * FROM hr_attrition WHERE over_time ='Yes';
SELECT COUNT(*) FROM hr_attrition WHERE over_time ='Yes';


-- Find the average monthly income of all employees.
SELECT ROUND(AVG(monthly_income),2) as Average_Monthly_Income FROM hr_attrition;


-- Identify employees whose number of companies worked is missing (NULL).
SELECT * FROM hr_attrition WHERE num_companies_worked = 0;
SELECT COUNT(*) FROM hr_attrition WHERE num_companies_worked = 0;


-- Find the employee(s) with the maximum monthly income.
SELECT * FROM hr_attrition WHERE monthly_income = (SELECT MAX(monthly_income) FROM hr_attrition);


-- Count the number of employees by gender.
SELECT gender, COUNT(gender) FROM hr_attrition GROUP BY gender;


-- List all employees who have just joined (YearsAtCompany = 0).
SELECT * FROM hr_attrition WHERE years_at_company = 0;

-- Calculate the attrition rate (%) by department.
select
      department,
      count(*) as employees_count,
      sum(case when attrition = 'Yes' then 1 else 0 end) as leaved,
      round((sum(case when attrition = 'Yes' then 1 else 0 end)/count(*)*100),2) as attrition_rate
      from hr_attrition
group by department ORDER BY attrition_rate DESC;


-- SELECT * FROM hr_attrition ORDER BY total_working_years DESC LIMIT 10;
SELECT * FROM hr_attrition ORDER BY total_working_years DESC LIMIT 10;

-- Group employees into tenure categories (<1yr, 1–3yr, 4–6yr, 7+yr) and count employees in each

select * from hr_attrition;
select attrition,
       monthly_income,
       case
           when years_at_company < 1 then '<1_yr'
           when years_at_company >=1 and years_at_company <= 3 then '1-3_yr'
           when years_at_company >=4 and years_at_company <= 6 then '4-6_yr'
           else '7+_yr'
       end as company_experience
from hr_attrition order by monthly_income desc;

alter table hr_attrition add column experience varchar(20);
update hr_attrition set experience = case
           when years_at_company < 1 then '<1_yr'
           when years_at_company >=1 and years_at_company <= 3 then '1-3_yr'
           when years_at_company >=4 and years_at_company <= 6 then '4-6_yr'
           else '7+_yr'
       end ;



SELECT attrition, experience,COUNT(experience) FROM hr_attrition GROUP BY attrition,experience ORDER BY experience DESC;


-- Find the average monthly income by job level and attrition status.
SELECT job_level,attrition, AVG(monthly_income) FROM hr_attrition GROUP BY job_level , attrition;


-- Identify the top 5 job roles with the highest number of employees who left.

SELECT Job_Role, COUNT(*) AS emp_leaves
FROM hr_attrition
WHERE Attrition = 'Yes'
GROUP BY Job_Role
ORDER BY emp_leaves DESC
LIMIT 5;


-- List employees who left the company within their first year.
SELECT * FROM hr_attrition WHERE years_at_company < 1 and attrition = 'Yes';
SELECT count(*) from hr_attrition WHERE years_at_company < 1 and attrition = 'Yes'; 

-- Count employees grouped by overtime status and attrition.

-- Calculate each employee’s approximate new monthly compensation after applying their salary hike percentage.
SELECT 
    employee_number,
    monthly_income,
    percent_salary_hike,
    ROUND(monthly_income * (1 + percent_salary_hike / 100.0), 2) AS new_monthly_income
FROM hr_attrition;

-- Count employees grouped by overtime status and attrition.

select over_time,
attrition,count(*) as emp_count
 from hr_attrition
  group by over_time,attrition order by over_time desc;



-- Display the top 10 employees who attended the most training sessions last year.
select * from hr_attrition  order by training_times_last_year desc limit 10;



-- Rank employees by total working years (most experienced = rank 1).
SELECT 
    employee_number,
    total_working_years,
    RANK() OVER (ORDER BY total_working_years DESC) AS experience_rank
FROM hr_attrition
ORDER BY experience_rank;

-- For each department, find employees whose monthly income is in the top 25% of that department.
WITH income_quartiles AS (
    SELECT 
        employee_number,
        department,
        monthly_income,
        NTILE(4) OVER (PARTITION BY department ORDER BY monthly_income DESC) AS income_quartile
    FROM hr_attrition
)
SELECT 
    employee_number,
    department,
    monthly_income
FROM income_quartiles
WHERE income_quartile = 1
ORDER BY department, monthly_income DESC;


-- 22. Divide employees into 10 income deciles and find attrition rate for each decile.
WITH income_deciles AS (
    SELECT 
        employee_number,
        monthly_income,
        attrition,
        NTILE(10) OVER (ORDER BY monthly_income ASC) AS income_decile
    FROM hr_attrition
)
SELECT 
    income_decile,
    MIN(monthly_income) AS min_income,
    MAX(monthly_income) AS max_income,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM income_deciles
GROUP BY income_decile
ORDER BY income_decile;


-- 23. Create a simple risk score based on tenure, performance, overtime, and work-life balance — and list the top 50 high-risk employees.

SELECT 
    employee_number,
    department,
    job_role,
    years_at_company,
    performance_rating,
    over_time,
    work_life_balance,
    (
        (CASE WHEN over_time = 'Yes' THEN 3 ELSE 0 END) +
        (CASE WHEN work_life_balance = 1 THEN 3
              WHEN work_life_balance = 2 THEN 2
              WHEN work_life_balance = 3 THEN 1
              ELSE 0 END) +
        (CASE WHEN years_at_company <= 1 THEN 3
              WHEN years_at_company <= 3 THEN 2
              WHEN years_at_company <= 5 THEN 1
              ELSE 0 END) +
        (CASE WHEN performance_rating = 3 THEN 2 ELSE 1 END)
    ) AS attrition_risk_score
FROM hr_attrition
ORDER BY attrition_risk_score DESC, years_at_company ASC
LIMIT 50;


-- 24. Create a summary view showing, for each department and job level: total employees, number of leavers, attrition rate, and average monthly income.
-- CREATE OR REPLACE VIEW view_dept_joblevel_attrition_summary AS
SELECT 
    department,
    job_level,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS number_of_leavers,
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM hr_attrition
GROUP BY department, job_level
ORDER BY department, job_level;

-- Query the view
SELECT * FROM view_dept_joblevel_attrition_summary;
