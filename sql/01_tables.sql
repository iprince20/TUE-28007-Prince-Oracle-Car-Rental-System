SET SERVEROUTPUT ON;

CREATE TABLE Vehicles (
    Vehicle_ID NUMBER PRIMARY KEY,
    Make VARCHAR2(50) NOT NULL,
    Model VARCHAR2(50) NOT NULL,
    Year NUMBER(4) NOT NULL,
    Availability_Status VARCHAR2(20) NOT NULL
        CHECK (Availability_Status IN ('Available','Rented','Under Maintenance'))
);

CREATE TABLE Customers (
    Customer_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE,
    Phone VARCHAR2(20) NOT NULL,
    License_Details VARCHAR2(50) NOT NULL
);

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

CREATE TABLE Maintenance (
    Maintenance_ID NUMBER PRIMARY KEY,
    Vehicle_ID NUMBER NOT NULL REFERENCES Vehicles(Vehicle_ID),
    Maintenance_Date DATE DEFAULT SYSDATE,
    Description VARCHAR2(200) NOT NULL,
    Cost NUMBER(10,2) NOT NULL CHECK (Cost > 0)
);

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

SELECT table_name FROM user_tables;

SELECT table_name
FROM user_tables
WHERE table_name IN (
    'VEHICLES',
    'CUSTOMERS',
    'RENTALS',
    'MAINTENANCE',
    'PAYMENTS'
);
SELECT COUNT(*) FROM Vehicles;

INSERT INTO Vehicles VALUES (1, 'Toyota', 'RAV4', 2022, 'Available');
INSERT INTO Vehicles VALUES (2, 'Mazda', 'CX-5', 2021, 'Available');
INSERT INTO Vehicles VALUES (3, 'Nissan', 'X-Trail', 2020, 'Under Maintenance');
INSERT INTO Vehicles VALUES (4, 'Kia', 'Sportage', 2023, 'Rented');
INSERT INTO Vehicles VALUES (5, 'Subaru', 'Forester', 2021, 'Available');

SELECT * FROM Vehicles;

INSERT INTO Customers VALUES (101, 'Umutoni Diane', 'diane.umutoni@email.com', '0781234567', 'DL-119988001');
INSERT INTO Customers VALUES (102, 'Iradukunda Patrick', 'patrick.iradukunda@email.com', '0722345678', 'DL-119977002');
INSERT INTO Customers VALUES (103, 'Mugisha Jean', 'jean.mugisha@email.com', '0733456789', 'DL-119966003');

INSERT INTO Customers VALUES (104, 'Uwase Grace', 'grace.uwase@email.com', '0784567890', 'DL-119955004');
INSERT INTO Customers VALUES (105, 'Habimana Eric', 'eric.habimana@email.com', '0725678901', 'DL-119944005');

SELECT * FROM Customers;
SELECT * FROM Vehicles;
INSERT INTO Vehicles VALUES (1, 'Toyota', 'RAV4', 2022, 'Available');
INSERT INTO Vehicles VALUES (2, 'Mazda', 'CX-5', 2021, 'Available');
INSERT INTO Vehicles VALUES (3, 'Nissan', 'X-Trail', 2020, 'Under Maintenance');
INSERT INTO Vehicles VALUES (4, 'Kia', 'Sportage', 2023, 'Rented');

SELECT * FROM Vehicles;
INSERT INTO Rentals VALUES (501, 101, 1, DATE '2023-06-01', DATE '2023-06-08');
INSERT INTO Rentals VALUES (502, 102, 2, DATE '2023-06-05', DATE '2023-06-12');
INSERT INTO Rentals VALUES (503, 103, 4, DATE '2023-06-03', DATE '2023-06-10');
INSERT INTO Rentals VALUES (504, 104, 5, DATE '2023-06-07', DATE '2023-06-14');
INSERT INTO Rentals VALUES (505, 105, 1, DATE '2023-06-10', DATE '2023-06-17');
SELECT * FROM Rentals;

INSERT INTO Maintenance VALUES (1001, 3, DATE '2023-05-28', 'Engine tune-up', 120000);
INSERT INTO Maintenance VALUES (1002, 2, DATE '2023-06-01', 'Brake service', 85000);
INSERT INTO Maintenance VALUES (1003, 4, DATE '2023-05-25', 'AC repair', 95000);
INSERT INTO Maintenance VALUES (1004, 1, DATE '2023-06-05', 'Oil change', 45000);
INSERT INTO Maintenance VALUES (1005, 5, DATE '2023-05-30', 'Tire replacement', 110000);
SELECT * FROM Maintenance;

