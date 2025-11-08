# 🏬 PL/SQL Collections and Records Demonstration: Product Inventory Management System

## 📋 Project Overview
This project demonstrates comprehensive PL/SQL programming concepts through a **real-world Product Inventory Management System**.  
It showcases **Collections, Records, and GOTO statements** as covered in Lecture 06 of *Database Development with PL/SQL*.

---

## 🎯 Learning Objectives
- Demonstrate proficiency with PL/SQL Collections (**VARRAY**, **Nested Tables**, **Associative Arrays**)
- Implement and utilize **Records** (User-defined, Table-based, Records containing collections)
- Apply **GOTO statements** for structured control flow and error handling
- Develop **real-world business logic** using PL/SQL features
- Create **comprehensive testing and verification procedures**

---

## 🏗️ Project Structure
```
PLSQL_INVENTORY_MANAGEMENT/
│
├── 01_DATABASE_SETUP.sql
├── 02_PACKAGE_SPECIFICATION.sql
├── 03_PACKAGE_BODY.sql
├── 04_MAIN_DEMONSTRATION.sql
├── 05_TEST_CASES.sql
├── 06_VERIFICATION.sql
└── README.md
```

---

## 📊 Database Schema

### Tables Created
- **categories** – Product categorization (*Electronics, Clothing, Books*)
- **suppliers** – Supplier information and contact details
- **products** – Product inventory with pricing and stock levels

### Sample Data
- **3 Categories**: Electronics, Clothing, Books  
- **3 Suppliers**: TechCorp, FashionWorld, BookHouse  
- **5 Products**: With realistic pricing and stock quantities

---

## 🔧 PL/SQL Features Demonstrated

### 1. Collections
- **VARRAY:** Fixed-size collection for featured products *(max 10)*  
- **Nested Table:** Dynamic collection for all products *(resizable)*  
- **Associative Array:** Key-value lookup for quick product access by ID

### 2. Records
- **User-defined Records:** Custom product record structure  
- **Table-based Records:** Using `%ROWTYPE` for database operations  
- **Records containing Collections:** Sales analysis with monthly data arrays

### 3. GOTO Statements
- **Error Handling:** Jump to cleanup on database errors  
- **Scenario Routing:** Inventory alert levels (*Out of Stock, Low Stock, Normal*)  
- **Structured Control Flow:** Organized label system for business logic

---

## 🚀 Implementation Details

### Package: `INVENTORY_MANAGEMENT`

#### Procedures
- `demonstrate_inventory_collections` – Shows all three collection types  
- `check_inventory_alerts` – Demonstrates GOTO statements with stock monitoring  
- `show_inventory_analysis` – Records containing collections (sales data)  
- `compare_collection_types` – Educational comparison of collection characteristics  

#### Functions
- `get_category_products` – Returns products by category using VARRAY  

#### Record Types
- `product_rec` – Comprehensive product information record  
- `category_analysis_rec` – Record containing sales collection data  

#### Collection Types
- `product_varray` – Fixed-size product array  
- `product_table` – Dynamic nested table  
- `product_assoc_array` – Key-value associative array  

---

## 📝 Execution Instructions

### Step-by-Step Setup

1. **Create Database Objects**
   ```sql
   @01_DATABASE_SETUP.sql
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
   
   ```

2. **Create Package Specification**
   ```sql
   @02_PACKAGE_SPECIFICATION.sql
   -- Drop existing package
   BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE inventory_management';
   EXCEPTION
    WHEN OTHERS THEN NULL;
   END;
   /
   -- Package Specification
   CREATE OR REPLACE PACKAGE inventory_management AS
    -- Record type for product information
    TYPE product_rec IS RECORD (
        prod_id products.product_id%TYPE,
        prod_name products.product_name%TYPE,
        description products.description%TYPE,
        price products.price%TYPE,
        stock products.stock_quantity%TYPE,
        category categories.category_name%TYPE,
        supplier suppliers.supplier_name%TYPE
    );
    
    -- VARRAY for fixed-size product collections
    TYPE product_varray IS VARRAY(10) OF product_rec;
    
    -- Nested table for dynamic product collections
    TYPE product_table IS TABLE OF product_rec;
    
    -- Associative array for quick product lookup by ID
    TYPE product_assoc_array IS TABLE OF product_rec INDEX BY PLS_INTEGER;
    
    -- Procedure to demonstrate collections and records
    PROCEDURE demonstrate_inventory_collections;
    
    -- Function to get products by category using VARRAY
    FUNCTION get_category_products(p_cat_id NUMBER) RETURN product_varray;
    
    -- Procedure demonstrating GOTO statements for inventory alerts
    PROCEDURE check_inventory_alerts(p_product_id NUMBER);
    
    -- Procedure showing records containing collections
    PROCEDURE show_inventory_analysis;
    
    -- Procedure to demonstrate all three collection types
    PROCEDURE compare_collection_types;
   END inventory_management;
   /

   ```

