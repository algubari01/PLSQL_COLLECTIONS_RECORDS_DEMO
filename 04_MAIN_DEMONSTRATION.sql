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