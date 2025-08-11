

--Queries
-- Select out of stock menu items
SELECT menu_name, category, availability_status
FROM menu
WHERE availability_status = 'OUT OF STOCK';

-- Select menu items with the least orders
SELECT m.menu_id, m.menu_name, COUNT(od.menu_id) AS order_count
FROM menu m, order_detail od
WHERE m.menu_id = od.menu_id
GROUP BY m.menu_id, m.menu_name
HAVING COUNT(od.menu_id) = (
    SELECT MIN(order_count)
    FROM (
        SELECT COUNT(od.menu_id) AS order_count
        FROM order_detail od
        GROUP BY od.menu_id
    )
)
ORDER BY m.menu_name;

-- Stored Procedure
-- Update order status
CREATE OR REPLACE PROCEDURE update_order_status (
    p_order_id NUMBER,
    p_status VARCHAR2
)
IS
BEGIN
    UPDATE c_order
    SET c_order_status = p_status
    WHERE c_order_id = p_order_id;
    
    DBMS_OUTPUT.PUT_LINE('Order status updated.');
END;
/

-- Calling procedure
EXECUTE update_order_status(11, 'COMPLETED');

-- Display output
SELECT c_order_id, c_order_status
FROM c_order
WHERE c_order_id=11;


-- Update total amount for orders
CREATE OR REPLACE PROCEDURE update_total_amounts IS
    CURSOR order_cursor IS
        SELECT c_order_id
        FROM c_order
        WHERE total_amount IS NULL;
BEGIN
    FOR order_rec IN order_cursor LOOP
        UPDATE c_order
        SET total_amount = (SELECT SUM(subtotal)
                                FROM order_detail
                                WHERE c_order_id = order_rec.c_order_id)
        WHERE c_order_id = order_rec.c_order_id;
    END LOOP;
END;
/

-- Calling procedure
EXECUTE update_total_amounts;

-- Display output
SELECT c_order_id, total_amount
FROM c_order;



-- Functions
-- Count number of orders for each customer
CREATE OR REPLACE FUNCTION count_customer_orders (
    p_customer_id NUMBER
)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM c_order
    WHERE c_id = p_customer_id;
    
    RETURN v_count;
END;
/


-- Calling function and display output
SELECT count_customer_orders(2) FROM dual;



-- Check menu item availability
CREATE OR REPLACE FUNCTION is_menu_item_available (
    p_menu_id NUMBER
)
RETURN VARCHAR2
IS
    v_availability_status VARCHAR2(20);
BEGIN
    BEGIN
        SELECT availability_status
        INTO v_availability_status
        FROM menu
        WHERE menu_id = p_menu_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'MENU ITEM NOT FOUND';
    END;

    IF v_availability_status = 'AVAILABLE' THEN
        RETURN 'AVAILABLE';
    ELSE
        RETURN 'OUT OF STOCK';
    END IF;
END;
/

-- Calling function and display output
SELECT is_menu_item_available(3) from dual;








