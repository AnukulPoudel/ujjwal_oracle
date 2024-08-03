-- Create tables

CREATE TABLE pj_customers(
    customerId INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR2(255),
    city VARCHAR(100),
    state VARCHAR2(100),
    zipCode VARCHAR2(10),
    country VARCHAR2(100),
    CONSTRAINT customer_id_pk PRIMARY KEY (customerId)
);

CREATE INDEX customerId_city_country ON pj_customers (customerId, city, country);

INSERT INTO pj_customers
VALUES(49, 'Kevin Jimenez', 'kathryntorres@example.org', '(413)643-8982x614', '8972 Patterson Haven
Port Ericaborough FM 62343', 'Lake Sierraborough', 'Louisiana', '36404', 'Malawi');
INSERT INTO pj_customers
VALUES(91, 'Ashley Ochoa', 'allensmith@example.com', '625.994.8828x239', 'Unit 8156 Box 9873
DPO AA 93891', 'Amyberg', 'Idaho', '53009', 'Saint Barthelemy');
INSERT INTO pj_customers
VALUES (90, 'Amanda Crosby', 'campbellapril@example.net', '001-596-733-7348x984', '83850 Combs Extensions Suite 291
North Kimberlybury, MO 24746', 'North Elizabeth', 'Oregon', '55632', 'Haiti');
INSERT INTO pj_customers
VALUES(70, 'Brittany Patrick', 'karensmith@example.org', '664-609-1908', '44277 Foster Dale Suite 740
East Josephmouth, GA 10493', 'Larryhaven', 'Idaho', '14822', 'Turkmenistan');
INSERT INTO pj_customers
VALUES(41, 'Julia Wilson', 'zimmermanthomas@example.org', '(530)641-0144', '746 Mccarty Flat
South Richardfurt, NV 81609', 'Christopherberg', 'Ohio', '57601', 'Mauritania');

CREATE TABLE pj_suppliers(
    supplierId INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    contactName VARCHAR2(100),
    email VARCHAR2(100),
    phone VARCHAR2(20),
    address VARCHAR2(255),
    city VARCHAR2(100),
    state VARCHAR2(100),
    zipCode VARCHAR2(10),
    country VARCHAR2(100),
    CONSTRAINT supplier_id_pk PRIMARY KEY (supplierId)
);

CREATE INDEX supplierId_city_country ON pj_suppliers (supplierId, city, country);

INSERT INTO pj_suppliers
VALUES(8, 'Phillip Cortez', 'Juan Curry', 'perezdavid@example.com', '654.490.2099', NULL, NULL, NULL, NULL, NULL);
INSERT INTO pj_suppliers
VALUES(16, 'Antonio Shelton', 'Taylor Powers', 'ymeyer@example.com', '338-469-5847', '49412 Kathryn Forks
Lake Megan, AL 11506', 'Bryantmouth', 'Hawaii', '87781', 'Myanmar');
INSERT INTO pj_suppliers
VALUES(32, 'Andrew Schmidt', 'Roger Tucker', 'djenkins@example.com', '8134592278', '2137 Miller Island Suite 812
Danielland, MN 38733', 'New David', 'Arkansas', '15613', 'Swaziland');
INSERT INTO pj_suppliers
VALUES(47, 'James Flores', 'Danielle Bennett', 'kristin17@example.net', '659-668-8082x3848', '7352 Preston Mall Suite 112
Waltermouth, OH 41030', 'Wilsonberg', 'Connecticut', '77479', 'China');
INSERT INTO pj_suppliers
VALUES(38, 'Andrew Schmidt', 'Roger Tucker', 'djenkins@example.com', '8134592278', '2137 Miller Island Suite 812
Danielland, MN 38733', 'New David', 'Arkansas', '15613', 'Swaziland');

CREATE TABLE pj_products (
    productId INT NOT NULL,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR(255),
    unitPrice DECIMAL(10, 2),
    quantityAvailable INT NOT NULL,
    supplierId INT,
    CONSTRAINT product_id_pk PRIMARY KEY (productId),
    CONSTRAINT supplier_id_fk FOREIGN KEY (supplierId) REFERENCES pj_suppliers (supplierId)
);

INSERT INTO pj_products
VALUES(1, 'Product A', 'Durable and versatile', 29.99, 50, 32);
INSERT INTO pj_products
VALUES(5, 'Product B', 'High-performance item', 49.95, 35, 32);
INSERT INTO pj_products
VALUES(4, 'Product C', 'Compact and efficient', 19.99, 75, 47);
INSERT INTO pj_products
VALUES(10, 'Product D', 'Luxury and style', 99.92, 20, 8);
INSERT INTO pj_products
VALUES(3, 'Product E', 'Everyday essential', 14.55, 47, 38);

CREATE TABLE pj_orders (
    orderId INT NOT NULL,
    customerId INT NOT NULL,
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    totalAmount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50),
    deliveryDate TIMESTAMP,
    CONSTRAINT order_id_pk PRIMARY KEY (orderId),
    CONSTRAINT customer_id_fk FOREIGN KEY (customerId) REFERENCES pj_customers (customerId)
);
CREATE SEQUENCE pj_order_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE INDEX orderId_orderDate_status ON pj_orders (orderId, orderDate, status);

INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 49, TIMESTAMP '2023-11-22 12:34:56', 199.99, 'Pending', NULL);
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 49, TIMESTAMP '2023-11-23 09:15:30', 99.95, 'Shipped', NULL);
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 91, TIMESTAMP '2023-11-24 14:25:15', 299.90, 'Completed', TIMESTAMP '2023-11-25 14:35:06');
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 90, TIMESTAMP '2023-11-25 16:30:00', 145.50, 'Completed', TIMESTAMP '2023-11-26 09:10:25');
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 70, TIMESTAMP '2023-11-26 11:00:45', 399, 'Pending', NULL);
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 70, TIMESTAMP '2023-11-27 18:15:30', 79.25, 'Shipped', NULL);
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 41, TIMESTAMP '2023-11-28 09:30:15', 249.59, 'Processing', NULL);
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 41, TIMESTAMP '2023-11-29 15:45:00', 67, 'Completed', TIMESTAMP '2023-11-30 12:00:02');
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 41, TIMESTAMP '2023-11-30 12:00:45', 129.50, 'Pending', NULL);
INSERT INTO pj_orders
VALUES(pj_order_seq.NEXTVAL, 90, TIMESTAMP '2023-12-01 19:15:30', 15.54, 'Shipped', NULL);

