-- Drop all tables
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE employee CASCADE CONSTRAINTS;
DROP TABLE c_order CASCADE CONSTRAINTS;
DROP TABLE dine_in CASCADE CONSTRAINTS;
DROP TABLE self_pickup CASCADE CONSTRAINTS;
DROP TABLE delivery CASCADE CONSTRAINTS;
DROP TABLE order_detail CASCADE CONSTRAINTS;
DROP TABLE menu CASCADE CONSTRAINTS;
DROP TABLE restaurant_table CASCADE CONSTRAINTS;
DROP TABLE driver CASCADE CONSTRAINTS;
DROP TABLE recipe CASCADE CONSTRAINTS;
DROP TABLE payment CASCADE CONSTRAINTS;
DROP TABLE cash CASCADE CONSTRAINTS;
DROP TABLE credit_card CASCADE CONSTRAINTS;
DROP TABLE mobile_payment CASCADE CONSTRAINTS;
DROP TABLE receipt CASCADE CONSTRAINTS;
DROP TABLE inventory CASCADE CONSTRAINTS;
DROP TABLE inventory_log CASCADE CONSTRAINTS;

-- Create customer table
CREATE TABLE customer (
    c_id NUMBER(6),
    c_name VARCHAR2(30) NOT NULL,
    c_phone NUMBER(10),
    c_email VARCHAR2(30),
    registration_date DATE DEFAULT SYSDATE,
    CONSTRAINT customer_c_id_pk PRIMARY KEY (c_id),
    CONSTRAINT customer_c_phone_uk UNIQUE(c_phone),
    CONSTRAINT customer_c_email_uk UNIQUE(c_email)
);

-- Create employee table
CREATE TABLE employee (
    e_id NUMBER(6),
    e_name VARCHAR2(30) NOT NULL,
    e_phone NUMBER(10),
    e_email VARCHAR2(30),
    e_role VARCHAR2(7) NOT NULL,
    hire_date DATE NOT NULL,
    shift_schedule VARCHAR2(8),
    CONSTRAINT employee_e_id_pk PRIMARY KEY (e_id),
    CONSTRAINT employee_e_phone_uk UNIQUE(e_phone),
    CONSTRAINT employee_e_email_uk UNIQUE(e_email),
    CONSTRAINT employee_e_role_cc CHECK (e_role in ('WAITER', 'CHEF', 'MANAGER', 'CASHIER')),
    CONSTRAINT employee_shift_schedule_cc CHECK (shift_schedule IN ('MORNING', 'EVENING', 'FULL-DAY', 'OFF'))
);

-- Create restaurant_table table
CREATE TABLE restaurant_table (
    t_id NUMBER(3),
    seating_capacity NUMBER(2),
    t_status VARCHAR2(9) NOT NULL,
    CONSTRAINT restaurant_table_t_id_pk PRIMARY KEY (t_id),
    CONSTRAINT restaurant_table_t_status_cc CHECK (t_status in ('AVAILABLE', 'OCCUPIED', 'RESERVED'))
);

-- Create menu table
CREATE TABLE menu (
    menu_id NUMBER(2),
    menu_name VARCHAR2(30),
    price NUMBER(4,2),
    category VARCHAR2(8) NOT NULL,
    availability_status VARCHAR2(12) NOT NULL,
    CONSTRAINT menu_menu_id_pk PRIMARY KEY (menu_id),
    CONSTRAINT menu_category_cc CHECK (category in ('FOOD', 'BEVERAGE')),
    CONSTRAINT menu_availability_status_cc CHECK (availability_status in ('AVAILABLE', 'OUT OF STOCK'))
);

-- Create inventory table
CREATE TABLE inventory (
    inv_id NUMBER(3),
    item_name VARCHAR2(30) NOT NULL,
    stock_quantity NUMBER(4),
    receipt_unit VARCHAR2(15),
    last_updated DATE DEFAULT SYSDATE,
    CONSTRAINT inventory_inv_id_pk PRIMARY KEY (inv_id)
);


