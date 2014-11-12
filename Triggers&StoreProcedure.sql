/**
Class: CIS430/CIS530 - Lab Assignment 5
Name: Immanuel I George
Object: Implementing and Creating Triggers,Store Procedure for Delete Insert and Update
**/


/*Question 1.1*/
Drop Table EMPLOYEE_TEST
Drop Table DEPARTMENT_TEST
drop Procedure Audit_Dept


Drop Trigger Department_Insert_Update
Drop Trigger Department__Delete

Drop Table Audit_Dept_Table



/*Question 1.2*/

CREATE TABLE Audit_Dept_Table   /**Create Audit Department Table**/
(
date_of_change Date,
Old_Dname Char(30) ,
New_Dname Char(30),
Old_Dnumber int ,
New_Dnumber int ,
old_Mgr_ssn int,
new_Mgr_ssn int,
);


/*Question 1.3*/
/*Creating Store Procedure*/
Go
create Procedure Audit_Dept
		@date_of_change Date,
		@Old_Dname Char(30) ,
		@New_Dname Char(30),
		@Old_Dnumber tinyint ,
		@New_Dnumber tinyint ,
		@Old_Mgr_ssn int,
		@New_Mgr_ssn int
AS
Declare @count as smallint

Select @count=Count(*)
from   Audit_Dept_Table AD
where  AD.date_of_change = @date_of_change AND AD.Old_Dname = @Old_Dname AND AD.New_Dname = @New_Dname AND AD.Old_Dnumber = @OLD_Dnumber AND AD.New_Dnumber = @Old_Dnumber AND AD.OLD_Mgr_ssn = @Old_Mgr_ssn And Ad.New_Mgr_ssn = @New_Mgr_ssn

if(@count)>0
	Begin
	Print('Audit Table Already Exist')
	Return
	End
Insert into dbo.Audit_Dept_Table
	(date_of_change,Old_Dname,New_Dname,Old_Dnumber,New_Dnumber,OLD_Mgr_ssn,New_Mgr_ssn)
	Values
	(@date_of_change,@Old_Dname,@New_Dname,@Old_Dnumber,@New_Dnumber,@OLD_Mgr_ssn,@New_Mgr_ssn)



/*Create Both Triggers for Update*/
/*Step One*/
GO
Create Trigger Department_Insert_Update
on  Department_Test AFTER Insert,Update
AS

Declare @NewDepartmentDnumber int
Declare @OldDepartmentDnumber  int
Declare @NewDepartmentDname char(30)
Declare @OldDepartmentDname  char(30)
Declare @NewDepartmentMgr_ssn int
Declare @OldDepartmentMgr_ssn  int
Declare @OldDepartmentMgr_start_date  varchar(30)
Declare @DateChange Date


Select @NewDepartmentDnumber = I.Dnumber from Inserted I
Select @OldDepartmentDnumber = D.Dnumber from Deleted D
Select @NewDepartmentDname = I.Dname from Inserted I
Select @OldDepartmentDname = D.Dname from Deleted D
Select @NewDepartmentMgr_ssn = I.Mgr_ssn from Inserted I
Select @OldDepartmentMgr_ssn = D.Mgr_ssn from Deleted D
Select @OldDepartmentMgr_start_date = D.Mgr_start_date from Deleted D
Select @DateChange = GETDATE();



Insert into dbo.Audit_Dept_Table
	(date_of_change,Old_Dname,New_Dname,Old_Dnumber,New_Dnumber,OLD_Mgr_ssn,New_Mgr_ssn)
	Values
	(@DateChange,@OldDepartmentDname,@NewDepartmentDname,@OldDepartmentDnumber,@NewDepartmentDnumber,@OldDepartmentMgr_ssn,@NewDepartmentMgr_ssn)

