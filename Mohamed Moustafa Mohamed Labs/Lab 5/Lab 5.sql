declare update_salary cursor
for select Salary from HR.Employee
for update
declare @salary int
open update_salary
fetch update_salary into @salary
while @@FETCH_STATUS=0
	begin  
		if @salary < 3000
			update HR.Employee set Salary = @salary*1.1
			where current of update_salary
		else if @salary >= 3000
			update HR.Employee set Salary = @salary*1.2
			where current of update_salary
		else
			delete from HR.Employee
			where current of update_salary
		fetch update_salary into @salary
	end
close update_salary
deallocate update_salary

------------------------------------------------------------------------------

declare dept_mang cursor
for select Dept_Name, Dept_Manager from Department
for read only
declare @dept varchar(10), @manager int
open dept_mang
fetch dept_mang into @dept, @manager
while @@FETCH_STATUS = 0
	begin
		select @dept, @manager
		fetch dept_mang into @dept, @manager
	end

----------------------------------------------------------------------------

declare all_names cursor
for select distinct St_Fname from studs.Student where St_Fname is not null
for read only
declare @name varchar(20),@all varchar(300)=''
open all_names
fetch all_names into @name
while @@FETCH_STATUS=0
	begin
		set @all=CONCAT(@all,',',@name)
		fetch all_names into @name
	end
select @all
close all_names
deallocate all_names

------------------------------------------------------------------------------

backup database SD
to disk='D:\Career\SD_db.bak'
backup database SD
to disk='D:\Career\SD_db.dif' with differential
backup log SD
to disk='D:\Career\SD_db.trn'

-----------------------------------------------------------------------------

CREATE SEQUENCE studs.seq3
AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10
cycle

update studs.Student set Seq = NEXT VALUE FOR studs.seq3