CREATE TABLE pj_order_details (
    orderDetailId INT NOT NULL,
    orderId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2),
    CONSTRAINT order_detail_id_pk PRIMARY KEY (orderDetailId),
    CONSTRAINT order_id_fk FOREIGN KEY (orderId) REFERENCES pj_orders (orderId),
    CONSTRAINT product_id_fk FOREIGN KEY (productId) REFERENCES pj_products (productId)
);
CREATE SEQUENCE pj_order_details_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE INDEX orderId_productId ON pj_order_details(orderId, productId);

INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 1, 1, 2, 59.98);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 1, 3, 1, 14.55);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 2, 4, 1, 99.92);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 3, 5, 6, 299.70);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 4, 10, 2, 99.90);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 5, 1, 1, 29.99);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 5, 4, 3, 299.76);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 6, 3, 1, 14.55);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 6, 10, 2, 99.90);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 7, 5, 5, 249.75);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 8, 1, 2, 59.98);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 8, 3, 1, 14.55);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 9, 5, 2, 99.90);
INSERT INTO pj_order_details
VALUES(pj_order_details_seq.NEXTVAL, 10, 4, 1, 99.92);

CREATE TABLE pj_shipments (
    shipmentId INT NOT NULL,
    orderId INT NOT NULL,
    shipmentDate DATE DEFAULT SYSDATE,
    carrier VARCHAR2(100),
    trackingNumber VARCHAR2(100),
    status VARCHAR2(50),
    CONSTRAINT shipment_id_pk PRIMARY KEY (shipmentId),
    CONSTRAINT order_id_shipments_fk FOREIGN KEY (orderId) REFERENCES pj_orders (orderId)
);
CREATE SEQUENCE pj_shipments_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE INDEX orderId_trackingNumber ON pj_shipments (orderId, trackingNumber);

INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 1, TO_DATE('2023-11-23', 'YYYY-MM-DD'), 'UPS', '1Z999AA10123456784', 'Shipped');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 2, TO_DATE('2023-11-24', 'YYYY-MM-DD'), 'FedEx', '123456789012', 'In Transit');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 3, TO_DATE('2023-11-25', 'YYYY-MM-DD'), 'DHL', 'JD014600002000153176', 'Delivered');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 4, TO_DATE('2023-11-26', 'YYYY-MM-DD'), 'USPS', '9400110897700004264803', 'Delivered');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 5, TO_DATE('2023-11-27', 'YYYY-MM-DD'), 'UPS', '1Z999AA10123456784', 'Pending');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 6, TO_DATE('2023-11-28', 'YYYY-MM-DD'), 'FedEx', '123456789012', 'In Transit');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 7, TO_DATE('2023-11-29', 'YYYY-MM-DD'), 'DHL', 'JD014600002000153176', 'Shipped');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 8, TO_DATE('2023-11-30', 'YYYY-MM-DD'), 'USPS', '9400110897700004264803', 'Delivered');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 9, TO_DATE('2023-12-01', 'YYYY-MM-DD'), 'UPS', '1Z999AA10123456784', 'In Transit');
INSERT INTO pj_shipments
VALUES(pj_shipments_seq.NEXTVAL, 10, TO_DATE('2023-12-02', 'YYYY-MM-DD'), 'FedEx', '123456789012', 'Shipped');

CREATE TABLE pj_inventory (
    inventoryId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT,
    location VARCHAR2(100),
    CONSTRAINT inventory_id_pk PRIMARY KEY (inventoryId),
    CONSTRAINT product_id_inventory_fk FOREIGN KEY (productId) REFERENCES pj_products (productId)
);
CREATE SEQUENCE pj_inventory_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 1, 100, 'Warehouse A');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 5, 200, 'Warehouse B');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 3, 150, 'Warehouse A');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 4, 75, 'Warehouse C');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 5, 120, 'Warehouse B');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 10, 50, 'Warehouse A');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 1, 80, 'Warehouse D');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 10, 160, 'Warehouse C');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 3, 140, 'Warehouse B');
INSERT INTO pj_inventory
VALUES(pj_inventory_seq.NEXTVAL, 4, 90, 'Warehouse A');

CREATE TABLE pj_users (
    userId INT NOT NULL,
    email VARCHAR2(255),
    password CHAR(64) NOT NULL,
    role CHAR(100) NOT NULL,
    CONSTRAINT user_id_pk PRIMARY KEY (userId)
);
INSERT INTO pj_users (userId, email, password, role)
VALUES (301379640, 'dsarmie7@my.centennialcollege.ca', 'password', 'production planner');
INSERT INTO pj_users (userId, email, password, role)
VALUES (301400662, 'sneupa23@my.centennialcollege.ca', 'password', 'Warehouse Supervisor');
INSERT INTO pj_users (userId, email, password, role)
VALUES (301284284, 'upoudel1@my.centennialcollege.ca', 'password', 'Buyer');


CREATE OR REPLACE TRIGGER trg_update_inventory
AFTER INSERT ON pj_order_details
FOR EACH ROW
BEGIN
    UPDATE pj_inventory
    SET quantity = quantity - :NEW.quantity
    WHERE productId = :NEW.productId;
END;

CREATE OR REPLACE TRIGGER trg_update_delivery
AFTER INSERT OR UPDATE ON pj_shipments
FOR EACH ROW
BEGIN
    IF :NEW.status = 'Delivered' THEN
        UPDATE pj_orders
        SET deliveryDate = CURRENT_TIMESTAMP,
            status = 'Completed'
        WHERE orderId = :NEW.orderId;
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_order_id_seq
BEFORE INSERT ON  pj_orders
FOR EACH ROW
BEGIN
    :new.orderId := pj_orders_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_order_details_seq
BEFORE INSERT ON  pj_orders_details
FOR EACH ROW
BEGIN
    :new.orderDetailId := pj_order_details_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_inventory_seq
BEFORE INSERT ON  pj_inventory
FOR EACH ROW
BEGIN
    :new.inventoryId := pj_inventory_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_shipments_seq
BEFORE INSERT ON  pj_shipments
FOR EACH ROW
BEGIN
    :new.shipmentId := pj_shipments_seq.NEXTVAL;
END;