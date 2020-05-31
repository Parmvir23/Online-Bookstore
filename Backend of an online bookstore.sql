create schema online_bookstore;

create table Supplier
(SupplierID			INT 				NOT NULL,
CompanyName			VARCHAR(15),
ContactLastName 	VARCHAR(15),
ContactFirstName	VARCHAR(15),
Phone				CHAR(12),
PRIMARY KEY (SupplierID));

create table Books
(BookID				INT					NOT NULL,
Title				VARCHAR(30),
Unit_Price			DECIMAL(4,2),
Author				VARCHAR(15),
Unit_in_stock		CHAR(2),
SupplierID			INT,
SubjectID			INT,
PRIMARY KEY(BookID));

create table Subjects
(SubjectID    		INT					NOT NULL,
CategoryName		VARCHAR(15),
PRIMARY KEY(SubjectID));

create table OrderDetails
(BookID				INT					NOT NULL,
OrderID				INT					NOT NULL,
Quantity			INT,
PRIMARY KEY(BookID, OrderID));

create table Customers
(CustomerID			INT					NOT NULL,
LastName			VARCHAR(15),
FirstName			VARCHAR(15),
Phone				CHAR(12),
PRIMARY KEY(CustomerID));

create table Orders
(OrderID			INT					NOT NULL,
CustomerID			INT,
EmployeeID			INT,
OrderDate			DATE,
ShippedDate			DATE,
ShipperID			INT,
PRIMARY KEY(OrderID));

create table Employees
(EmployeeID			INT,
LastName			VARCHAR(15),
FirstName			VARCHAR(15));

create table Shippers
(ShipperID			INT					NOT NULL,
ShipperName			VARCHAR(10),
PRIMARY KEY(ShipperID));

INSERT INTO Supplier
VALUES (1,'Amazon','Hamilton','Laurell','605-145-1875');
INSERT INTO Supplier
VALUES (2,'Ebay','Koontz','Dean','605-244-1104');
INSERT INTO Supplier
VALUES (3,'Booksamillion','Roberts','Nora','916-787-3320');
INSERT INTO Supplier
VALUES (4,'University','Carter','Stephen','916-412-2004');

INSERT INTO Books
VALUES (1,'The Quickie','15.94','James','5',3,1);
INSERT INTO Books
VALUES (2,'Blaze','13.24','Richard','2',3,1);
INSERT INTO Books
VALUES (3,'The Navigator','14.01','Clive','10',2,1);
INSERT INTO Books
VALUES (4,'Birmingham','19.99','Tim','12',3,2);
INSERT INTO Books
VALUES (5,'North Caroline Ghosts','7.95','Lynne','5',2,2);
INSERT INTO Books
VALUES (6,'Why I still live in Louisiana','5.95','Ellen','30',1,3);
INSERT INTO Books
VALUES (7,'The World Is Flat','30','Thomas','17',3,4);

INSERT INTO Subjects
VALUES (1,'Fiction');
INSERT INTO Subjects
VALUES (2,'History');
INSERT INTO Subjects
VALUES (3,'Travel');
INSERT INTO Subjects
VALUES (4,'Technology');

INSERT INTO Employees
VALUES (1,'Larson','Erik');
INSERT INTO Employees
VALUES (2,'Steely','John');

INSERT INTO Shippers
VALUES (1,'UPS');
INSERT INTO Shippers
VALUES (2,'USPS');
INSERT INTO Shippers
VALUES (3,'FedEx');

INSERT INTO Customers
VALUES (1,'Lee','James','916-541-4568');
INSERT INTO Customers
VALUES (2,'Smith','John','916-057-0087');
INSERT INTO Customers
VALUES (3,'See','Lisa','605-054-0010');
INSERT INTO Customers
VALUES (4,'Collins','Jackie','605-044-6582');

INSERT INTO Orders
VALUES (1,1,1,'08-01-18','08-03-18',1);
INSERT INTO Orders
VALUES (2,1,2,'08-04-18',NULL,NULL);
INSERT INTO Orders
VALUES (3,2,1,'08-01-18','08-03-18',2);
INSERT INTO Orders
VALUES (4,4,2,'08-04-18','08-05-18',1);

INSERT INTO OrderDetails
VALUES (1,1,2);
INSERT INTO OrderDetails
VALUES (4,1,1);
INSERT INTO OrderDetails
VALUES (6,2,2);
INSERT INTO OrderDetails
VALUES (7,2,3);
INSERT INTO OrderDetails
VALUES (5,3,1);
INSERT INTO OrderDetails
VALUES (3,4,1);
INSERT INTO OrderDetails
VALUES (4,4,1);
INSERT INTO OrderDetails
VALUES (7,4,1);

