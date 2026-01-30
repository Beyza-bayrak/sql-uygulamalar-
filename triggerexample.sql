-- ============================
-- DATABASE CREATION
-- ============================

CREATE DATABASE dbRentaCar;
GO

USE dbRentaCar;
GO

-- ============================
-- TABLES
-- ============================

CREATE TABLE CarTypes ( 
    TypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    TypeName NVARCHAR(50) NOT NULL UNIQUE, 
    Quantity INT DEFAULT 0 NOT NULL
);

INSERT INTO CarTypes (TypeName)
VALUES ('Sedan'), ('HB'), ('SUV');

CREATE TABLE Cars ( 
    CarID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    Brand NVARCHAR(50) NOT NULL, 
    Model NVARCHAR(50) NOT NULL, 
    Type_Name NVARCHAR(50) NOT NULL,
    ModelYear INT NOT NULL, 
    DailyPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_Cars_CarTypes 
        FOREIGN KEY (Type_Name) REFERENCES CarTypes(TypeName)
);

CREATE TABLE Customers ( 
    CustomerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    CName NVARCHAR(50) NOT NULL, 
    CSurname NVARCHAR(50) NOT NULL, 
    CAddress NVARCHAR(255), 
    CBirthDate DATE NOT NULL
);

INSERT INTO Customers (CName, CSurname, CAddress, CBirthDate)
VALUES 
('Dilara', 'NÝHADÝOÐLU', 'Sarýçam', '1980-05-05'),
('Selçuk', 'TOKGÖZ', 'Seyhan', '1999-02-01'),
('Mustafa', 'AÇIKKAR', 'Çukurova', '2006-01-01');

CREATE TABLE Rent ( 
    RentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    Customer_ID INT NOT NULL,
    Car_ID INT NOT NULL,
    StartDate DATE NOT NULL, 
    EndDate DATE NOT NULL, 
    RentalDays AS (DATEDIFF(DAY, StartDate, EndDate)),
    TotalAmount DECIMAL(10,2),
    CONSTRAINT fk_Rent_Customers 
        FOREIGN KEY (Customer_ID) REFERENCES Customers(CustomerID),
    CONSTRAINT fk_Rent_Cars 
        FOREIGN KEY (Car_ID) REFERENCES Cars(CarID)
);

-- ============================
-- TRIGGERS
-- ============================

-- After insert on Cars: increase quantity
CREATE TRIGGER AfterInsert_Cars
ON Cars
AFTER INSERT
AS
BEGIN
    UPDATE ct
    SET ct.Quantity = ct.Quantity + i.cnt
    FROM CarTypes ct
    JOIN (
        SELECT Type_Name, COUNT(*) AS cnt
        FROM inserted
        GROUP BY Type_Name
    ) i ON ct.TypeName = i.Type_Name;
END;
GO

-- After delete on Cars: decrease quantity
CREATE TRIGGER AfterDelete_Cars
ON Cars
AFTER DELETE
AS
BEGIN
    UPDATE ct
    SET ct.Quantity = ct.Quantity - d.cnt
    FROM CarTypes ct
    JOIN (
        SELECT Type_Name, COUNT(*) AS cnt
        FROM deleted
        GROUP BY Type_Name
    ) d ON ct.TypeName = d.Type_Name;
END;
GO

-- After insert on Rent: calculate total amount
CREATE TRIGGER AfterInsert_Rent
ON Rent
AFTER INSERT
AS
BEGIN
    UPDATE r
    SET r.TotalAmount = c.DailyPrice * i.RentalDays
    FROM Rent r
    JOIN inserted i ON r.RentID = i.RentID
    JOIN Cars c ON c.CarID = i.Car_ID;
END;
GO

-- Instead of update on Customers: only allow address update
CREATE TRIGGER InsteadOfUpdate_Customers
ON Customers
INSTEAD OF UPDATE
AS
BEGIN
    PRINT 'Only address update is allowed.';

    UPDATE c
    SET c.CAddress = i.CAddress
    FROM Customers c
    JOIN inserted i ON c.CustomerID = i.CustomerID;
END;
GO

-- After insert or update on Rent: apply discount if rental > 10 days
CREATE TRIGGER AfterInsertUpdate_Rent
ON Rent
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE r
    SET r.TotalAmount = 
        CASE 
            WHEN i.RentalDays > 10 
                THEN c.DailyPrice * i.RentalDays * 0.9
            ELSE c.DailyPrice * i.RentalDays
        END
    FROM Rent r
    JOIN inserted i ON r.RentID = i.RentID
    JOIN Cars c ON c.CarID = i.Car_ID;
END;
GO

-- ============================
-- SAMPLE DATA
-- ============================

INSERT INTO Cars (Brand, Model, Type_Name, ModelYear, DailyPrice)
VALUES 
('Ford', 'Focus', 'Sedan', 2015, 500),
('Renault', 'Megane', 'HB', 2010, 300),
('Fiat', 'Egea', 'Sedan', 2017, 400),
('Nissan', 'Qashqai', 'SUV', 2020, 1000);

INSERT INTO Rent (Customer_ID, Car_ID, StartDate, EndDate)
VALUES 
(1, 4, '2024-05-16', '2024-05-20'),
(2, 4, '2024-04-01', '2024-04-18'),
(3, 3, '2024-05-30', '2024-06-05');

-- ============================
-- TEST OPERATIONS
-- ============================

-- Delete a car and observe quantity decrease
DELETE FROM Cars WHERE CarID = 2;

-- Update a customer (only address will change)
UPDATE Customers
SET CName = 'Ali',
    CSurname = 'Veli',
    CAddress = 'Balcalý'
WHERE CustomerID = 2;

-- Update rent to trigger discount logic
UPDATE Rent
SET EndDate = '2024-05-31'
WHERE RentID = 3;

-- ============================
-- CHECK RESULTS
-- ============================

SELECT * FROM CarTypes;
SELECT * FROM Cars;
SELECT * FROM Customers;
SELECT * FROM Rent;
