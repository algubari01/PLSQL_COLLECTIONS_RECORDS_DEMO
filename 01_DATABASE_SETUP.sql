-- Create database tables for Product Inventory Management
CREATE TABLE categories (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL,
    description VARCHAR2(200)
);

CREATE TABLE suppliers (
    supplier_id NUMBER PRIMARY KEY,
    supplier_name VARCHAR2(100) NOT NULL,
    contact_email VARCHAR2(100),
    phone_number VARCHAR2(20)
);

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(200),
    price NUMBER(10,2),
    stock_quantity NUMBER,
    category_id NUMBER,
    supplier_id NUMBER,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Insert sample data
INSERT INTO categories VALUES (1, 'Electronics', 'Electronic devices and accessories');
INSERT INTO categories VALUES (2, 'Clothing', 'Apparel and fashion items');
INSERT INTO categories VALUES (3, 'Books', 'Educational and recreational books');

INSERT INTO suppliers VALUES (101, 'TechCorp Inc', 'contact@techcorp.com', '+250-788-123456');
INSERT INTO suppliers VALUES (102, 'FashionWorld Ltd', 'info@fashionworld.com', '+250-788-654321');
INSERT INTO suppliers VALUES (103, 'BookHouse Publishers', 'sales@bookhouse.com', '+250-788-987654');

INSERT INTO products VALUES (1001, 'Laptop', 'High-performance laptop', 1200.00, 50, 1, 101);
INSERT INTO products VALUES (1002, 'Smartphone', 'Latest smartphone model', 800.00, 100, 1, 101);
INSERT INTO products VALUES (1003, 'T-Shirt', 'Cotton t-shirt', 25.00, 200, 2, 102);
INSERT INTO products VALUES (1004, 'Programming Book', 'Learn PL/SQL programming', 45.00, 75, 3, 103);
INSERT INTO products VALUES (1005, 'Headphones', 'Wireless headphones', 150.00, 30, 1, 101);

COMMIT;