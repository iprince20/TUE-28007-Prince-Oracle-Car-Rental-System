-- CALCULATE REVENUE
CREATE OR REPLACE FUNCTION calculate_revenue(
    p_start_date IN DATE,
    p_end_date   IN DATE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT SUM(Amount)
    INTO v_total
    FROM Payments
    WHERE Payment_Status = 'Completed'
    AND Payment_Date BETWEEN p_start_date AND p_end_date;

    RETURN v_total;
END;
/

-- VEHICLE AVAILABILITY (1 = YES, 0 = NO)
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

    RETURN CASE WHEN v_count = 0 THEN 1 ELSE 0 END;
END;
/