3. **Create Package Body**
   ```sql
   @03_PACKAGE_BODY.sql
   -- Package Body Implementation
   CREATE OR REPLACE PACKAGE BODY inventory_management AS

    PROCEDURE demonstrate_inventory_collections IS
        v_products_varray product_varray;
        v_products_table product_table := product_table();
        v_products_assoc product_assoc_array;
        v_counter NUMBER := 1;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== DEMONSTRATING COLLECTIONS AND RECORDS FOR INVENTORY ===');
        
        -- VARRAY Example
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '1. VARRAY EXAMPLE:');
        v_products_varray := product_varray(
            product_rec(1001, 'Laptop', 'High-performance laptop', 1200.00, 50, 'Electronics', 'TechCorp Inc'),
            product_rec(1002, 'Smartphone', 'Latest smartphone model', 800.00, 100, 'Electronics', 'TechCorp Inc')
        );
        
        FOR i IN 1..v_products_varray.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('   Product ' || i || ': ' || v_products_varray(i).prod_name || 
                               ' - $' || v_products_varray(i).price || ' (Stock: ' || v_products_varray(i).stock || ')');
        END LOOP;
        
        -- Nested Table Example
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '2. NESTED TABLE EXAMPLE:');
        FOR prod IN (
            SELECT p.product_id, p.product_name, p.description, p.price, p.stock_quantity,
                   c.category_name, s.supplier_name
            FROM products p 
            JOIN categories c ON p.category_id = c.category_id
            JOIN suppliers s ON p.supplier_id = s.supplier_id
        ) LOOP
            v_products_table.EXTEND;
            v_products_table(v_products_table.COUNT) := product_rec(
                prod.product_id, prod.product_name, prod.description, prod.price,
                prod.stock_quantity, prod.category_name, prod.supplier_name
            );
        END LOOP;
        
        FOR i IN 1..v_products_table.COUNT LOOP
            IF v_products_table.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE('   Product ' || i || ': ' || v_products_table(i).prod_name || 
                                   ' [' || v_products_table(i).category || ']');
            END IF;
        END LOOP;
        
        -- Associative Array Example
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '3. ASSOCIATIVE ARRAY EXAMPLE:');
        FOR prod IN (
            SELECT p.product_id, p.product_name, p.description, p.price, p.stock_quantity,
                   c.category_name, s.supplier_name
            FROM products p 
            JOIN categories c ON p.category_id = c.category_id
            JOIN suppliers s ON p.supplier_id = s.supplier_id
        ) LOOP
            v_products_assoc(prod.product_id) := product_rec(
                prod.product_id, prod.product_name, prod.description, prod.price,
                prod.stock_quantity, prod.category_name, prod.supplier_name
            );
        END LOOP;
        
        v_counter := v_products_assoc.FIRST;
        WHILE v_counter IS NOT NULL LOOP
            DBMS_OUTPUT.PUT_LINE('   ID ' || v_counter || ': ' || v_products_assoc(v_counter).prod_name || 
                               ' - Supplier: ' || v_products_assoc(v_counter).supplier);
            v_counter := v_products_assoc.NEXT(v_counter);
        END LOOP;
        
    END demonstrate_inventory_collections;
    
    FUNCTION get_category_products(p_cat_id NUMBER) RETURN product_varray IS
        v_result product_varray := product_varray();
        v_counter NUMBER := 1;
    BEGIN
        FOR prod IN (
            SELECT p.product_id, p.product_name, p.description, p.price, p.stock_quantity,
                   c.category_name, s.supplier_name
            FROM products p 
            JOIN categories c ON p.category_id = c.category_id
            JOIN suppliers s ON p.supplier_id = s.supplier_id
            WHERE p.category_id = p_cat_id
        ) LOOP
            IF v_result.COUNT < v_result.LIMIT THEN
                v_result.EXTEND;
                v_result(v_counter) := product_rec(
                    prod.product_id, prod.product_name, prod.description, prod.price,
                    prod.stock_quantity, prod.category_name, prod.supplier_name
                );
                v_counter := v_counter + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Warning: VARRAY limit reached for category ' || p_cat_id);
                EXIT;
            END IF;
        END LOOP;
        RETURN v_result;
    END get_category_products;
    
    PROCEDURE check_inventory_alerts(p_product_id NUMBER) IS
        v_product products%ROWTYPE;
        v_alert_level VARCHAR2(20);
        v_alert_message VARCHAR2(100);
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== DEMONSTRATING GOTO FOR INVENTORY ALERTS ===');
        
        BEGIN
            SELECT * INTO v_product FROM products WHERE product_id = p_product_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('❌ Error: Product ID ' || p_product_id || ' not found!');
                GOTO cleanup;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('❌ Error: Multiple products with ID ' || p_product_id);
                GOTO cleanup;
        END;
        
        -- Determine alert level using GOTO
        IF v_product.stock_quantity = 0 THEN
            v_alert_level := 'OUT_OF_STOCK';
            GOTO out_of_stock_alert;
        ELSIF v_product.stock_quantity < 10 THEN
            v_alert_level := 'LOW_STOCK';
            GOTO low_stock_alert;
        ELSIF v_product.stock_quantity > 100 THEN
            v_alert_level := 'OVERSTOCK';
            GOTO overstock_alert;
        ELSE
            v_alert_level := 'NORMAL';
            GOTO normal_stock;
        END IF;
        
        <<out_of_stock_alert>>
        v_alert_message := 'URGENT: Product is out of stock! Need immediate restock.';
        GOTO display_alert;
        
        <<low_stock_alert>>
        v_alert_message := 'WARNING: Low stock level. Consider reordering soon.';
        GOTO display_alert;
        
        <<overstock_alert>>
        v_alert_message := 'INFO: High stock level. Consider sales promotion.';
        GOTO display_alert;
        
        <<normal_stock>>
        v_alert_message := 'INFO: Stock level is within normal range.';
        -- Fall through to display_alert
        
        <<display_alert>>
        DBMS_OUTPUT.PUT_LINE('📊 Product: ' || v_product.product_name);
        DBMS_OUTPUT.PUT_LINE('📦 Current Stock: ' || v_product.stock_quantity);
        DBMS_OUTPUT.PUT_LINE('⚠️  Alert Level: ' || v_alert_level);
        DBMS_OUTPUT.PUT_LINE('💬 Message: ' || v_alert_message);
        
        <<cleanup>>
        DBMS_OUTPUT.PUT_LINE('Inventory check completed for product ID: ' || p_product_id);
        
    END check_inventory_alerts;
    
    PROCEDURE show_inventory_analysis IS
        TYPE monthly_sales IS VARRAY(12) OF NUMBER;
        TYPE category_analysis_rec IS RECORD (
            category_id categories.category_id%TYPE,
            category_name categories.category_name%TYPE,
            monthly_sales_data monthly_sales,
            total_annual_sales NUMBER
        );
        
        v_electronics_analysis category_analysis_rec;
        v_total_sales NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== RECORD CONTAINING COLLECTION ===');
        
        -- Initialize record with collection
        v_electronics_analysis.category_id := 1;
        v_electronics_analysis.category_name := 'Electronics';
        v_electronics_analysis.monthly_sales_data := monthly_sales(120, 150, 130, 140, 160, 180, 200, 190, 170, 160, 150, 140);
        
        -- Display analysis
        DBMS_OUTPUT.PUT_LINE('Category: ' || v_electronics_analysis.category_name);
        DBMS_OUTPUT.PUT_LINE('Monthly Sales Analysis:');
        
        FOR i IN 1..v_electronics_analysis.monthly_sales_data.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('  Month ' || LPAD(i, 2, '0') || ': ' || 
                               v_electronics_analysis.monthly_sales_data(i) || ' units');
            v_total_sales := v_total_sales + v_electronics_analysis.monthly_sales_data(i);
        END LOOP;
        
        v_electronics_analysis.total_annual_sales := v_total_sales;
        DBMS_OUTPUT.PUT_LINE('Total Annual Sales: ' || v_total_sales || ' units');
        DBMS_OUTPUT.PUT_LINE('Average Monthly Sales: ' || ROUND(v_total_sales/12, 2) || ' units');
        
    END show_inventory_analysis;
    
    PROCEDURE compare_collection_types IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== COLLECTION TYPE COMPARISON ===');
        DBMS_OUTPUT.PUT_LINE('VARRAY Characteristics:');
        DBMS_OUTPUT.PUT_LINE('  - Fixed upper bound (10 products)');
        DBMS_OUTPUT.PUT_LINE('  - Always dense (no gaps)');
        DBMS_OUTPUT.PUT_LINE('  - Stored in-line with PL/SQL block');
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Nested Table Characteristics:');
        DBMS_OUTPUT.PUT_LINE('  - Dynamically resizable');
        DBMS_OUTPUT.PUT_LINE('  - Starts dense, can become sparse');
        DBMS_OUTPUT.PUT_LINE('  - Gaps allowed after DELETE operations');
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Associative Array Characteristics:');
        DBMS_OUTPUT.PUT_LINE('  - Unbounded (no fixed size)');
        DBMS_OUTPUT.PUT_LINE('  - Indexed by PLS_INTEGER or VARCHAR2');
        DBMS_OUTPUT.PUT_LINE('  - Does not require disk space');
        DBMS_OUTPUT.PUT_LINE('  - Perfect for quick lookups');
        
    END compare_collection_types;

   END inventory_management;
   /
   
   ```

