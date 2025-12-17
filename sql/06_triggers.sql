CREATE OR REPLACE TRIGGER audit_and_restrict_rentals
BEFORE INSERT OR UPDATE OR DELETE ON Rentals
DECLARE
    v_operation VARCHAR2(10);
BEGIN
    IF INSERTING THEN v_operation := 'INSERT';
    ELSIF UPDATING THEN v_operation := 'UPDATE';
    ELSE v_operation := 'DELETE';
    END IF;

    INSERT INTO Audit_Log (Username, Table_Name, Operation, Status, Details)
    VALUES (
        USER,
        'RENTALS',
        v_operation,
        CASE WHEN TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN')
             THEN 'ALLOWED' ELSE 'DENIED' END,
        'Attempted ' || v_operation || ' on Rentals'
    );

    IF TO_CHAR(SYSDATE,'DY') IN ('MON','TUE','WED','THU','FRI') THEN
        RAISE_APPLICATION_ERROR(-20001,'DML not allowed on weekdays');
    END IF;
END;
/
