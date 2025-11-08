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
   ```

2. **Create Package Specification**
   ```sql
   @02_PACKAGE_SPECIFICATION.sql
   ```

3. **Create Package Body**
   ```sql
   @03_PACKAGE_BODY.sql
   ```

4. **Run Main Demonstration**
   ```sql
   @04_MAIN_DEMONSTRATION.sql
   ```

5. **Execute Test Cases (Optional)**
   ```sql
   @05_TEST_CASES.sql
   ```

6. **Final Verification**
   ```sql
   @06_VERIFICATION.sql
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