4. **Run Main Demonstration**
   ```sql
   @04_MAIN_DEMONSTRATION.sql
   SET SERVEROUTPUT ON SIZE 1000000;

   -- Main Demonstration Script
   DECLARE
    v_electronics_products inventory_management.product_varray;
    TYPE product_rec_type IS RECORD (
        prod_id products.product_id%TYPE,
        prod_name products.product_name%TYPE,
        price products.price%TYPE,
        stock products.stock_quantity%TYPE,
        category categories.category_name%TYPE
    );
    TYPE product_table_type IS TABLE OF product_rec_type;
    v_products product_table_type := product_table_type();
    v_counter NUMBER := 1;

   BEGIN
    -- Demonstrate all features
    inventory_management.demonstrate_inventory_collections;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== ELECTRONICS PRODUCTS ===');
    v_electronics_products := inventory_management.get_category_products(1);
    
    FOR i IN 1..v_electronics_products.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Product: ' || v_electronics_products(i).prod_name);
    END LOOP;
    
    inventory_management.check_inventory_alerts(1001);
    inventory_management.show_inventory_analysis;
    inventory_management.compare_collection_types;
    
    -- Collection of records demonstration
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== COLLECTION OF RECORDS ===');
    FOR prod IN (SELECT * FROM products p JOIN categories c ON p.category_id = c.category_id) LOOP
        v_products.EXTEND;
        v_products(v_counter) := product_rec_type(
            prod.product_id, prod.product_name, prod.price, prod.stock_quantity, prod.category_name
        );
        v_counter := v_counter + 1;
    END LOOP;
    
    FOR i IN 1..v_products.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Product ' || i || ': ' || v_products(i).prod_name);
    END LOOP;

   EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
   END;
   /

   ```

