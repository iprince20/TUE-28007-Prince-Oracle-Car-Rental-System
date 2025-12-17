-- Enable output (safe to keep at top-level scripts)
SET SERVEROUTPUT ON;

-- VEHICLES
CREATE TABLE Vehicles (
    Vehicle_ID NUMBER PRIMARY KEY,
    Make VARCHAR2(50) NOT NULL,
    Model VARCHAR2(50) NOT NULL,
    Year NUMBER(4) NOT NULL,
    Availability_Status VARCHAR2(20) NOT NULL
        CHECK (Availability_Status IN ('Available','Rented','Under Maintenance'))
);

-- CUSTOMERS
CREATE TABLE Customers (
    Customer_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE,
    Phone VARCHAR2(20) NOT NULL,
    License_Details VARCHAR2(50) NOT NULL
);

-- RENTALS
CREATE TABLE Rentals (
    Rental_ID NUMBER PRIMARY KEY,
    Customer_ID NUMBER NOT NULL,
    Vehicle_ID NUMBER NOT NULL,
    Rental_Date DATE DEFAULT SYSDATE,
    Return_Date DATE NOT NULL,
    CONSTRAINT FK_Customer FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),
    CONSTRAINT FK_Vehicle FOREIGN KEY (Vehicle_ID)
        REFERENCES Vehicles(Vehicle_ID),
    CONSTRAINT Valid_Rental_Dates
        CHECK (Return_Date > Rental_Date)
);

-- MAINTENANCE
CREATE TABLE Maintenance (
    Maintenance_ID NUMBER PRIMARY KEY,
    Vehicle_ID NUMBER NOT NULL REFERENCES Vehicles(Vehicle_ID),
    Maintenance_Date DATE DEFAULT SYSDATE,
    Description VARCHAR2(200) NOT NULL,
    Cost NUMBER(10,2) NOT NULL CHECK (Cost > 0)
);

-- PAYMENTS
CREATE TABLE Payments (
    Payment_ID NUMBER PRIMARY KEY,
    Rental_ID NUMBER NOT NULL REFERENCES Rentals(Rental_ID),
    Amount NUMBER(10,2) NOT NULL CHECK (Amount > 0),
    Payment_Method VARCHAR2(20)
        CHECK (Payment_Method IN ('Credit Card','Debit Card','Cash','Bank Transfer')),
    Payment_Status VARCHAR2(20) DEFAULT 'Pending'
        CHECK (Payment_Status IN ('Pending','Completed','Failed')),
    Payment_Date DATE DEFAULT SYSDATE
);

-- AUDIT LOG
CREATE TABLE Audit_Log (
    Log_ID       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username     VARCHAR2(30),
    Action_Date  TIMESTAMP DEFAULT SYSTIMESTAMP,
    Table_Name   VARCHAR2(30),
    Operation    VARCHAR2(10),
    Status       VARCHAR2(10),
    Details      VARCHAR2(200)
);
