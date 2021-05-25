CREATE DATABASE TStore;
Use TStore;

CREATE TABLE Category
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'CA[0-9][0-9][0-9]'),
	category_name varchar(255) UNIQUE
)

CREATE TABLE Vendor
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'VE[0-9][0-9][0-9]'),
	vendor_name varchar(255) NOT NULL,
	vendor_address varchar(255) UNIQUE NOT NULL,
	phoneNo varchar(12)
	CHECK (phoneNo like '08[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	email varchar(255) UNIQUE NOT NULL
)

CREATE TABLE Staff
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'ST[0-9][0-9][0-9]'),
	staff_name varchar(255) NOT NULL,
	staff_address varchar(255) NOT NULL,
	phoneNo varchar(12)
	CHECK (phoneNo like '08[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	gen varchar(10)
	CHECK(gen in('Male', 'Female')) NOT NULL,
	email varchar(255) UNIQUE NOT NULL,
	salary bigint NOT NULL
	CHECK(Salary >= 3000000)
)

CREATE TABLE Customer
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'CU[0-9][0-9][0-9]'),
	customer_name varchar(255) NOT NULL,
	customer_address varchar(255) NOT NULL,
	phoneNo varchar(12)
	CHECK (phoneNo like '08[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') UNIQUE NOT NULL,
	gen varchar(10)
	CHECK(gen in('Male', 'Female')) NOT NULL,
	email varchar(255) UNIQUE NOT NULL
)

CREATE TABLE Cloth
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'CL[0-9][0-9][0-9]'),
	Brand varchar(255) NOT NULL
	CHECK (len(brand) > 5),
	Price bigint NOT NULL
	CHECK(Price >= 20000),
	stock int,
	category_id varchar(5)
	CHECK (category_id like 'CA[0-9][0-9][0-9]'),
	FOREIGN KEY (category_id) REFERENCES Category(ID)
)

CREATE TABLE Purchase_transaction
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'PU[0-9][0-9][0-9]'),
	staffID varchar(5) 
	CHECK (staffID like 'ST[0-9][0-9][0-9]'),
	vendorID varchar(5)
	CHECK (vendorID like 'VE[0-9][0-9][0-9]'),
	pu_date date
	CHECK (pu_date <= DATEADD(hh, -1, GETDATE())),
	FOREIGN KEY (staffID) REFERENCES Staff(ID),
	FOREIGN KEY (vendorID) REFERENCES Vendor(ID)
)

CREATE TABLE sales_transaction
(
	ID varchar(5) PRIMARY KEY
	CHECK (ID like 'SA[0-9][0-9][0-9]'),
	staffID varchar(5) 
	CHECK (staffID like 'ST[0-9][0-9][0-9]'),
	customerID varchar(5)
	CHECK (customerID like 'CU[0-9][0-9][0-9]'),
	sa_date date
	CHECK (sa_date <= DATEADD(hh, -1, GETDATE())),
	FOREIGN KEY (staffID) REFERENCES Staff(ID),
	FOREIGN KEY (customerID) REFERENCES Vendor(ID),
)

CREATE TABLE pu_transaction_detail
(
	transactionID varchar(5)
	CHECK (transactionID like 'PU[0-9][0-9][0-9]'),
	clothID varchar(5)
	CHECK (clothID like 'CL[0-9][0-9][0-9]'),
	quantity int,
	FOREIGN KEY (transactionID) REFERENCES Purchase_transaction(ID),
	FOREIGN KEY (clothID) REFERENCES Cloth(ID),
	PRIMARY KEY(transactionID, clothID)
)

CREATE TABLE sa_transaction_detail
(
	transactionID varchar(5)
	CHECK (transactionID like 'SA[0-9][0-9][0-9]'),
	clothID varchar(5)
	CHECK (clothID like 'CL[0-9][0-9][0-9]'),
	quantity int,
	FOREIGN KEY (transactionID) REFERENCES sales_transaction(ID),
	FOREIGN KEY (clothID) REFERENCES Cloth(ID),
	PRIMARY KEY(transactionID, clothID)
)