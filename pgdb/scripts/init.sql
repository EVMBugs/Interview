CREATE TABLE IF NOT EXISTS CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    email VARCHAR(150),
    pwdHash VARCHAR(150),
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS CUSTOMERADDRESS (
    address_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES CUSTOMER(customer_id),
    firstLine VARCHAR(255),
    secondLine VARCHAR(255),
    complementLine VARCHAR(255),
    city VARCHAR(150),
    zipcode VARCHAR(20),
    preferred BOOLEAN,
    disabled BOOLEAN
);

CREATE TABLE IF NOT EXISTS EGRESSORDER (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES CUSTOMER(customer_id),
    address_id INT REFERENCES CUSTOMERADDRESS(address_id),
    orderPublicId VARCHAR(255),
    orderPlaced DATE,
    total DOUBLE PRECISION,
    currency VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS SHIPMENT (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES EGRESSORDER(order_id)
);

CREATE TABLE IF NOT EXISTS TRAVELHISTORY (
    travelHistory_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES SHIPMENT(shipment_id),
    milestone VARCHAR(255),
    extendedDescription VARCHAR(255),
    city VARCHAR(150),
    lastTrackedDate DATE
);

CREATE TABLE IF NOT EXISTS PRODUCTREFERENCE (
    reference_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description TEXT
);

CREATE TABLE IF NOT EXISTS PRODUCT (
    product_id SERIAL PRIMARY KEY,
    reference_id INT REFERENCES PRODUCTREFERENCE(reference_id),
    pricePerUnit FLOAT
);

CREATE TABLE IF NOT EXISTS LINE_ITEM (
    lineItem_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES SHIPMENT(shipment_id),
    product_id INT REFERENCES PRODUCT(product_id),
    quantityOrder INT
);

ALTER TABLE CUSTOMERADDRESS
ADD CONSTRAINT fk_customeraddress_customer
FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id);

ALTER TABLE EGRESSORDER
ADD CONSTRAINT fk_egressorder_customer
FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id);

ALTER TABLE EGRESSORDER
ADD CONSTRAINT fk_egressorder_address
FOREIGN KEY (address_id) REFERENCES CUSTOMERADDRESS(address_id);

ALTER TABLE SHIPMENT
ADD CONSTRAINT fk_shipment_order
FOREIGN KEY (order_id) REFERENCES EGRESSORDER(order_id);

ALTER TABLE TRAVELHISTORY
ADD CONSTRAINT fk_travelhistory_order
FOREIGN KEY (shipment_id) REFERENCES SHIPMENT(shipment_id);

ALTER TABLE LINE_ITEM
ADD CONSTRAINT fk_lineitem_product
FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id);

ALTER TABLE LINE_ITEM
ADD CONSTRAINT fk_lineitem_shipment
FOREIGN KEY (shipment_id) REFERENCES SHIPMENT(shipment_id);

ALTER TABLE PRODUCT
ADD CONSTRAINT fk_product_reference
FOREIGN KEY (reference_id) REFERENCES PRODUCTREFERENCE(reference_id);

ALTER TABLE EGRESSORDER
ADD CONSTRAINT fk_egressorder_customeraddress
FOREIGN KEY (address_id) REFERENCES CUSTOMERADDRESS(address_id);


INSERT INTO CUSTOMER (email, pwdHash, firstname, lastname, phone)
VALUES
    ('michael.scott@dundermifflin.com', 'hashed_password_1', 'Michael', 'Scott', '402-555-1234'),
    ('jim.halpert@dundermifflin.com', 'hashed_password_2', 'Jim', 'Halpert', '402-555-5678'),
    ('pam.beesly@dundermifflin.com', 'hashed_password_3', 'Pam', 'Beesly', '402-555-8765'),
    ('dwight.schrute@dundermifflin.com', 'hashed_password_4', 'Dwight', 'Schrute', '402-555-4321');

INSERT INTO CUSTOMERADDRESS (customer_id, firstLine, secondLine, complementLine, city, zipcode, preferred, disabled)
VALUES
    (1, '1725 Slough Avenue', 'Suite 200', 'Floor 2', 'Scranton', '18501', TRUE, FALSE),
    (2, '1725 Slough Avenue', 'Suite 201', 'Floor 2', 'Scranton', '18501', TRUE, FALSE),
    (3, '1725 Slough Avenue', 'Suite 202', 'Floor 2', 'Scranton', '18501', TRUE, FALSE),
    (4, '1725 Slough Avenue', 'Suite 203', 'Floor 2', 'Scranton', '18501', TRUE, FALSE);

INSERT INTO EGRESSORDER (customer_id, address_id, orderPublicId, orderPlaced, total, currency)
VALUES
    (1, 1, 'DM1001', '2023-11-19', 52.50, 'USD'),
    (2, 2, 'DM1002', '2023-11-20', 21.00, 'USD'),
    (3, 3, 'DM1003', '2023-11-21', 105.00, 'USD'),
    (4, 4, 'DM1004', '2023-11-22', 460.00, 'USD');

INSERT INTO SHIPMENT (order_id)
VALUES
    (1),
    (2),
    (3),
    (4),
    (4);

INSERT INTO TRAVELHISTORY (shipment_id, milestone, extendedDescription, city, lastTrackedDate)
VALUES
    (1, 'Shipped', 'Order has been shipped', 'Scranton', '2023-11-20'),
    (2, 'In Transit', 'Order is in transit', 'Scranton', '2023-11-21'),
    (3, 'Delivered', 'Order has been delivered', 'Scranton', '2023-11-22'),
    (4, 'Delivered', 'Order has been delivered', 'Scranton', '2023-11-22'),
    (5, 'Out for Delivery', 'Order is out for delivery', 'Scranton', '2023-11-23');

INSERT INTO PRODUCTREFERENCE (name, description)
VALUES
    ('Dunder Mifflin Paper', 'High-quality paper for all your office needs'),
    ('Dundie Trophy', 'Award for outstanding achievement at the Dundie Awards');

INSERT INTO PRODUCT (reference_id, pricePerUnit)
VALUES
    (1, 10.50),
    (2, 25.00);

INSERT INTO LINE_ITEM (shipment_id, product_id, quantityOrder)
VALUES
    (1, 1, 5),
    (2, 1, 2),
    (3, 1, 10),
    (4, 2, 10),
    (4, 1, 20);
