
-- query 1: List all available drivers

SELECT d_id, d_name, d_vehicle, 
SUBSTR(TO_CHAR(d_phone, 'FM0000000000'), 1, 3) || '-'|| 
SUBSTR(TO_CHAR(d_phone, 'FM0000000000'), 4, 3) || ' ' || 
SUBSTR(TO_CHAR(d_phone, 'FM0000000000'), 7, 4) AS d_phone
FROM driver
WHERE d_status = 'AVAILABLE';

-- query 2: List all available tables

SELECT t_id, seating_capacity
FROM restaurant_table
WHERE t_status = 'AVAILABLE';


-- Stored function 1: Add a new menu item

CREATE OR REPLACE PROCEDURE add_menu(
cur_menu_id 	IN NUMBER,
cur_menu_name 	IN VARCHAR2,
cur_price 	IN NUMBER,
cur_category 	IN VARCHAR2,
cur_availability IN VARCHAR2
)
IS

BEGIN

	INSERT INTO menu (menu_id, menu_name, price, category, availability_status) 
    VALUES (cur_menu_id, cur_menu_name, cur_price, cur_category, cur_availability);

	COMMIT;

END;
/

-- Calling stored function 1
SELECT * FROM menu;
EXECUTE add_menu(6, 'Samurai Burger', 8.50, 'FOOD', 'AVAILABLE');


-- Stored function 2: Update menu item availability

CREATE OR REPLACE PROCEDURE update_menu_availability (
cur_menu_id 	IN NUMBER,
cur_availability IN VARCHAR2
) 
IS

BEGIN
	UPDATE menu
	SET availability_status = cur_availability
	WHERE menu_id = cur_menu_id;

	COMMIT;
END;
/

-- Display menu table
SELECT * 
FROM menu
WHERE menu_id = 4;

-- Calling stored function 2
EXECUTE update_menu_availability(4, 'AVAILABLE');


-- Function 1: Show the order detail of an order 

CREATE OR REPLACE FUNCTION cust_order_detail 
(cur_c_order_id IN NUMBER) 
RETURN VARCHAR2

IS
    result        VARCHAR2(32767);
    has_data      BOOLEAN := FALSE;
    check_c_order_id      VARCHAR2(30);
    
    invalid_order_detail EXCEPTION;

    CURSOR order_cursor IS
        SELECT m.menu_name, od.quantity, od.subtotal
        FROM order_detail od, menu m
        WHERE od.menu_id = m.menu_id
        AND od.c_order_id = cur_c_order_id;

    order_rec order_cursor%ROWTYPE;

BEGIN

    -- check whether c_order_id exist
    BEGIN
        SELECT c_order_id INTO check_c_order_id
	    FROM c_order
	    WHERE c_order_id = cur_c_order_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Error: c_order_ID ' || cur_c_order_id || ' does not exist.';
    END;

    result :=   RPAD('MENU NAME',20) ||
                RPAD('QUANTITY', 9)||
                RPAD('SUBTOTAL (RM)', 13) || CHR(10) ||
                '------------------- -------- -------------'|| CHR(10);

    FOR order_rec IN order_cursor
    LOOP
        has_data := TRUE;

        result :=   result || 
                    RPAD(order_rec.menu_name, 20) ||
                    LPAD(order_rec.quantity, 8) ||
                    LPAD(TO_CHAR(order_rec.subtotal, 'FM9990.00'),14) || CHR(10);    
    END LOOP;

    IF NOT has_data THEN
        raise invalid_order_detail;
    END IF;

    RETURN result;

EXCEPTION 
    WHEN invalid_order_detail THEN
        RETURN 'Error: There is no order detail for this order.';

    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;

END;
/

-- Calling function 1

SELECT cust_order_detail(2) FROM DUAL;


-- Function 2: Show recipe of a menu

CREATE OR REPLACE FUNCTION get_recipe 
(cur_menu_id IN NUMBER) 
RETURN VARCHAR2 

IS
    result VARCHAR2(32767);
	cur_menu_name MENU.menu_name%TYPE;
    has_data BOOLEAN := FALSE;
    invalid_recipe EXCEPTION;

    CURSOR recipe_cursor IS
        SELECT i.item_name, i.receipt_unit, r.quantity_used
        FROM recipe r, inventory i
        WHERE r.inv_id = i.inv_id
	    AND r.menu_id = cur_menu_id;

    recipe_rec recipe_cursor%ROWTYPE;

BEGIN

    BEGIN
	    SELECT menu_name INTO cur_menu_name
	    FROM menu
	    WHERE menu_id = cur_menu_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Error: Menu_ID ' || cur_menu_id || ' does not exist.';
    END;

    result :=   'Menu Name: '|| cur_menu_name || CHR(10) || CHR(10) ||
                RPAD('ITEM NAME',20) ||
                RPAD('RECEIPT UNIT',15)|| 
                RPAD('QUANTITY USED',15) || CHR(10)||
                ('------------------- ------------   -------------')|| CHR(10);


    FOR recipe_rec IN recipe_cursor
    LOOP
        has_data := TRUE;

	    result := result ||
        RPAD(recipe_rec.item_name,20)||
        RPAD(recipe_rec.receipt_unit,15)||
        LPAD(recipe_rec.quantity_used,13) || CHR(10);

    END LOOP;

    IF NOT has_data THEN
        raise invalid_recipe;
    END IF;

    RETURN result;

    EXCEPTION
        WHEN invalid_recipe THEN
            RETURN 'Error: There is no recipe for this menu item.';

        WHEN OTHERS THEN
            RETURN 'Error: ' || SQLERRM;
END;
/

-- Calling function 2

SELECT get_recipe(2) FROM DUAL;

