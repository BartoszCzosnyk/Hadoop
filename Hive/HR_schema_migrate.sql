-- Migrate HR schema from Oracle Database

-- create database
create database HR;

-- countries table
CREATE TABLE IF NOT EXISTS hr.countries (country_id String COMMENT 'Primary key of countries table.',
									  country_name String COMMENT 'Country name', 
									  region_id int COMMENT 'Region ID for the country. Foreign key to region_id column in the departments table.')
COMMENT 'Countries available'
PARTITIONED BY(region int)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

-- departments table
CREATE TABLE IF NOT EXISTS hr.departments (department_id int COMMENT 'Primary key column of departments table.',
									  department_name String COMMENT 'Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public', 
									  manager_id int COMMENT 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.',
									  location_id int COMMENT 'Location id where a department is located. Foreign key to location_id column of locations table.')
COMMENT 'Departments table that shows details of departments where employees work.'
PARTITIONED BY(department int, manager int, location int)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

-- regions table
CREATE TABLE IF NOT EXISTS hr.regions (region_id int,
									  region_name String)									
PARTITIONED BY(region int)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

-- locations table
CREATE TABLE IF NOT EXISTS hr.locations (location_id int COMMENT 'Primary key of locations table',
									  street_address String COMMENT 'Street address of an office, warehouse, or production site of a company.Contains building number and street name', 
									  postal_code String COMMENT 'Postal code of the location of an office, warehouse, or production siteof a company.',
									  city String COMMENT 'A not null column that shows city where an office, warehouse, or production site of a company is located. ',
									  state_province String COMMENT 'State or Province where an office, warehouse, or production site of acompany is located.',
									  country_id int COMMENT 'Country where an office, warehouse, or production site of a company islocated. Foreign key to country_id column of the countries table.')
COMMENT 'Locations table that contains specific address of a specific office, wareouse, and/or production site of a company. Does not store addresses /locations of customers.'
PARTITIONED BY(location int, country String)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

-- jobs table
CREATE TABLE IF NOT EXISTS hr.jobs (job_id int COMMENT 'Primary key of jobs table.',
									  job_title String COMMENT 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT', 
									  min_salary int COMMENT 'Minimum salary for a job title.',
									  max_salary int COMMENT 'Maximum salary for a job title')
COMMENT 'jobs table with job titles and salary ranges.'									  
PARTITIONED BY(job int)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

-- job_history table
CREATE TABLE IF NOT EXISTS hr.job_history (employee_id int COMMENT 'A not null column in the complex primary key employee_id+start_date.Foreign key to employee_id column of the employee table',
									  start_date date COMMENT 'A not null column in the complex primary key employee_id+start_date.Must be less than the end_date of the job_history table.', 
									  end_date date COMMENT 'greater than the start_date of the job_history table.',
									  job_id int COMMENT 'Job role in which the employee worked in the past foreign key tojob_id column in the jobs table. A not null column.',
									  department_id int COMMENT 'Department id in which the employee worked in the past foreign key to deparment_id column in the departments table')
COMMENT 'Table that stores job history of the employees. If an employeechanges departments within the job or changes jobs within the department,new rows get inserted into this table with old job information of theemployee.'
PARTITIONED BY(employee int, job int, department int)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

-- employees table
CREATE TABLE IF NOT EXISTS hr.employees (employee_id int COMMENT 'Primary key of employees table.',
									  first_name String COMMENT 'First name of the employee. A not null column.', 
									  last_name String COMMENT 'Last name of the employee. A not null column.',
									  email String COMMENT 'Email id of the employee',
									  phone_number String COMMENT 'Phone number of the employee includes country code and area code',
									  hire_date date COMMENT 'Date when the employee started on this job. A not null column.',
									  job_id int COMMENT 'Current job of the employee foreign key to job_id column of thejobs table. A not null column.',
									  salary int COMMENT 'Monthly salary of the employee. Must be greater than zero (enforced by constraint emp_salary_min)',
									  commission_pct double COMMENT 'Commission percentage of the employee Only employees in salesdepartment elgible for commission percentage',
									  manager_id int COMMENT 'Manager id of the employee has same domain as manager_id indepartments table. Foreign key to employee_id column of employees table.(useful for reflexive joins and CONNECT BY query)',
									  department_id int COMMENT 'Department id where employee works foreign key to department_id column of the departments table')
COMMENT 'employees table.'
PARTITIONED BY(employee int, job int, department int, manager int)
ROW FORMAT DELIMITED 
STORED AS SEQUENCEFILE;