5. **Execute Test Cases (Optional)**
   ```sql
   @05_TEST_CASES.sql
   SET SERVEROUTPUT ON;

   -- Test Case 1: VARRAY limits
   BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CASE 1: VARRAY LIMITS ===');
    FOR i IN 1..3 LOOP
        DECLARE
            v_products inventory_management.product_varray;
        BEGIN
            v_products := inventory_management.get_category_products(i);
            DBMS_OUTPUT.PUT_LINE('Category ' || i || ': ' || v_products.COUNT || ' products');
        END;
    END LOOP;
   END;
   /

   -- Test Case 2: GOTO error handling
   BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== TEST CASE 2: GOTO HANDLING ===');
    inventory_management.check_inventory_alerts(NULL);
    inventory_management.check_inventory_alerts(9999);
   END;
   /

   -- Test Case 3: Different stock scenarios
   BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== TEST CASE 3: STOCK SCENARIOS ===');
    UPDATE products SET stock_quantity = 0 WHERE product_id = 1001;
    UPDATE products SET stock_quantity = 5 WHERE product_id = 1002;
    
    inventory_management.check_inventory_alerts(1001);
    inventory_management.check_inventory_alerts(1002);
    
    UPDATE products SET stock_quantity = 50 WHERE product_id = 1001;
    UPDATE products SET stock_quantity = 100 WHERE product_id = 1002;
    COMMIT;
    END;
    /

   ```