SELECT		B.Title
FROM		Books AS B
WHERE		B.Unit_in_Stock > 5;

SELECT		(D.Quantity * B.Unit_Price) AS total
FROM		OrderDetails AS D, Books AS B, Customers AS C, Orders AS O
WHERE		C.FirstName = 'John' AND C.LastName = 'Smith' 
			AND C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID
            AND D.BookID = B.BookID;
            
SELECT		C.LastName, C.FirstName
FROM		OrderDetails AS D, Books AS B, Customers AS C, Orders AS O
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID
            AND D.BookID = B.BookID
GROUP BY    C.LastName, C.FirstName
HAVING		SUM(D.Quantity * B.Unit_Price) < 20;

SELECT		B.Title, S.ShipperName
FROM		Books B, OrderDetails D, Orders O, Shippers S
WHERE		B.BookID = D.BookID AND D.OrderID = O.OrderID
			AND O.ShippedDate = '08/05/18' AND O.ShipperID = S.ShipperID;
            
SELECT 		DISTINCT (B.Title)
FROM		Employees E, Books B, OrderDetails D, Orders O
WHERE		E.LastName = 'Steely' AND E.FirstName = 'John' AND E.EmployeeID = O.EmployeeID 
			AND O.OrderID = D.OrderID AND D.BookID = B.BookID;

SELECT 		C.LastName, C.FirstName, SUM(D.Quantity*B.Unit_Price) AS Total  
FROM		Customers C, Orders O, OrderDetails D, Books B
WHERE		C.CustomerID = O.CustomerID AND
			O.OrderID = D.OrderID AND D.BookID = B.BookID
GROUP BY	C.LastName, C.FirstName
ORDER BY 	SUM(D.Quantity*B.Unit_Price) DESC;

SELECT 		DISTINCT(B.Title) 
FROM		Customers C, Orders O, OrderDetails D, Books B
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID AND D.BookID = B.BookID
			AND (C.FirstName='John' OR C.LastName='Smith' OR
			C.FirstName='Jackie' OR C.LastName='Collins');
            
SELECT 		B.Title, SUM(D.Quantity) AS 'Total Quantities'
FROM		Customers C, Orders O, orderDetails D, Books B
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID 
			AND D.BookID = B.BookID
GROUP BY 	B.Title
ORDER BY	SUM(D.Quantity) ASC;

SELECT		C.FirstName, C.LastName
FROM		Customers C, Orders O, OrderDetails D, Books B
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID 
			AND D.BookID = B.BookID AND B.Title LIKE '%Louisiana%';
            
SELECT		C.FirstName, C.LastName
FROM		Customers C, Orders O, OrderDetails D, Books B
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID 
			AND D.BookID = B.BookID AND B.Author = 'Thomas';

SELECT		C.FirstName, C.LastName, B.Title
FROM		OrderDetails AS D, Books AS B, Customers AS C, Orders AS O, Subjects S
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID
            AND D.BookID = B.BookID AND B.SubjectID = S.SubjectID AND
            (S.CategoryName = 'Fiction' OR S.CategoryName = 'Travel');

SELECT		S.CategoryName, MIN(B.Unit_Price) AS 'Price of Cheapiest Book'
FROM 		Subjects S, Books B
WHERE		S.SubjectID = B.SubjectID
GROUP BY	S.CategoryName;

SELECT 		B.Title, SUM(D.Quantity) AS 'Total Quantity'
FROM 		Books B, OrderDetails D, Orders O
WHERE 		B.BookID = D.BookID AND D.OrderID = O.OrderID AND
			(O.ShippedDate IS NULL OR O.ShippedDate >= '08/04/18')
GROUP BY  	B.Title;

SELECT 		C.FirstName, C.LastName, SUM(D.Quantity) AS Quantity
FROM		Customers C, Orders O, OrderDetails D
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID
GROUP BY 	C.FirstName, C.LastName
HAVING		SUM(D.Quantity) > 1
ORDER BY	Quantity DESC;


SELECT 		C.FirstName, C.LastName, C.Phone
FROM		Customers C, Orders O, OrderDetails D
WHERE		C.CustomerID = O.CustomerID AND O.OrderID = D.OrderID
GROUP BY	C.FirstName, C.LastName, C.Phone
HAVING		SUM(D.Quantity) > 1;