-- Create driver table
CREATE TABLE driver (
    d_id NUMBER(6),
    d_name VARCHAR2(30) NOT NULL,
    d_phone NUMBER(10),
    d_vehicle VARCHAR2(7),  
    d_status VARCHAR2(10) NOT NULL,  
    CONSTRAINT d_id_pk PRIMARY KEY (d_id),
    CONSTRAINT driver_d_phone_uk UNIQUE(d_phone),
    CONSTRAINT driver_d_status_cc CHECK (d_status IN ('AVAILABLE', 'BUSY', 'OFF DUTY'))
);

-- Create recipe table
CREATE TABLE recipe (
    menu_id NUMBER(2),
    inv_id NUMBER(3),
    quantity_used NUMBER(2),
    CONSTRAINT recipe_recipe_id_pk PRIMARY KEY (menu_id, inv_id),
    CONSTRAINT recipe_menu_id_fk FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
    CONSTRAINT recipe_inv_id_fk FOREIGN KEY (inv_id) REFERENCES inventory(inv_id)
);

-- Create c_order table
CREATE TABLE c_order (
    c_order_id NUMBER(8),
    c_id NUMBER(6) NOT NULL,
    e_id NUMBER(6) NOT NULL,
    c_order_type VARCHAR2(11),
    c_order_date DATE DEFAULT SYSDATE,
    total_amount NUMBER(5,2),
    c_order_status VARCHAR2(9) NOT NULL,
    CONSTRAINT c_order_c_order_id_pk PRIMARY KEY (c_order_id),
    CONSTRAINT c_order_c_id_fk FOREIGN KEY (c_id) REFERENCES customer(c_id),
    CONSTRAINT c_order_e_id_fk FOREIGN KEY (e_id) REFERENCES employee(e_id),
    CONSTRAINT c_order_c_order_type_cc CHECK (c_order_type in ('DINE IN', 'DELIVERY', 'SELF-PICKUP')),
    CONSTRAINT c_order_c_order_status_cc CHECK (c_order_status in ('COMPLETED', 'PENDING'))
);

-- Create dine_in table
CREATE TABLE dine_in (
    c_order_id NUMBER(8),
    t_id NUMBER(3),
    CONSTRAINT dine_in_c_order_t_id_pk PRIMARY KEY (c_order_id, t_id),
    CONSTRAINT dine_in_c_id_fk FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id),
    CONSTRAINT restaurant_table_c_id_fk FOREIGN KEY (t_id) REFERENCES restaurant_table(t_id)
);

-- Create delivery table
CREATE TABLE delivery (
    c_order_id NUMBER(8),
    delivery_address VARCHAR2(100) NOT NULL,
    d_id NUMBER(6),
    CONSTRAINT delivery_c_order_id_pk PRIMARY KEY (c_order_id),
    CONSTRAINT delivery_c_id_fk FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id),
    CONSTRAINT delivery_d_id_fk FOREIGN KEY (d_id) REFERENCES driver(d_id)
);

-- Create self_pickup table
CREATE TABLE self_pickup (
    c_order_id NUMBER(8),
    pickup_code VARCHAR2(8),
    CONSTRAINT self_pickup_c_order_id_pk PRIMARY KEY (c_order_id),
    CONSTRAINT self_pickup_c_id_fk FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id),
    CONSTRAINT self_pickup_pickup_code_uk UNIQUE(pickup_code)
);

-- Create order_detail table
CREATE TABLE order_detail (
    c_order_id NUMBER(8),
    menu_id NUMBER(2),
    quantity NUMBER(2),
    subtotal NUMBER(5,2),
    CONSTRAINT order_detail_id_pk PRIMARY KEY (c_order_id, menu_id),
    CONSTRAINT order_detail_c_order_id_fk FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id),
    CONSTRAINT order_detail_menu_id_fk FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
);