IF EXISTS(Select * from inserted)
	Begin
	Update EMPLOYEE_TEST
	SET 
		Dno = @NewDepartmentDnumber
	From EMPLOYEE_TEST
	Inner Join
		deleted
		 on Dno = @OldDepartmentDnumber
	Inner Join
		inserted
		On @OldDepartmentMgr_ssn = Ssn

	Update EMPLOYEE_TEST
	SET 
		Dno = @NewDepartmentDnumber
	From EMPLOYEE_TEST
	Inner Join
		deleted
		 on Dno = @OldDepartmentDnumber

	Inner Join
		inserted
		On @OldDepartmentMgr_ssn = Super_Ssn
	
	End
GO
	

	
/*Create Trigger for Delete
Step Two*/
Create Trigger Department__Delete
on  Department_Test AFTER Delete
AS

Declare @NewDepartmentDnumber int
Declare @OldDepartmentDnumber  int
Declare @NewDepartmentDname char(30)
Declare @OldDepartmentDname  char(30)
Declare @NewDepartmentMgr_ssn int
Declare @OldDepartmentMgr_ssn  int
Declare @OldDepartmentMgr_start_date  varchar(30)
Declare @DateChange Date


Select @NewDepartmentDnumber = I.Dnumber from Inserted I
Select @OldDepartmentDnumber = D.Dnumber from Deleted D
Select @NewDepartmentDname = I.Dname from Inserted I
Select @OldDepartmentDname = D.Dname from Deleted D
Select @NewDepartmentMgr_ssn = I.Mgr_ssn from Inserted I
Select @OldDepartmentMgr_ssn = D.Mgr_ssn from Deleted D
Select @OldDepartmentMgr_start_date = D.Mgr_start_date from Deleted D
Select @DateChange = GETDATE();



Insert into dbo.Audit_Dept_Table
	(date_of_change,Old_Dname,New_Dname,Old_Dnumber,New_Dnumber,OLD_Mgr_ssn,New_Mgr_ssn)
	Values
	(@DateChange,@OldDepartmentDname,@NewDepartmentDname,@OldDepartmentDnumber,@NewDepartmentDnumber,@OldDepartmentMgr_ssn,@NewDepartmentMgr_ssn)

	
IF EXISTS(select * From deleted)
	
	Begin
	Set @NewDepartmentDnumber = 1
	INSERT INTO DEPARTMENT_TEST(Dname,Dnumber,Mgr_ssn,Mgr_start_date)
		VALUES (@OldDepartmentDname,@NewDepartmentDnumber,@OldDepartmentMgr_ssn,@OldDepartmentMgr_start_date);
	if Exists(Select * from Department_Test where Dnumber = @NewDepartmentDnumber)
		BEGIN
			
			Update EMPLOYEE_TEST
			SET Dno =@NewDepartmentDnumber
			From EMPLOYEE_TEST
			Right Join DEPARTMENT_TEST
			on Dno = @OldDepartmentDnumber
			where (Dno = @OldDepartmentDnumber) and (EMPLOYEE_TEST.Dno = @OldDepartmentDnumber)
	
		END
	

	End
Go




--Queries

Update Department_Test 
SET Dnumber =99
where Dnumber = 4;


Delete from DEPARTMENT_TEST
where Dnumber = 5

select * from Department_Test
select * from EMPLOYEE_TEST

select * from Audit_Dept_Table
Drop Trigger Department__Delete


INSERT INTO DEPARTMENT_TEST(Dname,Dnumber,Mgr_ssn,Mgr_start_date)
VALUES ('SQL CLASS',9,99999999,'Today is 20th');

INSERT INTO DEPARTMENT_TEST(Dname,Dnumber,Mgr_ssn,Mgr_start_date)
VALUES ('LAB 5 TESTING',500,56478,'6/8/1950');

select * from Audit_Dept_Table

Drop Trigger Department_Insert_Update

Delete from DEPARTMENT_TEST
where Dnumber = 500

select * from Audit_Dept_Table

