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
    END;

    FUNCTION calculate_daily_revenue(p_date IN DATE) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(Amount),0)
        INTO v_total
        FROM Payments
        WHERE Payment_Status = 'Completed'
        AND TRUNC(Payment_Date) = TRUNC(p_date);

        RETURN v_total;
    END;

END car_rental_pkg;
/
