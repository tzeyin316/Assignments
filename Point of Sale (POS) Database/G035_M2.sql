

SET SERVEROUTPUT ON;
-- Queries
-- List pending orders
SELECT 
    co.c_order_id,
    co.c_id,
    co.c_order_date,
    co.c_order_status
FROM c_order co
WHERE co.c_order_status = 'PENDING'
ORDER BY co.c_order_date DESC;

-- Find customers who never placed an order
SELECT c.c_id, c.c_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM c_order co
    WHERE co.c_id = c.c_id
);




-- Stored Procedure
-- Add new customer
CREATE OR REPLACE PROCEDURE add_new_customer (
    p_c_id NUMBER,
    p_c_name VARCHAR2,
    p_c_phone NUMBER,
    p_c_email VARCHAR2
)
IS
BEGIN
    INSERT INTO customer (c_id, c_name, c_phone, c_email)
    VALUES (p_c_id, p_c_name, p_c_phone, p_c_email);

    DBMS_OUTPUT.PUT_LINE('New customer added: ' || p_c_name);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Duplicate customer ID, phone, or email.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

-- Calling procedure
EXECUTE add_new_customer(100, 'Ryan Lee', 012345678, 'ryanlee@example.com');

-- Display output
SELECT * FROM customer
WHERE c_id = 100;


--Mark a delivery order as completed
CREATE OR REPLACE PROCEDURE complete_delivery_order (
    p_order_id NUMBER
)
IS
BEGIN
    UPDATE c_order
    SET c_order_status = 'COMPLETED'
    WHERE c_order_id = p_order_id
    AND c_order_type = 'DELIVERY';

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Not a DELIVERY order or order not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Delivery order marked as COMPLETED.');
    END IF;
END;
/

-- Calling procedure
EXECUTE complete_delivery_order(12);

-- Display output
SELECT c_order_id, c_order_type, c_order_status 
FROM c_order 
WHERE c_order_id = 12;



-- Functions
-- Get the total number of orders for a specific menu item
CREATE OR REPLACE FUNCTION get_menu_order_count (
    p_menu_id NUMBER
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM order_detail
    WHERE menu_id = p_menu_id;

    RETURN v_count;
END;
/

-- Calling function
SELECT get_menu_order_count(1) AS total_orders FROM dual;



-- Check if a customer has any pending orders
CREATE OR REPLACE FUNCTION has_pending_order (
    p_cust_id NUMBER
) RETURN VARCHAR2
IS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_exists
    FROM c_order
    WHERE c_id = p_cust_id
    AND c_order_status = 'PENDING';

    IF v_exists > 0 THEN
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;
END;
/

-- Calling function
SELECT has_pending_order(3) AS pending_status FROM dual;