-- Create payment table
CREATE TABLE payment (
    p_id NUMBER(8),
    c_order_id NUMBER(8) NOT NULL,
    c_id NUMBER(6) NOT NULL,
    p_method VARCHAR2(20) NOT NULL,
    p_date DATE DEFAULT SYSDATE,
    p_status VARCHAR2(20) NOT NULL,
    CONSTRAINT payment_p_id_pk PRIMARY KEY (p_id),
    CONSTRAINT payment_c_order_id_fk FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id),
    CONSTRAINT payment_c_id_fk FOREIGN KEY (c_id) REFERENCES customer(c_id),
    CONSTRAINT payment_p_method_cc CHECK (p_method in ('CASH', 'MOBILE PAYMENT', 'CREDIT CARD')),
    CONSTRAINT payment_p_status_cc CHECK (p_status in ('COMPLETED', 'PENDING'))
);

-- Create cash table
CREATE TABLE cash (
    p_id NUMBER(8),
    cash_tendered NUMBER(4,2),
    change_due NUMBER(4,2),
    CONSTRAINT cash_p_id_pk PRIMARY KEY (p_id),
    CONSTRAINT cash_p_id_fk FOREIGN KEY (p_id) REFERENCES payment(p_id)
);

-- Create mobile_payment table
CREATE TABLE mobile_payment (
    p_id NUMBER(8),
    app_name VARCHAR(20),
    transaction_id VARCHAR2(20),
    CONSTRAINT mobile_payment_p_id_pk PRIMARY KEY (p_id),
    CONSTRAINT mobile_payment_p_id_fk FOREIGN KEY (p_id) REFERENCES payment(p_id),
    CONSTRAINT mobile_payment_transaction_id_uk UNIQUE(transaction_id)
);

-- Create credit_card table
CREATE TABLE credit_card (
    p_id NUMBER(8),
    card_number NUMBER(16) NOT NULL,
    CONSTRAINT credit_card_p_id_pk PRIMARY KEY (p_id),
    CONSTRAINT credit_card_p_id_fk FOREIGN KEY (p_id) REFERENCES payment(p_id),
    CONSTRAINT credit_card_card_number_uk UNIQUE(card_number)
);

-- Create receipt table
CREATE TABLE receipt (
    receipt_id NUMBER(8),
    c_order_id NUMBER(8) NOT NULL,
    generated_date DATE DEFAULT SYSDATE,
    CONSTRAINT receipt_receipt_id_pk PRIMARY KEY (receipt_id),
    CONSTRAINT receipt_c_order_id_fk FOREIGN KEY (c_order_id) REFERENCES c_order(c_order_id)
);

-- Create inventory_log table
CREATE TABLE inventory_log (
    log_id NUMBER(8),
    e_id NUMBER(6),
    inv_id NUMBER(3),
    change_type VARCHAR(7) NOT NULL,
    quantity_changed NUMBER(4) NOT NULL,
    change_date DATE NOT NULL,
    CONSTRAINT inventory_log_log_id_pk PRIMARY KEY (log_id),
    CONSTRAINT inventory_log_e_id_fk FOREIGN KEY (e_id) REFERENCES employee(e_id),
    CONSTRAINT inventory_log_inv_id_fk FOREIGN KEY (inv_id) REFERENCES inventory(inv_id),
    CONSTRAINT inventory_log_change_type_cc CHECK (change_type in ('RESTOCK', 'USAGE'))
);

