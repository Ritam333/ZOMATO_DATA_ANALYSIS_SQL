

# 🍕 ZOMATO DATA ANALYSIS SQL  
**SQL Project: Data Analysis for Zomato - A Leading Food Delivery Company in India**  

---

## 📜 **Overview**  

This project showcases my **SQL problem-solving skills** through an in-depth analysis of **Zomato's data**. By leveraging SQL's powerful capabilities, I solved real-world business problems, analyzed critical metrics, and demonstrated how SQL can be used to extract meaningful insights from raw data.  

---

## 🗂️ **Project Structure**  

### 1️⃣ **Database Setup**  
-  Created the `zomato_db` database.  
-  Designed and structured the necessary tables to reflect Zomato's operations.  

### 2️⃣ **Data Import**  
-  Inserted comprehensive sample data into the tables for realistic analysis.  

### 3️⃣ **Data Cleaning**  
-  Addressed **null values** and ensured the data's **integrity and reliability** for accurate analysis.  

### 4️⃣ **Business Problems Solved**  
-  Solved **17 real-world business challenges** using advanced SQL queries.  

---

## 📊 **Key Topics and Skills Covered**  

### 1. 📂 **Database Creation and Table Design**  
   - Structuring data to match Zomato's business operations.  

### 2. 📈 **Aggregate and Grouping Functions**  
   - Calculating key metrics like **average order value**, **most popular cuisines**, etc.  

### 3. 🔗 **Joins**  
   - Merging datasets to uncover relationships, such as customer preferences and restaurant performance.  

### 4. 📊 **Window Functions**  
   - Ranking restaurants, calculating running totals, and other advanced analytics.  

### 5. 🕒 **Date and Time Functions**  
   - Analyzing **order trends** by hour, day, and season.  

### 6. 🎯 **Data Segmentation**  
   - Dividing customers into meaningful segments based on behavior.  

### 7. 📋 **Subqueries**  
   - Simplifying complex queries for precise analysis.  

---

## 🖼️ **Entity Relationship Diagram (ERD)**  

The ERD visually represents the relationships between tables in the database.  

 [Click here to view the ERD](https://github.com/Ritam333/ZOMATO_DATA_ANALYSIS_SQL/blob/main/ERD.png)  

---


## 🚀 **Highlights of the Analysis**  

-  Identified the **most frequently ordered dishes** and analyzed **order frequency**.  
-  Analyzed **restaurant revenue** and **ranking** based on sales.  
-  Segmented customers into **gold** and **silver** based on spending for targeted marketing strategies.  

---

## 📚 **Learning Outcomes**  

- Developed queries to analyze **order cancellations** and **rider ratings**.  
- Gained insights into **customer lifetime value** and **order frequency patterns**.  
- Applied **revenue growth** analysis for restaurants and **sales trend comparisons** over time.  

---

## 🔥 **Let’s Dive In**  

Want to explore the full project?  
📂 [Check out the repository](https://github.com/Ritam333/ZOMATO_DATA_ANALYSIS_SQL) and start the action!  

---  

**Before performing analysis, I ensured that the data was clean and free from null values where necessary. For instance:**



## **Database Tables**

### 1. **Deliveries Table**
This table captures information about deliveries associated with orders and the riders handling them.

| Column Name       | Data Type       | Description                                     |
|-------------------|-----------------|-------------------------------------------------|
| `delivery_id`     | `INT` (Primary Key) | Unique identifier for the delivery.            |
| `order_id`        | `INT` (Foreign Key)`orders.order_id` | Reference to the order being delivered. |
| `delivery_status` | `VARCHAR(20)`   | Status of the delivery (e.g., completed, pending). |
| `delivery_time`   | `INTERVAL`      | Time taken for delivery.                       |
| `rider_id`        | `INT` (Foreign Key)`riders.rider_id` | Reference to the rider handling the delivery. |

---

### 2. **Orders Table**
This table stores details about customer orders placed with restaurants.

| Column Name       | Data Type       | Description                                     |
|-------------------|-----------------|-------------------------------------------------|
| `order_id`        | `INT` (Primary Key) | Unique identifier for the order.             |
| `customer_id`     | `INT`           | Reference to the customer placing the order.   |
| `restaurant_id`   | `INT`           | Reference to the restaurant fulfilling the order. |
| `order_item`      | `TEXT`          | Item(s) ordered.                               |
| `order_date`      | `DATE`          | Date of the order.                             |
| `order_time`      | `TIME`          | Time of the order.                             |
| `order_status`    | `VARCHAR(20)`   | Status of the order (e.g., completed, canceled). |
| `total_amount`    | `DECIMAL(10, 2)` | Total cost of the order.                      |

---

### 3. **Riders Table**
This table contains information about delivery riders.

| Column Name       | Data Type       | Description                                     |
|-------------------|-----------------|-------------------------------------------------|
| `rider_id`        | `INT` (Primary Key) | Unique identifier for the rider.            |
| `rider_name`      | `VARCHAR(100)`  | Name of the rider.                             |
| `sign_up`         | `DATE`          | Date of rider signup.                          |

---
### 4. **Restaurants Table**
This table stores information about restaurants, including their unique identifiers, names, locations, and operating hours.

| Column Name       | Data Type           | Description                                     |
|-------------------|---------------------|-------------------------------------------------|
| `restaurant_id`   | `INT` (Primary Key) | Unique identifier for the restaurant.          |
| `restaurant_name` | `VARCHAR(255)`      | Name of the restaurant.                        |
| `city`            | `VARCHAR(100)`      | City where the restaurant is located.          |
| `opening_hours`   | `VARCHAR(50)`       | Operating hours of the restaurant.             |

---

### 5. **Customers Table**
This table stores information about customers, including their unique identifiers, names, and registration dates.

| Column Name       | Data Type           | Description                                     |
|-------------------|---------------------|-------------------------------------------------|
| `customer_id`     | `INT` (Primary Key) | Unique identifier for the customer.            |
| `customer_name`   | `VARCHAR(255)`      | Name of the customer.                          |
| `reg_date`        | `DATE`              | Registration date of the customer.             |

---
## **Relationships**

- **Deliveries Table**:
  - `order_id` is a foreign key referencing the `Orders Table`.
  - `rider_id` is a foreign key referencing the `Riders Table`.

- **Orders Table**:
  - `customer_id` is a foreign key referencing the  `Customers Table` .
  - `restaurant_id` is a foreign key referencing the  `Restaurants Table` .
