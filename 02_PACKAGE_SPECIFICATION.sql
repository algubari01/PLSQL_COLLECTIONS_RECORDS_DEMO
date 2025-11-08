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