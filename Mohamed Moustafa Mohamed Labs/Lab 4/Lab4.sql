create procedure std_per_dept
as
	select count(std.St_Id) as [Students Number], dept.Dept_Name as [Department name]
	from studs.Student as std, Department as dept
	where std.Dept_Id = dept.Dept_Id
	group by dept.Dept_Name

--caling
std_per_dept

---------------------------------------------------------------------------------------------
use SD

create procedure check_for_no_emps
as
	declare @no int
	select @no = COUNT(EmpNo) from Works_on where ProjectNo = 1
	if @no >= 3
		begin
			select 'The number of employees in the project p1 is 3 or more'
		end
	else
		begin
			select em.EmpFname as [First Name], em.EmpLname as [Last Name]
			from HR.Employee as em, Works_on as wo
			where em.DeptNo = wo.EmpNo
			and wo.ProjectNo = 1
		end
--caling
check_for_no_emps


---------------------------------------------------------------------------------------------

create procedure update_emp_proj @old_emp_no int, @new_emp_no int, @proj_no int 
as
	update Works_on set EmpNo = @new_emp_no where EmpNo = @old_emp_no and ProjectNo = @proj_no

--caling
update_emp_proj 28559, 9031, 2

---------------------------------------------------------------------------------------------

create table proj_audit
(
	ProjNo int,
	UserName varchar(100),
	ModifaiedDate date,
	Budget_old int,
	Budget_new int
)

create trigger proj_t
on [Comp_Schema].[Project]
instead of update
as
	if update(Budget)
		begin
			declare @old int,@new int, @proj_id int
			select @old = Budget from deleted
			select @new = Budget from inserted
			select @proj_id = ProjectNo from Comp_Schema.Project where Budget = @old
			insert into proj_audit
			values(@proj_id, suser_name(), getdate(), @old, @new)
		end
-- test
update Comp_Schema.Project set Budget = 20000 where ProjectNo = 1

---------------------------------------------------------------------------------------------
use ITI
create trigger prevent_insert
on Department
instead of insert
as
	select 'not allowed to insert into this table'

--test
insert into Department(Dept_Id, Dept_Name, Dept_Desc, Dept_Location) values(100, 'MB', 'Mobile', 'Giza')

-----------------------------------------------------------------------------------------------------------

alter trigger studs.prevent_insert_in_feb
on studs.Student
instead of insert
as
	if format(getdate(),'MMMM')='March'
		select 'not allowed in March'
	else
		insert into studs.Student
		select * from inserted

--test
insert into studs.Student(St_Id, St_Fname) values(24, 'Mohamed')

-------------------------------------------------------------------------------
use ITI

create table student_audit
(
	UserName varchar(100),
	Date date,
	Note varchar(max)
)
alter trigger studs.after_insert_into_student
on studs.Student
after insert
as
	declare @note varchar(300)
	set @note = SUSER_NAME() + ' insert new row with key in' + CONVERT(varchar(10), @@IDENTITY) +' table Student'
	insert into student_audit values(SUSER_NAME(), GETDATE(), @note)

--test
insert into studs.Student(St_Id) values(98)

---------------------------------------------------------------------------------------------

alter trigger studs.after_delete_into_student
on studs.Student
instead of delete
as
	declare @last_id as varchar(10)
	set @last_id = @@IDENTITY
	declare @note varchar(300)
	set @note = SUSER_NAME() + ' try to delete row with key ' + @last_id + ' from table Student'
	insert into student_audit values(SUSER_NAME(), GETDATE(),  cast(@note as varchar(max)))

--test
delete from studs.Student where St_Id = 15