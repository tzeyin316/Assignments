

-- Query 1: Find all employees who are working full-day shifts

SELECT e_name, e_role
FROM employee
WHERE shift_schedule = 'FULL-DAY';


-- Query 2: List all customers with pending payment

SELECT c.c_id, c.c_name, c.c_phone, o.c_order_id, o.c_order_date
FROM customer c, c_order o
WHERE c.c_id = o.c_id
AND EXISTS (
	SELECT * 
	FROM payment p 
	WHERE p.c_order_id = o.c_order_id 
	AND p.p_status = 'PENDING'
)
ORDER BY o.c_order_date DESC;


--Stored Procedure 1: Update customer contact
SELECT c_id, c_name, c_phone, c_email
FROM customer
WHERE c_id IN (1,3);

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE update_customer_contact (
    p_c_id NUMBER,
    p_new_phone NUMBER DEFAULT NULL,
    p_new_email VARCHAR2 DEFAULT NULL
)
IS
BEGIN
    IF p_new_phone IS NOT NULL THEN
        UPDATE customer
        SET c_phone = p_new_phone
        WHERE c_id = p_c_id;
    END IF;
    
    IF p_new_email IS NOT NULL THEN
        UPDATE customer
        SET c_email = p_new_email
        WHERE c_id = p_c_id;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Customer ' || p_c_id || ' contact info updated.');
END;
/

-- Calling procedure
EXECUTE update_customer_contact(1, 0129999999);
EXECUTE update_customer_contact(3, 0123333333, 'updated.email@gmail.com');

--Display output
SELECT c_id, c_name, c_phone, c_email
FROM customer
WHERE c_id IN (1,3);


-- Stored Procedure 2: Assign drivers to delivery order

 -- JUST for testing purpose (so that there's delivery order without driver)

Select * FROM delivery;

UPDATE delivery
SET d_id = NULL
WHERE c_order_id IN (11, 12);


--stored procedure 2
CREATE OR REPLACE PROCEDURE assign_drivers IS
    -- Cursor for unassigned delivery orders
    CURSOR delivery_orders_cur IS
        SELECT c_order_id 
        FROM delivery 
        WHERE d_id IS NULL;
    
    -- Cursor for available drivers
    CURSOR available_drivers_cur IS
        SELECT d_id, d_name
        FROM driver
        WHERE d_status = 'AVAILABLE'
        ORDER BY d_id;
    
    v_driver_assigned BOOLEAN;
BEGIN
    -- Go through each unassigned delivery order:
    FOR order_rec IN delivery_orders_cur LOOP
        v_driver_assigned := FALSE;
        
        -- Try to find an available driver
        FOR driver_rec IN available_drivers_cur LOOP
            -- Assign the first available driver
            UPDATE delivery
            SET d_id = driver_rec.d_id
            WHERE c_order_id = order_rec.c_order_id;
            
            -- Mark driver as busy
            UPDATE driver
            SET d_status = 'BUSY'
            WHERE d_id = driver_rec.d_id;
            
            DBMS_OUTPUT.PUT_LINE('Order ' || order_rec.c_order_id || ' assigned to driver ' || driver_rec.d_name || ' (ID: ' || driver_rec.d_id || ')');
            v_driver_assigned := TRUE;
            EXIT;
        END LOOP;
        
        IF NOT v_driver_assigned THEN
            DBMS_OUTPUT.PUT_LINE('No available drivers for order ' || order_rec.c_order_id);
        END IF;
    END LOOP;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error assigning drivers: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Call procedure
EXECUTE assign_drivers;

-- Display output
SELECT * 
FROM delivery;


-- Function 1: Calculate total sales for a specific date
--Add total_amount to record first (bcs total_amount) is value NULL in table.
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, total_amount, c_order_status)
VALUES (100001, 1, 1, 'DINE IN', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 50.00, 'COMPLETED');

INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, total_amount, c_order_status)
VALUES (100002, 1, 1, 'DELIVERY', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 25.00, 'COMPLETED');

COMMIT;

--function 1
CREATE OR REPLACE FUNCTION get_daily_sales(
    p_sales_date DATE
) 
RETURN NUMBER
IS
    v_total_sales NUMBER;
BEGIN
    SELECT NVL(SUM(total_amount), 0) INTO v_total_sales
    FROM c_order
    WHERE TRUNC(c_order_date) = TRUNC(p_sales_date);
    RETURN v_total_sales;
END;
/

-- Display output
SELECT get_daily_sales(TO_DATE('2024-01-15', 'YYYY-MM-DD')) FROM dual;


-- Function 2: Get the busiest hour

CREATE OR REPLACE FUNCTION get_busiest_hour
RETURN VARCHAR2 IS
    v_busiest_hour VARCHAR2(100);
BEGIN
    SELECT LISTAGG(hour, ', ') WITHIN GROUP (ORDER BY hour) INTO v_busiest_hour
    FROM (
        SELECT TO_CHAR(c_order_date, 'HH24') || ':00' as hour,
               COUNT(*) as order_count,
               RANK() OVER (ORDER BY COUNT(*) DESC) as rank
        FROM c_order
        GROUP BY TO_CHAR(c_order_date, 'HH24')
    ) 
    WHERE rank = 1;
    
    RETURN v_busiest_hour;
END;
/

-- Display output
SELECT get_busiest_hour() FROM dual;

