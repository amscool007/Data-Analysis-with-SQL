select * from [dbo].[Sheet1$];
select E_name,Salary from [dbo].[Sheet1$] 
where salary = (select max(salary) from [dbo].[Sheet1$] );
select max(Salary) from [dbo].[Sheet1$]
where Salary < (select max(Salary) from [dbo].[Sheet1$]);