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