create table Department
(
	DeptNo int Primary Key,
	DeptName varchar(50),
)

create type loc from varchar(2) NOT NULL

create rule LocationRule as @Loc in('NY', 'DS', 'KW')

sp_bindrule LocationRule, 'loc'

alter table Department add locat loc default 'NY'

----------------------------------------------------------

create table Employee
(
	EmpNo int Primary Key,
	EmpFname varchar(50) not null,
	EmpLname varchar(50) not null,
	DeptNo int foreign key references Department(DeptNo),
	Salary int unique,
	constraint On_Salary check(Salary < 6000),
)

insert into Employee(EmpNo, EmpFname, EmpLname, DeptNo, Salary) values
																(9031, 'Lisa', 'Bertoni', 2, 4000),
																(2581, 'Elisa', 'Hansel', 2, 3600),
																(28559, 'Sybl', 'Moser', 1, 2900)

----------------------------------------------------------------------------------------------------------

insert into Works_on(EmpNo, ProjectNo, Job) values (11111, 1, 'Analyst')

update Works_on set EmpNo = 11111 where EmpNo = 10102

update Employee set EmpNo = 22222 where EmpNo = 10102

delete from Employee where EmpNo = 10102

-----------------------------------------------------------------------------------

alter table Employee add TelephoneNumber varchar(11)

alter table employee drop column TelephoneNumber

-----------------------------------------------------------------------------------------

create schema Comp_Schema

alter schema Comp_Schema transfer Department

alter schema Comp_Schema transfer Project

create schema HR

alter schema HR transfer Employee

------------------------------------------------------

select CONSTRAINT_NAME, CONSTRAINT_TYPE
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where TABLE_NAME='Employee';

--------------------------------------------------------

create synonym Emp
for HR.Employee

Select * from Employee

Select * from HR.Employee

Select * from Emp

Select * from HR.Emp

------------------------------------------

update Comp_Schema.Project set Budget += Budget * 0.1 where ProjectNo in (select ProjectNo from Works_on where EmpNo = 10102)

--------------------------------------------------------------------------------------------------------------------------------

update Comp_Schema.Department set DeptName = 'Sales' where DeptNo = (select DeptNo from Emp where EmpFname = 'James')

---------------------------------------------------------------------------------------------------------------------------------

update Works_on
set Enter_Date = '12.12.2007' where
ProjectNo = 1
and EmpNo in
(select EmpNo from Emp where DeptNo = (select DeptNo from Comp_Schema.Department where DeptName = 'Sales'))

-------------------------------------------------------------------------------------------------------------------------

delete from Works_on
where EmpNo in
(select EmpNo from Emp where DeptNo = (select DeptNo from Comp_Schema.Department where locat = 'KW'))

---------------------------------------------------------------------------------------------------------------

create schema studs

alter schema studs transfer Student

alter schema studs transfer Course