INSERT INTO Payments VALUES (2001, 501, 210000, 'Bank Transfer', 'Completed', DATE '2023-06-02');
INSERT INTO Payments VALUES (2002, 502, 245000, 'Credit Card', 'Completed', DATE '2023-06-06');
INSERT INTO Payments VALUES (2003, 503, 280000, 'Cash', 'Pending', DATE '2023-06-04');
INSERT INTO Payments VALUES (2004, 504, 315000, 'Bank Transfer', 'Completed', DATE '2023-06-08');
INSERT INTO Payments VALUES (2005, 505, 210000, 'Debit Card', 'Failed', DATE '2023-06-11');
COMMIT;
SELECT * FROM Vehicles;
SELECT * FROM Customers;
SELECT * FROM Rentals;
SELECT * FROM Payments;

CREATE OR REPLACE PROCEDURE add_vehicle(
    p_vehicle_id NUMBER,
    p_make VARCHAR2,
    p_model VARCHAR2,
    p_year NUMBER,
    p_status VARCHAR2
)
IS
BEGIN
    INSERT INTO Vehicles
    VALUES (p_vehicle_id, p_make, p_model, p_year, p_status);

    DBMS_OUTPUT.PUT_LINE('Vehicle added successfully!');
END;
/
BEGIN
    add_vehicle(6, 'Toyota', 'Corolla', 2023, 'Available');
END;
/

SELECT * FROM Vehicles WHERE Vehicle_ID = 6;

CREATE OR REPLACE PROCEDURE return_vehicle(
    p_rental_id    IN NUMBER,
    p_actual_date  IN DATE
)
IS
    v_vehicle_id NUMBER;
BEGIN
    -- Get vehicle ID from rental
    SELECT Vehicle_ID INTO v_vehicle_id
    FROM Rentals
    WHERE Rental_ID = p_rental_id;

    -- Update rental return date
    UPDATE Rentals
    SET Return_Date = p_actual_date
    WHERE Rental_ID = p_rental_id;

    -- Mark vehicle as available
    UPDATE Vehicles
    SET Availability_Status = 'Available'
    WHERE Vehicle_ID = v_vehicle_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vehicle returned successfully!');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Rental not found!');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN
    return_vehicle(501, SYSDATE);
END;
/
SELECT Rental_ID, Return_Date
FROM Rentals
WHERE Rental_ID = 501;

SELECT Vehicle_ID, Availability_Status
FROM Vehicles
WHERE Vehicle_ID = 1;

CREATE OR REPLACE FUNCTION calculate_revenue(
    p_start_date IN DATE,
    p_end_date   IN DATE
) RETURN NUMBER
IS
    v_total_revenue NUMBER := 0;
BEGIN
    SELECT SUM(Amount)
    INTO v_total_revenue
    FROM Payments
    WHERE Payment_Status = 'Completed'
    AND Payment_Date BETWEEN p_start_date AND p_end_date;

    RETURN v_total_revenue;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/

DECLARE
    v_revenue NUMBER;
BEGIN
    v_revenue := calculate_revenue(
        DATE '2023-06-01',
        DATE '2023-06-30'
    );
    DBMS_OUTPUT.PUT_LINE('June Revenue: ' || v_revenue);
END;
/

CREATE OR REPLACE FUNCTION is_vehicle_available(
    p_vehicle_id IN NUMBER,
    p_check_date IN DATE
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Rentals
    WHERE Vehicle_ID = p_vehicle_id
    AND p_check_date BETWEEN Rental_Date AND Return_Date;

    -- 1 = available, 0 = not available
    IF v_count = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

SELECT is_vehicle_available(1, DATE '2023-06-05') AS available
FROM dual;

SELECT Vehicle_ID, Make, Model
FROM Vehicles
WHERE is_vehicle_available(Vehicle_ID, SYSDATE) = 1;



CREATE OR REPLACE PROCEDURE get_active_rentals
IS
    CURSOR rental_cursor IS
        SELECT r.Rental_ID,
               c.Name,
               v.Make,
               v.Model,
               r.Rental_Date,
               r.Return_Date
        FROM Rentals r
        JOIN Customers c ON r.Customer_ID = c.Customer_ID
        JOIN Vehicles v ON r.Vehicle_ID = v.Vehicle_ID
        WHERE r.Return_Date >= SYSDATE;

    v_rental_rec rental_cursor%ROWTYPE;
BEGIN
    OPEN rental_cursor;
    LOOP
        FETCH rental_cursor INTO v_rental_rec;
        EXIT WHEN rental_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Rental ID: ' || v_rental_rec.Rental_ID ||
            ' | Customer: ' || v_rental_rec.Name ||
            ' | Vehicle: ' || v_rental_rec.Make || ' ' || v_rental_rec.Model ||
            ' | From: ' || TO_CHAR(v_rental_rec.Rental_Date,'YYYY-MM-DD') ||
            ' | To: ' || TO_CHAR(v_rental_rec.Return_Date,'YYYY-MM-DD')
        );
    END LOOP;
    CLOSE rental_cursor;
