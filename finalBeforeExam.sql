-- =======================
-- TABLE CREATION
-- =======================

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(50),
    DateOfBirth DATE
);

CREATE TABLE Medicine (
    MedicineID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    FormType VARCHAR(50),
    PriceStock INT NOT NULL,
    Amount INT NOT NULL
);

CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    DoctorName VARCHAR(100),
    IssuedDate DATE,
    CONSTRAINT fk_Prescription_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE PrescriptionDetail (
    PrescriptionID INT NOT NULL,
    MedicineID INT NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT fk_PrescriptionDetail_Prescription
        FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID),
    CONSTRAINT fk_PrescriptionDetail_Medicine
        FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID)
);

CREATE TABLE Pharmacist (
    PharmacistID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    ShiftTime DATE
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    MedicineID INT NOT NULL,
    PharmacistID INT NOT NULL,
    PrescriptionID INT,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL,
    PaymentMethod VARCHAR(100),
    CONSTRAINT fk_Sales_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT fk_Sales_Medicine
        FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID),
    CONSTRAINT fk_Sales_Pharmacist
        FOREIGN KEY (PharmacistID) REFERENCES Pharmacist(PharmacistID),
    CONSTRAINT fk_Sales_Prescription
        FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID)
);

-- =======================
-- INSERT DATA
-- =======================

INSERT INTO Customer VALUES 
(1, 'Ahmet', 'Yýlmaz', '0555-111-2233', '1990-04-15'),
(2, 'Ayþe', 'Demir', '0533-222-3344', '1985-07-22'),
(3, 'Mehmet', 'Kaya', '0544-333-4455', '1992-11-03'),
(4, 'Elif', 'Çetin', '0506-444-5566', '1998-01-19'),
(5, 'Burak', 'Þahin', '0532-555-6677', '1987-09-09');

INSERT INTO Medicine VALUES
(1, 'Parol', 'Tablet', 15, 100),
(2, 'Ventolin', 'Sprey', 45, 50),
(3, 'Augmentin', 'Tablet', 70, 80),
(4, 'Dolorex', 'Tablet', 25, 60),
(5, 'Tylolhot', 'Toz', 10, 120);

INSERT INTO Prescription VALUES
(1, 1, 'Dr. Ali Vural', '2024-05-10'),
(2, 2, 'Dr. Zeynep Aksoy', '2024-06-01'),
(3, 3, 'Dr. Murat Yýldýz', '2024-06-15'),
(4, 4, 'Dr. Elif Demirtaþ', '2024-06-18'),
(5, 5, 'Dr. Hasan Koç', '2024-06-20');

INSERT INTO PrescriptionDetail VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 4, 2),
(4, 5, 3);

INSERT INTO Pharmacist VALUES
(1, 'Selin', 'Arslan', '2024-06-21'),
(2, 'Kemal', 'Durmaz', '2024-06-21'),
(3, 'Merve', 'Kurt', '2024-06-22'),
(4, 'Can', 'Yüce', '2024-06-22'),
(5, 'Zeynep', 'Koç', '2024-06-23');

INSERT INTO Sales VALUES
(1, 1, 1, 1, 1, '2024-06-21', 2, 'Cash'),
(2, 2, 2, 2, 2, '2024-06-21', 1, 'Credit Card'),
(3, 3, 4, 3, 3, '2024-06-22', 2, 'Cash'),
(4, 4, 5, 4, 4, '2024-06-23', 3, 'Debit Card'),
(5, 5, 3, 5, 5, '2024-06-23', 1, 'Cash');

-- =======================
-- UPDATES & ALTERATIONS
-- =======================

UPDATE Customer
SET Phone = '05363281820'
WHERE Phone LIKE '0555%';

UPDATE Medicine
SET PriceStock = PriceStock - 1
WHERE Name = 'Parol';

UPDATE PrescriptionDetail
SET Quantity = Quantity * 2;

ALTER TABLE Customer
ADD Email VARCHAR(30) NOT NULL;

ALTER TABLE Medicine
ADD Manufacturer VARCHAR(100);

-- =======================
-- CASCADE RULES
-- =======================

ALTER TABLE Prescription
DROP CONSTRAINT fk_Prescription_Customer;

ALTER TABLE Prescription
ADD CONSTRAINT fk_Prescription_Customer
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE PrescriptionDetail
DROP CONSTRAINT fk_PrescriptionDetail_Prescription;

ALTER TABLE PrescriptionDetail
ADD CONSTRAINT fk_PrescriptionDetail_Prescription
FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID)
ON DELETE CASCADE;

ALTER TABLE Sales
DROP CONSTRAINT fk_Sales_Customer;

ALTER TABLE Sales
ADD CONSTRAINT fk_Sales_Customer
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
ON DELETE CASCADE;

-- =======================
-- DELETE TEST
-- =======================

DELETE FROM Customer
WHERE CustomerID = 5;














