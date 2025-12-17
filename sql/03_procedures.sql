SET SERVEROUTPUT ON;

-- ADD VEHICLE
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

-- RETURN VEHICLE
CREATE OR REPLACE PROCEDURE return_vehicle(
    p_rental_id    IN NUMBER,
    p_actual_date  IN DATE
)
IS
    v_vehicle_id NUMBER;
BEGIN
    SELECT Vehicle_ID INTO v_vehicle_id
    FROM Rentals
    WHERE Rental_ID = p_rental_id;

    UPDATE Rentals
    SET Return_Date = p_actual_date
    WHERE Rental_ID = p_rental_id;

    UPDATE Vehicles
    SET Availability_Status = 'Available'
    WHERE Vehicle_ID = v_vehicle_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vehicle returned successfully!');
END;
/

-- ACTIVE RENTALS (CURSOR)
CREATE OR REPLACE PROCEDURE get_active_rentals
IS
    CURSOR rental_cursor IS
        SELECT r.Rental_ID, c.Name, v.Make, v.Model, r.Rental_Date, r.Return_Date
        FROM Rentals r
        JOIN Customers c ON r.Customer_ID = c.Customer_ID
        JOIN Vehicles v ON r.Vehicle_ID = v.Vehicle_ID
        WHERE r.Return_Date >= SYSDATE;

    v_rec rental_cursor%ROWTYPE;
BEGIN
    OPEN rental_cursor;
    LOOP
        FETCH rental_cursor INTO v_rec;
        EXIT WHEN rental_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Rental ' || v_rec.Rental_ID || ' | ' ||
            v_rec.Name || ' | ' ||
            v_rec.Make || ' ' || v_rec.Model
        );
    END LOOP;
    CLOSE rental_cursor;
END;
/