-- Insert data into customer table
INSERT INTO customer VALUES 
(1, 'Alice', 0123456789, 'alice@gmail.com', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(2, 'Bob', 0187654321, 'bob@gmail.com', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(3, 'Charlie', 0126123789, 'charlie@gmail.com', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(4, 'David', 0124185296, 'david@gmail.com', TO_DATE('2024-01-06', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(5, 'Emma', 0185236974, 'emma@gmail.com', TO_DATE('2024-01-07', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(6, 'Frank', 0112345678, 'frank@gmail.com', TO_DATE('2024-01-08', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(7, 'Grace', 0198765432, 'grace@gmail.com', TO_DATE('2024-01-09', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(8, 'Henry', 0135792468, 'henry@gmail.com', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(9, 'Ivy', 0147258369, 'ivy@gmail.com', TO_DATE('2024-01-11', 'YYYY-MM-DD'));
INSERT INTO customer VALUES 
(10, 'Jack', 0164829375, 'jack@gmail.com', TO_DATE('2024-01-12', 'YYYY-MM-DD'));

-- Insert data into employee table
INSERT INTO employee VALUES
(1, 'John', 0112223333, 'john@gmail.com', 'WAITER', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'MORNING');
INSERT INTO employee VALUES
(2, 'Sarah', 0126555666, 'sarah@gmail.com', 'CHEF', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'MORNING');
INSERT INTO employee VALUES
(3, 'Mike', 0182956384, 'mike@gmail.com', 'MANAGER', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'FULL-DAY');
INSERT INTO employee VALUES
(4, 'Anna', 0124568935, 'anna@gmail.com', 'CASHIER', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'FULL-DAY');
INSERT INTO employee VALUES
(5, 'Tom', 0118888888, 'tom@gmail.com', 'WAITER', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'EVENING');
INSERT INTO employee VALUES
(6, 'Lisa', 0177777777, 'lisa@gmail.com', 'CHEF', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'EVENING');
INSERT INTO employee VALUES
(7, 'David', 0199988777, 'david@gmail.com', 'WAITER', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'OFF');

-- Insert data into restaurant_table table
INSERT INTO restaurant_table VALUES
(101, 4, 'AVAILABLE');
INSERT INTO restaurant_table VALUES
(102, 2, 'AVAILABLE');
INSERT INTO restaurant_table VALUES
(103, 6, 'AVAILABLE');
INSERT INTO restaurant_table VALUES
(104, 8, 'RESERVED');
INSERT INTO restaurant_table VALUES
(105, 4, 'AVAILABLE');
INSERT INTO restaurant_table VALUES
(106, 4, 'OCCUPIED');
INSERT INTO restaurant_table VALUES
(107, 2, 'OCCUPIED');
INSERT INTO restaurant_table VALUES
(108, 4, 'AVAILABLE');
INSERT INTO restaurant_table VALUES
(109, 6, 'AVAILABLE');
INSERT INTO restaurant_table VALUES
(110, 8, 'AVAILABLE');

-- Insert data into menu table
INSERT INTO menu VALUES
(1, 'Chicken Burger', 8.00, 'FOOD', 'AVAILABLE');
INSERT INTO menu VALUES
(2, 'Beef Burger', 8.00, 'FOOD', 'AVAILABLE');
INSERT INTO menu VALUES
(3, 'Fried Chicken', 7.00, 'FOOD', 'AVAILABLE');
INSERT INTO menu VALUES
(4, 'Coke', 3.00, 'BEVERAGE', 'OUT OF STOCK');
INSERT INTO menu VALUES
(5, 'Sprite', 3.00, 'BEVERAGE', 'AVAILABLE');

-- Insert data into inventory table
INSERT INTO inventory VALUES
(1, 'Chicken Patty', 100, 'each', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES
(2, 'Cheese', 100, 'slice', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES
(3, 'Bread', 100, 'each', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES
(4, 'Chicken', 50, 'pieces', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES
(5, 'Beef Patty', 100, 'each', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES
(6, 'Coke', 0, 'bottle', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES
(7, 'Sprite', 100, 'bottle', TO_DATE('2024-01-15', 'YYYY-MM-DD'));

-- Insert data into driver table
INSERT INTO driver VALUES
(1, 'James', 0191234567, 'ABD1234', 'AVAILABLE');
INSERT INTO driver VALUES
(2, 'Irene', 0182345678, 'EFH5678', 'BUSY');
INSERT INTO driver VALUES
(3, 'Michael', 0173456789, 'JKM9876', 'OFF DUTY');
INSERT INTO driver VALUES
(4, 'Sophia', 0164567890, 'MNP1234', 'AVAILABLE');
INSERT INTO driver VALUES
(5, 'Chris', 0155678901, 'QRT5678', 'BUSY');

-- Insert data into recipe table
INSERT INTO recipe VALUES
(1, 1, 1);
INSERT INTO recipe VALUES
(1, 2, 1);
INSERT INTO recipe VALUES
(1, 3, 1);
INSERT INTO recipe VALUES
(2, 5, 1);
INSERT INTO recipe VALUES
(2, 2, 1);
INSERT INTO recipe VALUES
(2, 3, 1);
INSERT INTO recipe VALUES
(3, 4, 3);
INSERT INTO recipe VALUES
(4, 6, 1);
INSERT INTO recipe VALUES
(5, 7, 1);

-- Insert data into c_order table
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(1, 1, 1, 'DINE IN', TO_DATE('2024-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(2, 2, 5, 'DELIVERY', TO_DATE('2024-01-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(3, 3, 4, 'DINE IN', TO_DATE('2024-01-05 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(4, 4, 4, 'SELF-PICKUP', TO_DATE('2024-01-06 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(5, 5, 1, 'DINE IN', TO_DATE('2024-01-07 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(6, 6, 5, 'DELIVERY', TO_DATE('2024-01-15 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(7, 7, 4, 'DINE IN', TO_DATE('2024-01-15 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(8, 8, 5, 'DELIVERY', TO_DATE('2024-01-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(9, 9, 1, 'DINE IN', TO_DATE('2024-01-15 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(10, 10, 4, 'SELF-PICKUP', TO_DATE('2024-01-15 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(11, 2, 5, 'DELIVERY', TO_DATE('2024-01-15 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(12, 4, 4, 'DELIVERY', TO_DATE('2024-01-15 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(13, 5, 4, 'SELF-PICKUP', TO_DATE('2024-01-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(14, 6, 5, 'SELF-PICKUP', TO_DATE('2024-01-15 23:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(15, 9, 1, 'SELF-PICKUP', TO_DATE('2024-01-15 23:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(16, 1, 2, 'DELIVERY', TO_DATE('2024-01-16 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(17, 2, 4, 'DINE IN', TO_DATE('2024-01-16 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(18, 3, 6, 'SELF-PICKUP', TO_DATE('2024-01-16 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(19, 4, 1, 'DELIVERY', TO_DATE('2024-01-16 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(20, 5, 4, 'DINE IN', TO_DATE('2024-01-16 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(21, 3, 6, 'SELF-PICKUP', TO_DATE('2024-01-16 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(22, 7, 5, 'DELIVERY', TO_DATE('2024-01-16 16:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(23, 8, 3, 'DINE IN', TO_DATE('2024-01-16 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(24, 3, 4, 'SELF-PICKUP', TO_DATE('2024-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'COMPLETED');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(25, 10, 1, 'DELIVERY', TO_DATE('2024-01-16 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(26, 2, 2, 'SELF-PICKUP', TO_DATE('2024-01-16 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(27, 3, 5, 'DELIVERY', TO_DATE('2024-01-16 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(28, 4, 3, 'DINE IN', TO_DATE('2024-01-16 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(29, 5, 4, 'DINE IN', TO_DATE('2024-01-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');
INSERT INTO c_order (c_order_id, c_id, e_id, c_order_type, c_order_date, c_order_status) VALUES
(30, 6, 2, 'DELIVERY', TO_DATE('2024-01-16 23:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'PENDING');


-- Insert data into dine_in table
INSERT INTO dine_in VALUES (1, 102);
INSERT INTO dine_in VALUES (3, 105);
INSERT INTO dine_in VALUES (5, 101);
INSERT INTO dine_in VALUES (7, 106);
INSERT INTO dine_in VALUES (9, 107);

-- Insert data into delivery table
INSERT INTO delivery VALUES (2, '123 Main St, Apt 4B', 1);
INSERT INTO delivery VALUES (6, '456 Oak Ave, Unit 12', 2);
INSERT INTO delivery VALUES (8, '789 Pine Rd, House 5', 2);
INSERT INTO delivery VALUES (11, '321 Elm St, Apt 2A', 4);
INSERT INTO delivery VALUES (12, '159 Maple Dr, Unit 3', 5);

-- Insert data into self_pickup table
INSERT INTO self_pickup VALUES (4, 'PICK001');
INSERT INTO self_pickup VALUES (10, 'PICK002');
INSERT INTO self_pickup VALUES (13, 'PICK003');
INSERT INTO self_pickup VALUES (14, 'PICK004');
INSERT INTO self_pickup VALUES (15, 'PICK005');

-- Insert data into order_detail table
INSERT INTO order_detail VALUES (1, 1, 2, 16.00);
INSERT INTO order_detail VALUES (1, 5, 2, 6.00);
INSERT INTO order_detail VALUES (2, 3, 1, 7.00);
INSERT INTO order_detail VALUES (2, 5, 3, 9.00);
INSERT INTO order_detail VALUES (3, 5, 4, 12.00);
INSERT INTO order_detail VALUES (4, 1, 1, 8.00);
INSERT INTO order_detail VALUES (5, 1, 4, 32.00);
INSERT INTO order_detail VALUES (6, 3, 2, 14.00);
INSERT INTO order_detail VALUES (6, 5, 1, 3.00);
INSERT INTO order_detail VALUES (7, 1, 1, 8.00);
INSERT INTO order_detail VALUES (8, 3, 2, 14.00);
INSERT INTO order_detail VALUES (9, 1, 2, 16.00);
INSERT INTO order_detail VALUES (10, 5, 4, 12.00);
INSERT INTO order_detail VALUES (11, 1, 5, 40.00);
INSERT INTO order_detail VALUES (12, 1, 6, 48.00);
INSERT INTO order_detail VALUES (13, 2, 7, 56.00);
INSERT INTO order_detail VALUES (14, 3, 9, 63.00);
INSERT INTO order_detail VALUES (15, 3, 10, 70.00);
INSERT INTO order_detail VALUES (16, 1, 2, 16.00);
INSERT INTO order_detail VALUES (16, 5, 3, 9.00);
INSERT INTO order_detail VALUES (17, 2, 1, 8.00);
INSERT INTO order_detail VALUES (18, 4, 1, 3.00);
INSERT INTO order_detail VALUES (19, 5, 3, 9.00);
INSERT INTO order_detail VALUES (19, 1, 4, 32.00);
INSERT INTO order_detail VALUES (20, 2, 5, 40.00);
INSERT INTO order_detail VALUES (21, 3, 8, 56.00);
INSERT INTO order_detail VALUES (22, 4, 1, 3.00);
INSERT INTO order_detail VALUES (22, 2, 3, 24.00);
INSERT INTO order_detail VALUES (23, 5, 6, 18.00);
INSERT INTO order_detail VALUES (24, 3, 2, 14.00);
INSERT INTO order_detail VALUES (24, 2, 1, 8.00);
INSERT INTO order_detail VALUES (25, 1, 4, 32.00);
INSERT INTO order_detail VALUES (25, 5, 5, 15.00);
INSERT INTO order_detail VALUES (26, 3, 1, 7.00);
INSERT INTO order_detail VALUES (27, 5, 9, 27.00);
INSERT INTO order_detail VALUES (28, 1, 3, 24.00);
INSERT INTO order_detail VALUES (28, 2, 4, 32.00);
INSERT INTO order_detail VALUES (29, 2, 8, 64.00);
INSERT INTO order_detail VALUES (30, 5, 7, 21.00);


-- Insert data into payment table
INSERT INTO payment VALUES (1, 1, 1, 'CASH', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (2, 2, 2, 'MOBILE PAYMENT', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (3, 3, 3, 'CASH', TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (4, 4, 4, 'CASH', TO_DATE('2024-01-06', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (5, 5, 5, 'CASH', TO_DATE('2024-01-07', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (6, 6, 6, 'MOBILE PAYMENT', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (7, 7, 7, 'CREDIT CARD', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (8, 8, 8, 'MOBILE PAYMENT', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (9, 9, 9, 'CREDIT CARD', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (10, 10, 10, 'CASH', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (11, 11, 2, 'MOBILE PAYMENT', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'PENDING');
INSERT INTO payment VALUES (12, 12, 4, 'MOBILE PAYMENT', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'PENDING');
INSERT INTO payment VALUES (13, 13, 5, 'CREDIT CARD', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (14, 14, 6, 'CREDIT CARD', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'COMPLETED');
INSERT INTO payment VALUES (15, 15, 9, 'CREDIT CARD', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'PENDING');

-- Insert data into cash table
INSERT INTO cash VALUES (1, 22.00, 0.00);
INSERT INTO cash VALUES (3, 12.00, 0.00);
INSERT INTO cash VALUES (4, 10.00, 2.00);
INSERT INTO cash VALUES (5, 32.00, 0.00);
INSERT INTO cash VALUES (10, 20.00, 8.00);

-- Insert data into mobile_payment table
INSERT INTO mobile_payment VALUES (2, 'GrabPay', 'GRAB123456789');
INSERT INTO mobile_payment VALUES (4, 'Boost', 'BOOST987654321');
INSERT INTO mobile_payment VALUES (8, 'GrabPay', 'GRAB555654321');
INSERT INTO mobile_payment VALUES (10, 'Boost', 'BOOST123456789');
INSERT INTO mobile_payment VALUES (5, 'GrabPay', 'GRAB555555555');

-- Insert data into credit_card table
INSERT INTO credit_card VALUES (7, '4111111111111111');
INSERT INTO credit_card VALUES (9, '5555555555554444');
INSERT INTO credit_card VALUES (13, '3782822463100050');
INSERT INTO credit_card VALUES (14, '5105105105105100');
INSERT INTO credit_card VALUES (15, '8884449354863210');

-- Insert data into receipt table
INSERT INTO receipt VALUES (1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (2, 2, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (3, 3, TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (4, 4, TO_DATE('2024-01-06', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (5, 5, TO_DATE('2024-01-07', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (6, 6, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (7, 7, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (8, 8, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (9, 9, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (10, 10, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (11, 11, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (12, 12, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (13, 13, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (14, 14, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO receipt VALUES (15, 15, TO_DATE('2024-01-15', 'YYYY-MM-DD'));

-- Insert data into inventory_log table
INSERT INTO inventory_log VALUES (1, 3, 1, 'RESTOCK', 300, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (2, 3, 2, 'RESTOCK', 500, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (3, 3, 3, 'RESTOCK', 500, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (4, 3, 4, 'RESTOCK', 400, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (5, 3, 5, 'RESTOCK', 300, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (6, 3, 6, 'RESTOCK', 600, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (7, 3, 7, 'RESTOCK', 600, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (8, 4, 1, 'USAGE', -200, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (9, 5, 2, 'USAGE', -400, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (10, 6, 3, 'USAGE', -400, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (11, 6, 4, 'USAGE', -350, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (12, 2, 5, 'USAGE', -200, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (13, 1, 6, 'USAGE', -600, TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO inventory_log VALUES (14, 1, 7, 'USAGE', -500, TO_DATE('2024-01-15', 'YYYY-MM-DD'));

COMMIT;