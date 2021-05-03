select * from [dbo].[Sheet1$];

SELECT *
FROM [dbo].[Sheet1$] Emp1
WHERE (2) = (
    SELECT COUNT(DISTINCT(Salary))
    FROM [dbo].[Sheet1$] Emp2
    WHERE Emp2.Salary > Emp1.Salary)
