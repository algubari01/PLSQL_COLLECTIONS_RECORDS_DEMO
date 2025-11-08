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