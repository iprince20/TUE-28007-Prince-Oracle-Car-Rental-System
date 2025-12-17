# Oracle Car Rental Management System

**Student Name:** Prince  
**Student ID:** 28007  
**Class Day:** Tuesday  
**Database:** Oracle Database 21c  
**Development Tool:** Visual Studio Code (Oracle SQL Developer Extension)  
**Monitoring Tool:** Oracle Enterprise Manager (OEM Express)

---

## 📌 Project Overview

The **Oracle Car Rental Management System** is a database-driven project designed to manage vehicle rentals efficiently using **Oracle SQL and PL/SQL**.  
The system handles vehicles, customers, rentals, payments, maintenance records, and auditing of database operations.

This project demonstrates **professional Oracle database design**, business logic implementation, auditing, and reporting.

---

## 🎯 Project Objectives

- Design a normalized relational database for a car rental business
- Enforce data integrity using constraints
- Implement business logic using PL/SQL procedures and functions
- Group logic using Oracle packages
- Restrict and audit data manipulation using triggers
- Produce analytical and reporting SQL queries

---

## 🛠 Technologies Used

- **Oracle Database 21c Enterprise Edition**
- **SQL & PL/SQL**
- **Visual Studio Code** with Oracle SQL Developer Extension
- **Oracle Enterprise Manager (EM Express)** for monitoring
- **Git & GitHub** for version control

---

## 🗂 Database Schema

The system is composed of the following tables:

| Table Name  | Description                             |
| ----------- | --------------------------------------- |
| Vehicles    | Stores vehicle details and availability |
| Customers   | Stores customer information             |
| Rentals     | Records vehicle rental transactions     |
| Payments    | Stores payment records                  |
| Maintenance | Tracks vehicle maintenance              |
| Audit_Log   | Logs and audits DML operations          |

All relationships are enforced using **primary keys and foreign keys**.

---

## ⚙️ PL/SQL Features

### ✔ Procedures

- `add_vehicle` – Adds a new vehicle
- `return_vehicle` – Handles vehicle return logic
- `get_active_rentals` – Displays active rentals using cursors

### ✔ Functions

- `calculate_revenue` – Calculates revenue for a given period
- `is_vehicle_available` – Checks vehicle availability (numeric return)

### ✔ Package

- `car_rental_pkg` – Groups procedures and functions for modular design

---

## 🔐 Triggers & Auditing

- A trigger restricts **DML operations on weekdays**
- All INSERT, UPDATE, and DELETE attempts on the `Rentals` table are logged
- Audit information is stored in the `Audit_Log` table
- This ensures **accountability and rule enforcement at database level**

---

## 📊 Reporting & Analytics

The project includes advanced SQL reports such as:

- Total and average payments
- Monthly revenue summaries
- Cumulative revenue using window functions
- Vehicle availability queries

---

## 🖥 Monitoring with OEM

**Oracle Enterprise Manager (EM Express)** was used to:

- Monitor database health
- Verify schema objects
- Execute administrative SQL queries

---

## 📁 Project Structure

oracle-car-rental-system/
│
├── sql/
│ ├── 01_tables.sql
│ ├── 02_inserts.sql
│ ├── 03_procedures.sql
│ ├── 04_functions.sql
│ ├── 05_packages.sql
│ ├── 06_triggers.sql
│ └── 07_reporting.sql
│
├── screenshots/
│
├── Oracle_Car_Rental_System_Documentation.pdf
├── README.md
└── .gitignore

## ✅ Conclusion

This project demonstrates a complete and professional Oracle database system using SQL and PL/SQL.  
It reflects strong understanding of database design, security, auditing, and analytics, making it suitable for **academic evaluation and portfolio presentation**.

---

**© 2025 – Prince**
