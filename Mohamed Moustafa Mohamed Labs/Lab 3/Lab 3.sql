create view View1(std_full_name, course_name, grade)
as
	select std.St_Fname + '' + std.St_Lname as Student_Full_Name, c.Crs_Name as Course_Name, sc.Grade as Student_Grade
	from studs.Student as std, studs.Course as c, Stud_Course as sc
	where std.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.Grade > 50

select * from View1

--------------------------------------------------------------------------------------------------

create view View2(instructor_name, topic)
with encryption
as
	select inst.Ins_Name, t.Top_Name
	from Instructor inst, Topic t, Ins_Course ic, studs.Course c
	where inst.Ins_Id = ic.Ins_Id and c.Crs_Id = ic.Crs_Id and t.Top_Id = c.Top_Id

select * from View2

--------------------------------------------------------------------------------------------------

create view View3(instuctor_name, department_name)
as
	select inst.Ins_Name, d.Dept_Name
	from Instructor inst, Department d
	where inst.Dept_Id = d.Dept_Id and d.Dept_Name in ('SD','Java')

select * from View3

----------------------------------------------------------------------------------------------------

create view View4(student_id, student_first_name, student_last_name, student_address, student_age, department_id, student_supervisor, seq)
as
	select * from studs.Student
	where St_Address in ('Cairo', 'Alex')
	with check option

select * from View4

update View4
set student_address = 'Tanta' --Error(update failed because the target view either specifies WITH CHECK OPTION)
where student_id = 1

--------------------------------------------------------------------------------------------------

use SD

create view View1(project_name, number_of_emps)
as
	select p.ProjectName, count(wo.EmpNo)
	from Comp_Schema.Project p, Works_on wo
	where wo.ProjectNo = p.ProjectNo
	group by p.ProjectName

select * from View1

------------------------------------------------------------------------------------------------

use ITI

create nonclustered index i1
on Department(Manager_hiredate)

-----------------------------------------------------------------------------------------------

create unique index i2
on studs.Student(St_Age) --Error(duplicate key was found for the object name 'studs.Student' and the index name 'i2'. The duplicate key value is (<NULL>))

-----------------------------------------------------------------------------------------------

create table Daily_Transaction
(
	u_id int,
	Transaction_Amount int
)

create table Last_Transactions
(
	u_id int ,
	Transaction_Amount int
)

merge into Last_Transactions as T
using Daily_Transaction as S
on T.u_id = S.u_id
when matched then
update Set T.Transaction_Amount=S.Transaction_Amount
when not matched then
insert values(S.u_id, S.Transaction_Amount);

------------------------------------------------------------------------------------

select * from(
select * ,row_number() over(partition by Dept_id order by Salary desc) as RN
from Instructor
)as newtable
where RN<=2 AND Salary IS NOT NULL

------------------------------------------------------------------------------------

select * from(
select *,dense_rank() over(partition by Dept_id order by newid()) as DS
from Instructor
)as newtable
where DS=1

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

use SD

alter view v_clerk(employee_number, project_number, enter_date)
as
select EmpNo,ProjectNo,Enter_Date from Works_on
where Job='Clerk'

select * from v_clerk

--------------------------------------------------------------------

create view v_without_budget(project_number, project_name)
as
select ProjectNo,ProjectName from Comp_Schema.Project

SELECT * FROM v_without_budget

-----------------------------------------------------------------

create view v_count (project_name, number_of_jobs)
as
select ProjectName,count(ProjectName) from Comp_Schema.Project P
join Works_on WE
on P.ProjectNo = WE.ProjectNo
group by ProjectName

select * from v_count

------------------------------------------------------------------------

create view v_project_p2
as
select employee_number from v_clerk
where project_number = 2

select * from v_project_p2

------------------------------------------------------------------------

alter view v_without_budget
as
select * from Comp_Schema.Project
where ProjectNo in(1,2)

select * from v_without_budget

------------------------------------------------------------

drop view v_clerk,v_count

-------------------------------------------------------------

create view Emp_D2
as
select EmpNo,EmpLname from HR.Employee
where DeptNo = 2

SELECT * FROM Emp_D2

-----------------------------------------------------------

select EmpLname from Emp_D2
where EmpLname LIKE '%J%'

-----------------------------------------------------------

create view v_dept
as
select DeptNo, DeptName from Comp_Schema.Department

select * from v_dept

---------------------------------------------------------------

insert into v_dept values(4,'Developmet')

select * from v_dept

-----------------------------------------------------------------

create view v_2006_check
as
select EmpNo,ProjectNo,Enter_Date from Works_on
where Enter_Date between '2006-1-1' and '2006-12-30'

select * from v_2006_check
