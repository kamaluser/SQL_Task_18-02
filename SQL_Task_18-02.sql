CREATE DATABASE Restaurant
USE Restaurant

CREATE TABLE Meals
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100),
	Price DECIMAL(18,2)
)

CREATE TABLE Tables
(
	Id INT PRIMARY KEY IDENTITY,
	No INT UNIQUE
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY, 
	Meal_Id INT,
	Table_Id INT,
	Order_Date DATETIME2,
	FOREIGN KEY (Meal_Id) REFERENCES Meals(Id),
	FOREIGN KEY (Table_Id) REFERENCES Tables(Id)
)

INSERT INTO Meals(Name, Price)
VALUES
(N'Pizza', 18),
(N'Burger', 9),
(N'Tost', 5),
(N'Manqal Salatı', 6),
(N'Sezar Salatı', 11),
(N'Tomat Supu', 5)


INSERT INTO Tables
VALUES
(11),
(12),
(13),
(14),
(15),
(16)



INSERT INTO Orders(Id, Meal_Id, Table_Id, Order_Date)
VALUES
(1, 1, 3, '2022-02-15 15:30:00'),
(2, 1, 4, '2022-03-13 16:35:00'),
(3, 2, 1, '2022-04-15 18:20:00'),
(4, 6, 2, '2022-05-18 10:30:00'),
(5, 4, 3, '2022-07-22 18:30:00'),
(6, 5, 5, '2022-08-21 15:45:00'),
(7, 3, 5, '2022-05-23 11:45:00'),
(8, 5, 6, '2022-11-22 09:30:00'),
(9, 4, 4, '2022-10-20 14:22:00'),
(10, 6, 4, '2022-09-18 11:33:00'),
(11, 2, 2, '2022-01-09 16:38:00'),
(12, 2, 1, '2022-12-07 19:32:00')

-- Bütün masa datalarını yanında o masaya edilmiş sifariş sayı ilə birlikdə select edən query

SELECT *, (SELECT COUNT(*) FROM Orders WHERE Table_Id = Tables.Id) AS Order_Count FROM Tables

-- Bütün yeməkləri o yeməyin sifariş sayı ilə select edən query

SELECT *, (SELECT COUNT(*) FROM Orders WHERE Orders.Meal_Id = Meals.Id) AS Order_Count FROM Meals

-- Bütün sirafiş datalarını yanında yeməyin adı ilə select edən query

SELECT *, (SELECT Name FROM Meals WHERE Meals.Id = Orders.Meal_Id) AS Order_Name FROM Orders

SELECT * FROM Orders
INNER JOIN Meals ON Orders.Meal_Id = Meals.Id

-- Bütün sirafiş datalarını yanında yeməyin adı və masanın nömrəsi  ilə select edən query

SELECT * FROM Orders
INNER JOIN Meals ON Meals.Id = Orders.Meal_Id
INNER JOIN Tables ON Tables.Id = Orders.Table_Id


SELECT *, (SELECT Name FROM Meals WHERE Meals.Id = Orders.Meal_Id) AS Meal_Name, (SELECT No FROM Tables WHERE Tables.Id = Orders.Table_Id) AS Table_No FROM Orders 

-- Bütün masa datalarını yanında o masının sifarişlərinin ümumi məbləği ilə select edən query 

SELECT *,
(SELECT SUM(Price) FROM Meals 
WHERE Meals.Id 
IN (SELECT Meal_Id FROM Orders WHERE Orders.Table_Id = Tables.Id)) AS Total_Amount
FROM Tables

-- 1-idli masaya verilmis ilk sifarişlə son sifariş arasında neçə saat fərq olduğunu select edən query

SELECT DATEDIFF(HOUR, MIN(Order_Date), MAX(Order_Date)) AS Date_Diff FROM Orders WHERE Table_Id = 1

-- ən son 30-dəqədən əvvəl verilmiş sifarişləri select edən query

SELECT * FROM Orders WHERE Order_Date < DATEADD(MINUTE, -30, GETDATE())

-- heç sifariş verməmiş masaları select edən query

SELECT * FROM Tables WHERE Tables.Id NOT IN (SELECT Table_Id FROM Orders)

-- son 60 dəqiqədə heç sifariş verməmiş masaları select edən query

SELECT * FROM Tables WHERE Tables.Id NOT IN (SELECT Table_Id FROM Orders WHERE Order_Date>=(SELECT DATEADD(MINUTE, -60, GETDATE())))