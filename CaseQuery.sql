Use Tstore;

--1

SELECT COUNT(*) as [Transaction count], st.staff_name, ve.vendor_name 
FROM Purchase_transaction pu JOIN Staff st ON pu.staffID = st.ID
JOIN Vendor ve ON pu.vendorID = ve.ID
WHERE st.salary >= 5000000 AND st.salary <= 10000000 AND ve.vendor_name like('%o%') GROUP BY st.staff_name, ve.vendor_name;

--2

SELECT sl.ID, sl.sa_date, cu.customer_name, cu.customer_address
FROM sales_transaction sl JOIN Customer cu ON sl.customerID = cu.ID
JOIN sa_transaction_detail sa ON sl.ID = sa.transactionID
JOIN Cloth cl ON sa.clothID = cl.ID
WHERE DATEPART(day, sl.sa_date) = DATEPART(day, '2020/11/15') AND sa.quantity * cl.Price > 150000 GROUP BY sl.ID, cu.customer_name, cu.customer_address, sl.sa_date;

--3

SELECT COUNT(*) as [Transaction count], DATENAME(Month, sl.sa_date) as [Month], SUM(sa.quantity) as [Cloth Sold]
FROM sales_transaction sl JOIN sa_transaction_detail sa ON sl.ID = sa.transactionID
JOIN Staff st ON sl.staffID = st.ID
JOIN Cloth cl ON sa.clothID = cl.ID
WHERE st.gen = 'Female' AND cl.Price > 70000 GROUP BY sl.sa_date;

--4

SELECT SUBSTRING(cl.Brand, CHARINDEX(' ', cl.Brand) + 1, LEN(cl.Brand) - CHARINDEX(' ', cl.Brand)) As [Brand Last Name], MAX(sa.quantity) as [Maximum Sales]
FROM Cloth cl JOIN sa_transaction_detail sa ON cl.ID = sa.clothID
WHERE sa.quantity > 5 AND sa.quantity < 10 GROUP BY cl.Brand;


--5

SELECT cl.Brand, cl.Price, cl.stock
FROM Cloth cl JOIN pu_transaction_detail pu ON cl.ID = pu.clothID
JOIN  Purchase_transaction pr ON pu.transactionID = pr.ID
GROUP BY cl.Price, cl.Brand, cl.stock
HAVING cl.Price > 
(SELECT Price FROM Cloth 
WHERE Cloth.Brand like('Saad %')) - 35000 AND cl.Price < (SELECT Price FROM Cloth WHERE Cloth.Brand like('Saad %'));


--6

SELECT FORMAT(sl.sa_date, 'MM/dd/yyyy') as [Sales Date], cl.Brand, sa.quantity
FROM sales_transaction sl JOIN sa_transaction_detail sa ON sl.ID = sa.transactionID
JOIN Cloth cl ON sa.clothID = cl.ID
GROUP BY sa.quantity, sl.sa_date, cl.Brand
HAVING sa.quantity  > 
(SELECT SUM(sa.quantity) FROM sa_transaction_detail sa 
JOIN sales_transaction sl ON sl.ID = sa.transactionID
WHERE DATEPART(Month, sl.sa_date) = DATEPART(Month, '2020/5/1'))ORDER BY sa.quantity ASC;

--7

SELECT pr.ID, LOWER(st.staff_name) as [Staff Name], CONCAT('IDR ', st.salary) as [Staff Salary], 
FORMAT(pr.pu_date, 'Mon dd, yyyy') as [Purchase Date], SUM(pu.quantity) as [Total Quantity]
FROM Purchase_transaction pr JOIN Staff st ON pr.staffID = st.ID
JOIN pu_transaction_detail pu ON pr.ID = pu.transactionID
GROUP BY pu.quantity, pr.ID, st.staff_name, st.salary, pr.pu_date
HAVING pu.quantity > (SELECT MIN(pu.quantity) FROM pu_transaction_detail pu JOIN Purchase_transaction pr 
ON pu.transactionID = pr.ID WHERE DATEPART(Month, pr.pu_date) = DATEPART(Month, '2020/4/1'));

--8

SELECT RIGHT(ve.ID, 3) as [Vendor ID], ve.vendor_name, SUM(pu.quantity) as [Clothes Bought], CONCAT('+62', ve.phoneNo) as [Phone]
FROM Vendor ve JOIN Purchase_transaction ON ve.ID = Purchase_transaction.vendorID
JOIN pu_transaction_detail pu ON Purchase_transaction.ID = pu.transactionID
GROUP BY pu.quantity, ve.ID, ve.phoneNo, ve.vendor_name
HAVING (Select SUM(pu_transaction_detail.quantity) FROM pu_transaction_detail) < 100 
AND pu.quantity > (SELECT AVG(pu_transaction_detail.quantity) FROM pu_transaction_detail);

--9

go

CREATE VIEW [StoreSalesView] AS
SELECT sl.id as [SalesId], cu.customer_name,  cu.phoneNo, CONCAT('IDR ', AVG(cl.price)) as [Cloth Average Price],
CONCAT(SUM(sa.quantity), ' Piece(s)') as [Sales Quantity] FROM sales_transaction sl 
JOIN Customer cu ON sl.customerID = cu.ID
JOIN sa_transaction_detail sa ON sl.ID = sa.transactionID
JOIN Cloth cl ON sa.clothID = cl.ID
WHERE sa.quantity > 4 GROUP BY sl.ID, cu.customer_name, cu.phoneNo
HAVING (SELECT AVG(sa.quantity * cl.price)
FROM sa_transaction_detail sa JOIN cloth cl ON sa.clothID = cl.ID) > 100000;


go

SELECT * FROM StoreSalesView;

--10

go

CREATE VIEW [StorePurchaseView] AS
SELECT DATEPART(Month, pr.pu_date) as [Month], MIN(pu.quantity) as [Minimum Purchase Quantity], SUM(pu.quantity) as [Purchased Cloth Count]
FROM Purchase_transaction pr JOIN pu_transaction_detail pu ON pr.ID = pu.transactionID
GROUP BY pr.pu_date
HAVING (SELECT MIN(pu_transaction_detail.quantity) FROM pu_transaction_detail) > 10 
AND (SELECT SUM(pu_transaction_detail.quantity) FROM pu_transaction_detail) > 1;

go

SELECT * FROM StorePurchaseView;