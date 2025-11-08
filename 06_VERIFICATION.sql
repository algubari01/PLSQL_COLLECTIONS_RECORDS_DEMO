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