alter function get_month_name(@date date) 
returns varchar(10)
	begin
		declare @month_name varchar(10)
		    select @month_name=DATENAME(MONTH, @date)
		return @month_name
	end

--calling

select dbo.get_month_name(getdate())

---------------------------------------------------------------

alter function getnums(@no1 int, @no2 int)
returns @t table
			(
			 numbers int
			)
as
	begin
		declare @start_no int = @no1 + 1
		while @start_no < @no2
			begin
				insert into @t
				select @start_no
				set @start_no += 1
			end
		return
			
	end

--caling

select * from getnums(4,10)

-----------------------------------------------------------

create function get_std_dept_full_name(@std_id int)
returns table
as
	return 
		(
		 select std.St_Fname as [Full Name], dept.Dept_Name as [Department Name]
		 from studs.Student as std, Department as dept
		 where std.St_Id = @std_id and std.Dept_Id = dept.Dept_Id
		)

--caling

select * from get_std_dept_full_name(1)

---------------------------------------------------------------

create function get_full_name(@std_id int) 
returns varchar(50)
	begin
		declare @std_f_name varchar(50)
		declare @std_l_name varchar(50)
		declare @result varchar(50)
			set @std_f_name = (select isnull(St_Fname, 'null name') from studs.Student where St_Id = @std_id)
			set @std_l_name = (select isnull(St_Lname,'null name') from studs.Student where St_Id = @std_id)
			set @result = 'First name & last name are not null'
			if @std_f_name = 'null name' and @std_l_name = 'null name'
				set @result = 'First name & last name are null'
			else if @std_f_name = 'null name'
				set @result = 'First name is null'
			else if @std_l_name = 'null name'
				set @result = 'Last name is null'

		return @result
	end

--caling

select dbo.get_full_name(13)

--------------------------------------------------------------------

create function dept_manager_date(@dept_id int)
returns table
as
	return 
		(
		 select Dept_Name as [Department name], Dept_Manager as [Department Manager], Manager_hiredate as [Hiring Date]
		 from Department where Dept_Id = @dept_id
		)
--caling
select * from dept_manager_date(10)

--------------------------------------------------------------------------------------------------------------

alter function get_names(@name varchar(20))
returns @t table
			(
			 std_name varchar(50)
			)
as
	begin
		if @name = 'first name'
			insert into @t
			select isnull(St_Fname, 'null name') as [First Name] from studs.Student
		else if @name = 'last name'
			insert into @t
			select isnull(St_Lname, 'null name') as [Last Name] from studs.Student
		else if @name = 'full name'
			insert into @t
			select isnull(St_Lname + St_Lname, 'null name') as [Full Name] from studs.Student
		return	
	end
--caling
select * from get_names('full name')

--------------------------------------------------------------------------------------------------------

select St_Id, SUBSTRING(St_Fname, 1, LEN(St_Fname) - 1) from studs.Student

---------------------------------------------------------------------------------------

update Stud_Course set Grade = null
where St_Id in (select St_Id from studs.Student where Dept_Id = (select Dept_Id from Department where Dept_Name = 'SD'))