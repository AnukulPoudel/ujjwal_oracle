--2 marks - Procedures
--You need to define at least two procedures so carrying out common operations on database. Include exception section, using cursors.
--1 marks - Functions
--You need to define at least two functions so carrying out common operations on database. Include exception section.
--1.5 marks � Packages 
--a.    Use at least two procedures (could be previously created ones) 
--b.    Use at least two functions (could be previously created ones)
--c.    Include global and private variables / constructs. 
--d.    Use TYPE attribute and/or ROWTYPE attribute whenever it is appropriate 
--need to add this sequence to global plsql script
CREATE SEQUENCE PJ_CUSTOMERS_SEQ MINVALUE 10 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1
START WITH
    11 NOCACHE NOORDER NOCYCLE;

--sp_add_new_customer procedure body
CREATE
OR REPLACE PROCEDURE sp_add_new_customer(
    p_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_address IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zipCode IN VARCHAR2,
    p_country IN VARCHAR2
) AS v_email_exists pj_customers.email % TYPE;

CURSOR cur_customer_email IS
SELECT
    email
FROM
    pj_customers
WHERE
    email = p_email;

BEGIN
    -- Check if the email already exists
    OPEN cur_customer_email;

FETCH cur_customer_email INTO v_email_exists;

CLOSE cur_customer_email;

IF v_email_exists IS NOT NULL THEN RAISE_APPLICATION_ERROR(
    -20001,
    'Customer with this email already exists.'
);

ELSE -- Insert the new customer
INSERT INTO
    pj_customers (
        customerId,
        NAME,
        email,
        phone,
        address,
        city,
        state,
        zipCode,
        country
    )
VALUES
    (
        PJ_CUSTOMERS_SEQ.NEXTVAL,
        p_name,
        p_email,
        p_phone,
        p_address,
        p_city,
        p_state,
        p_zipCode,
        p_country
    );

DBMS_OUTPUT.PUT_LINE('Inserted rows: ' || SQL % ROWCOUNT);

COMMIT;

END IF;

EXCEPTION
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(
        -20002,
        'An error occurred while adding the customer: ' || SQLERRM
    );

END;

/ --sp_add_new_customer test
BEGIN
    sp_add_new_customer(
        'Mandy Ranton',
        'dtrucker@otroman.ca',
        '4378781234',
        '221B Baker Street',
        'Toronto',
        'ON',
        'M1V5T8',
        'Canada'
    );

END;





-- another procedure
/ --sp_update_inventory body
CREATE
OR REPLACE PROCEDURE sp_update_inventory(
    p_productId IN INT,
    p_quantity IN INT,
    p_warehouse_loc IN VARCHAR2
) AS v_product_exists pj_inventory.productId % TYPE;

CURSOR cur_product IS
SELECT
    productId
FROM
    pj_inventory
WHERE
    productId = p_productId;

BEGIN
    -- Check if the product exists in the inventory
    OPEN cur_product;

FETCH cur_product INTO v_product_exists;

CLOSE cur_product;

IF v_product_exists IS NOT NULL THEN -- Update the inventory quantity
UPDATE
    pj_inventory
SET
    quantity = p_quantity
WHERE
    productId = p_productId
    AND location = p_warehouse_loc;

DBMS_OUTPUT.PUT_LINE(
    'Updated rows: ' || SQL % ROWCOUNT || ' using product ID=' || p_productId || ' at ' || p_warehouse_loc
);

COMMIT;

ELSE RAISE_APPLICATION_ERROR(-20003, 'Product not found in the inventory.');

END IF;

EXCEPTION
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(
        -20004,
        'An error occurred while updating the inventory: ' || SQLERRM
    );

END;
-- procedure body ends here


-- calling the procedure
/ --sp_update_inventory test
BEGIN
    sp_update_inventory(5, 100, 'Warehouse B');

END;






/ --function to get total revenue (Creating function)
CREATE
OR REPLACE FUNCTION fn_get_total_revenue(p_start_date DATE, p_end_date DATE) RETURN NUMBER IS v_total_revenue NUMBER := 0;

BEGIN
SELECT
    SUM(totalAmount) INTO v_total_revenue
FROM
    pj_orders
WHERE
    orderDate BETWEEN p_start_date AND p_end_date;

IF v_total_revenue > 0 THEN RETURN v_total_revenue;

ELSE RETURN 0;

END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No orders found in the specified date range.');

RETURN 0;

WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);

RETURN 0;

END;
-- Function ends here


-- Function calling
/ --testing function get total revenue
DECLARE
    v_revenue NUMBER;

BEGIN
    v_revenue := fn_get_total_revenue(
        to_date('01-OCT-2023', 'DD-MON-YYYY'),
        to_date('30-JAN-2023', 'DD-MON-YYYY')
    );

DBMS_OUTPUT.PUT_LINE('Total revenue: ' || v_revenue);

END;





/ --function to get product inventory status
CREATE
OR REPLACE FUNCTION fn_get_product_inventory(p_product_id NUMBER) RETURN NUMBER IS v_inventory_level NUMBER := 0;

BEGIN
SELECT
    SUM(quantity) INTO v_inventory_level
FROM
    pj_inventory
WHERE
    productId = p_product_id;

IF (v_inventory_level >= 0) THEN RETURN v_inventory_level;

ELSE RETURN -1;

END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No inventory found for the specified product.');

RETURN -1;

WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);

RETURN -1;

END;

/ --function to test product inventory
DECLARE
    v_inventory_level NUMBER;

prod_id NUMBER := 5;

BEGIN
    v_inventory_level := fn_get_product_inventory(prod_id);

DBMS_OUTPUT.PUT_LINE(
    'Inventory : ' || v_inventory_level || ' for product id=' || prod_id
);

END;
/ 