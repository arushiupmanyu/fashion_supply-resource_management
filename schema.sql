-- Create the fashion_supply_resource_management database
CREATE DATABASE IF NOT EXISTS fashion_supply_resource_management;
USE fashion_supply_resource_management;

-- Create the suppliers table first
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    contact_info VARCHAR(255),
    name VARCHAR(255)
);

-- Create the designers table
CREATE TABLE designers (
    design_id INT,
    designer_id INT PRIMARY KEY,
    contact_info VARCHAR(255),
    name VARCHAR(255)
);

-- Create the manufacturers table
CREATE TABLE manufacturers (
    design_id INT,
    manufacturer_id INT PRIMARY KEY,
    contact_info VARCHAR(255),
    name VARCHAR(255)
);

-- Create the materials table
CREATE TABLE materials (
    material_id INT PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Create the designs table
CREATE TABLE designs (
    design_id INT PRIMARY KEY,
    name VARCHAR(255),
    design_desc TEXT,
    material_list_id INT,
    designer_id INT,  -- Corrected foreign key reference
    manufacturer_id INT,
    FOREIGN KEY (designer_id) REFERENCES designers(designer_id),  -- Corrected foreign key reference
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

-- Create the logistics table
CREATE TABLE logistics (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    contact_info VARCHAR(255)
);

-- Create relationships and relational attributes
-- Relation: give_design_to
CREATE TABLE give_design_to (
    logistics_id INT,
    manufacturer_id INT,
    tracking_id INT,
    payment_id INT,
    material_list_id INT,
    design_id INT,
    FOREIGN KEY (logistics_id) REFERENCES logistics(id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id),
    FOREIGN KEY (design_id) REFERENCES designs(design_id)
);

-- Relation: collect_scrapes_from
CREATE TABLE collect_scrapes_from (
    logistics_id INT,
    manufacturer_id INT,
    refurbishing_id INT,
    new_product_id INT,
    product_price DECIMAL(10, 2),
    product_desc TEXT,
    FOREIGN KEY (logistics_id) REFERENCES logistics(id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

-- Relation: take_supplies_from
CREATE TABLE take_supplies_from (
    logistics_id INT,
    supplier_id INT,
    FOREIGN KEY (logistics_id) REFERENCES logistics(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Relation: transport_supplies_to
CREATE TABLE transport_supplies_to (
    logistics_id INT,
    designer_id INT,
    tracking_id INT,
    material_id INT,
    payment_id INT,
    FOREIGN KEY (logistics_id) REFERENCES logistics(id),
    FOREIGN KEY (designer_id) REFERENCES designers(designer_id),
    FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

-- Relation: give_supply_list_to
CREATE TABLE give_supply_list_to (
    logistics_id INT,
    designer_id INT,
    tracking_id INT,
    material_id INT,
    payment_id INT,
    FOREIGN KEY (logistics_id) REFERENCES logistics(id),
    FOREIGN KEY (designer_id) REFERENCES designers(designer_id),
    FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

-- Insert into suppliers table
INSERT INTO suppliers (supplier_id, contact_info, name)
VALUES
    (1, 'supplierABC@gmail.com', 'Silk Suppliers Ltd.'),
    (2, 'supplierXYZ@gmail.com', 'LeatherCraft Suppliers'),
    (3, 'supplier123@gmail.com', 'Cotton Comfort Mills');

-- Insert into designers table
INSERT INTO designers (design_id, designer_id, contact_info, name)
VALUES
    (1, 101, 'john.designer@gmail.com', 'John Anderson Designs'),
    (2, 102, 'jane.designer@gmail.com', 'Jane Smith Creations'),
    (3, 103, 'bob.designer@gmail.com', 'Bob Taylor Couture');

-- Insert into manufacturers table
INSERT INTO manufacturers (design_id, manufacturer_id, contact_info, name)
VALUES
    (1, 201, 'manufacturerA@gmail.com', 'A1 Fashion Manufacturing'),
    (2, 202, 'manufacturerB@gmail.com', 'Bespoke Styles Co.'),
    (3, 203, 'manufacturerC@gmail.com', 'Chic Apparel Makers');

-- Insert into materials table
INSERT INTO materials (material_id, name, type, supplier_id)
VALUES
    (1, 'Silk Fabric', 'Fabric', 1),
    (2, 'Leather Material', 'Material', 2),
    (3, 'Cotton Blend', 'Fabric', 3);

-- Insert into designs table
INSERT INTO designs (design_id, name, design_desc, material_list_id, designer_id, manufacturer_id)
VALUES
    (1, 'Elegant Evening Gown', 'Elegant design for evening events', 1, 101, 201),
    (2, 'Casual Denim Jeans', 'Comfortable and stylish jeans', 2, 102, 202),
    (3, 'Summer Floral Dress', 'Light and flowy dress for summer', 3, 103, 203);

-- Insert into logistics table
INSERT INTO logistics (id, name, contact_info)
VALUES
    (1, 'Express Logistics', 'express.logistics@gmail.com'),
    (2, 'Swift Delivery Services', 'swift.delivery@gmail.com'),
    (3, 'Rapid Logistics Solutions', 'rapid.logistics@gmail.com');

-- Insert into give_design_to table
INSERT INTO give_design_to (logistics_id, manufacturer_id, tracking_id, payment_id, material_list_id, design_id)
VALUES
    (1, 201, 1001, 2001, 1, 1),
    (2, 202, 1002, 2002, 2, 2),
    (3, 203, 1003, 2003, 3, 3);

-- Insert into collect_scrapes_from table
INSERT INTO collect_scrapes_from (logistics_id, manufacturer_id, refurbishing_id, new_product_id, product_price, product_desc)
VALUES
    (1, 201, 3001, 4001, 50.00, 'Elegant Scrapes Collection'),
    (2, 202, 3002, 4002, 60.00, 'Casual Scrapes Collection'),
    (3, 203, 3003, 4003, 70.00, 'Summer Scrapes Collection');

-- Insert into take_supplies_from table
INSERT INTO take_supplies_from (logistics_id, supplier_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

-- Insert into transport_supplies_to table
INSERT INTO transport_supplies_to (logistics_id, designer_id, tracking_id, material_id, payment_id)
VALUES
    (1, 101, 5001, 1, 6001),
    (2, 102, 5002, 2, 6002),
    (3, 103, 5003, 3, 6003);

-- Insert into give_supply_list_to table
INSERT INTO give_supply_list_to (logistics_id, designer_id, tracking_id, material_id, payment_id)
VALUES
    (1, 101, 7001, 1, 8001),
    (2, 102, 7002, 2, 8002),
    (3, 103, 7003, 3, 8003);