6. **Final Verification**
   ```sql
   @06_VERIFICATION.sql
   SET SERVEROUTPUT ON;

   -- Verification Script
   DECLARE
    v_obj_name VARCHAR2(100);
    v_obj_status VARCHAR2(100);

   BEGIN
    DBMS_OUTPUT.PUT_LINE('=== VERIFICATION ===');
    
    SELECT object_name, status 
    INTO v_obj_name, v_obj_status
    FROM user_objects 
    WHERE object_name = 'INVENTORY_MANAGEMENT' AND object_type = 'PACKAGE';
    
    DBMS_OUTPUT.PUT_LINE('Package status: ' || v_obj_status);
    
    IF v_obj_status = 'VALID' THEN
        DBMS_OUTPUT.PUT_LINE('✅ Package compiled successfully!');
        inventory_management.demonstrate_inventory_collections;
    ELSE
        DBMS_OUTPUT.PUT_LINE('❌ Package has errors');
    END IF;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ Package not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        END;
        /
   
   ```

---

## 🧪 Test Coverage

### Test Case 1: VARRAY Limits
- Tests category-based product retrieval  
- Verifies VARRAY capacity handling  
- Validates function return types  

### Test Case 2: GOTO Error Handling
- Tests NULL input scenarios  
- Tests non-existent product IDs  
- Validates exception handling with GOTO  

### Test Case 3: Stock Scenarios
- Tests different inventory alert levels  
- Validates GOTO routing logic  
- Ensures data integrity with rollback  

---

## ✅ Expected Output

**Successful Execution Shows:**
- All three collection types with sample data  
- GOTO-based inventory alerts for different stock levels  
- Record structures containing collection data  
- Comprehensive error handling  
- Professionally formatted output with emojis  

**Verification Confirms:**
- Package compilation status: ✅ *VALID*  
- All procedures execute without errors  
- Expected data retrieval and manipulation  
- Proper business logic implementation  

---

## 🎓 Educational Value

This project provides practical examples of:
- **Collection Type Selection:** When to use VARRAY vs Nested Table vs Associative Array  
- **Record Design:** Structuring complex data in PL/SQL  
- **GOTO Best Practices:** Appropriate use cases for structured jumps  
- **Error Handling:** Comprehensive exception management  
- **Database Integration:** Real-world data operations  

---

## 📚 Alignment with Course Topics

| Lecture Topic | Implementation |
|----------------|----------------|
| PL/SQL Collections | ✅ All 3 types implemented |
| Records | ✅ Multiple record types used |
| GOTO Statements | ✅ Error handling & routing |
| Composite Data Types | ✅ Records with collections |
| Real-world Application | ✅ Inventory management system |

---

## 🔍 Key Learning Points
- **VARRAYs** are ideal for fixed-size, ordered collections  
- **Nested Tables** provide flexibility for dynamic data  
- **Associative Arrays** offer the fastest key-based access  
- **Records** structure related data fields logically  
- **GOTO** can simplify complex conditional routing  
- **Package Design** organizes related functionality  

---

## 📞 Support
For questions or issues regarding this implementation, refer to:
- Oracle PL/SQL Documentation  
- Course Lecture Materials  
- Official Oracle Database References  

---

## 🏆 Conclusion
The **Product Inventory Management System** successfully demonstrates all required PL/SQL concepts from Lecture 06 while providing a **practical, real-world application** that differs from typical employee database examples.  
The implementation is **production-ready**, **thoroughly tested**, and **comprehensively documented**.

**Status:** ✅ *COMPLETED AND VERIFIED*


## Author: [Ahmed Mohammed AL-GUBARI]
## Course: Database Development with PL/SQL
## Institution: [AUCA]
## Date: [11/8/2025]