END;
/

BEGIN
    get_active_rentals;
END;
/

CREATE OR REPLACE PACKAGE car_rental_pkg AS
    PROCEDURE add_vehicle(
        p_vehicle_id IN NUMBER,
        p_make       IN VARCHAR2,
        p_model      IN VARCHAR2,
        p_year       IN NUMBER,
        p_status     IN VARCHAR2
    );

    FUNCTION calculate_daily_revenue(p_date IN DATE) RETURN NUMBER;
END car_rental_pkg;
/

CREATE OR REPLACE PACKAGE BODY car_rental_pkg AS

    PROCEDURE add_vehicle(
        p_vehicle_id IN NUMBER,
        p_make       IN VARCHAR2,
        p_model      IN VARCHAR2,
        p_year       IN NUMBER,
        p_status     IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Vehicles
        VALUES (p_vehicle_id, p_make, p_model, p_year, p_status);

        DBMS_OUTPUT.PUT_LINE('Vehicle added via package');
    END add_vehicle;


    FUNCTION calculate_daily_revenue(p_date IN DATE) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(Amount),0)
        INTO v_total
        FROM Payments
        WHERE Payment_Status = 'Completed'
        AND TRUNC(Payment_Date) = TRUNC(p_date);

        RETURN v_total;
    END calculate_daily_revenue;

END car_rental_pkg;
/

BEGIN
    car_rental_pkg.add_vehicle(7,'Honda','CR-V',2022,'Available');
END;
/

SELECT * FROM Vehicles WHERE Vehicle_ID = 7;

DECLARE
    v NUMBER;
BEGIN
    v := car_rental_pkg.calculate_daily_revenue(DATE '2023-06-08');
    DBMS_OUTPUT.PUT_LINE('Revenue on 2023-06-08 = ' || v);
END;
/

CREATE TABLE Audit_Log (
    Log_ID       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username     VARCHAR2(30),
    Action_Date  TIMESTAMP DEFAULT SYSTIMESTAMP,
    Table_Name   VARCHAR2(30),
    Operation    VARCHAR2(10),
    Status       VARCHAR2(10),
    Details      VARCHAR2(200)
);

CREATE OR REPLACE TRIGGER audit_and_restrict_rentals
BEFORE INSERT OR UPDATE OR DELETE ON Rentals
DECLARE
    v_operation VARCHAR2(10);
BEGIN
    -- Determine operation type
    IF INSERTING THEN
        v_operation := 'INSERT';
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
    ELSE
        v_operation := 'DELETE';
    END IF;

    -- Log the attempt
    INSERT INTO Audit_Log (
        Username,
        Table_Name,
        Operation,
        Status,
        Details
    )
    VALUES (
        USER,
        'RENTALS',
        v_operation,
        CASE
            WHEN TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN') THEN 'ALLOWED'
            ELSE 'DENIED'
        END,
        'Attempted ' || v_operation || ' on Rentals'
    );

    -- Block DML on weekdays
    IF TO_CHAR(SYSDATE,'DY') IN ('MON','TUE','WED','THU','FRI') THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'DML operations on RENTALS are not allowed on weekdays'
        );
    END IF;
END;
/
UPDATE Rentals
SET Return_Date = SYSDATE + 1
WHERE Rental_ID = 502;

SELECT Log_ID,
       Username,
       Table_Name,
       Operation,
       Status,
       Action_Date
FROM Audit_Log
ORDER BY Action_Date DESC;

SELECT 
    COUNT(*) AS total_payments,
    SUM(Amount) AS total_revenue,
    AVG(Amount) AS average_payment
FROM Payments
WHERE Payment_Status = 'Completed';

SELECT 
    TO_CHAR(Payment_Date, 'YYYY-MM') AS month,
    SUM(Amount) AS monthly_revenue
FROM Payments
WHERE Payment_Status = 'Completed'
GROUP BY TO_CHAR(Payment_Date, 'YYYY-MM')
ORDER BY month;

SELECT 
    TO_CHAR(Payment_Date, 'YYYY-MM') AS month,
    SUM(Amount) AS monthly_revenue,
    SUM(SUM(Amount)) OVER (ORDER BY TO_CHAR(Payment_Date, 'YYYY-MM'))
        AS cumulative_revenue
FROM Payments
WHERE Payment_Status = 'Completed'
GROUP BY TO_CHAR(Payment_Date, 'YYYY-MM')
ORDER BY month;
