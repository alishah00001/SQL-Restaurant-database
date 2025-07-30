# Database Management System Project: Restaurant Data Analysis

## Project Overview

This report details the implementation of a database management system for restaurant data. It covers the creation of a database, data import, definition of primary and foreign keys, establishment of relationships between tables, and the execution of T-SQL queries and a stored procedure to perform specific analytical tasks. The project utilizes four datasets: `Restaurants`, `Ratings`, `Consumers`, and `Restaurant_Cuisines`.

## Key Implementation Details and Findings

### Part 1: Database Creation and Data Import

* **Database Creation:** A database named `FoodserviceDB` was created.
* **Data Import:** Data from the provided CSV files (restaurants, ratings, consumers, restaurant_cuisines) was imported into the `FoodserviceDB` using the "Import Flat File" wizard in SQL Server Management Studio. Each file was imported individually.
* **Primary Key Definition:**
    * `Consumers` table: `Consumer_ID` was defined as the primary key.
    * `Restaurants` table: `Restaurant_ID` was defined as the primary key.
    * `Restaurant_Cuisines` table: `Restaurant_ID` and `Cuisine` were defined as a composite primary key.
    * `Ratings` table: `Consumer_ID` and `Restaurant_ID` were defined as a composite primary key to link with other tables.
* **Table Relationships:**
    * Relationships were manually established in a database diagram.
    * `Consumer_ID` and `Restaurant_ID` in the `Ratings` table serve as foreign keys, referencing `Consumer_ID` in the `Consumers` table and `Restaurant_ID` in the `Restaurants` table, respectively.
    * `Restaurant_ID` in the `Restaurant_Cuisines` table is linked to `Restaurant_ID` in the `Restaurants` table.
* **Key Relationships Summary:**
    * **Restaurant to Restaurant_Cuisines:** One-to-many, meaning one restaurant can serve multiple cuisines.
    * **Restaurant to Ratings:** One-to-many, indicating that a restaurant can have multiple ratings from different consumers.
    * **Consumers to Ratings:** One-to-many, showing that a consumer can rate multiple restaurants.

### Part 2: Task Execution Using SQL Queries and Stored Procedure

Several SQL queries and a stored procedure were implemented to address specific data retrieval and manipulation tasks.

1.  **Query: Restaurants with Medium Price, Open Area, and Mexican Food**
    * **Objective:** List all restaurants with a medium price range, an "open" area, serving Mexican food.
    * **Methodology:** Joined `Restaurants` and `Restaurant_Cuisines` tables and filtered using `WHERE` clauses for `Price = 'Medium'`, `Area = 'open'`, and `Cuisine = 'Mexican'`.
    * **Result:** Only two restaurants met these criteria: "El Oceano Dorado" and "El Rincón De San Francisco".

2.  **Query: Total Restaurants with Overall Rating 1 (Mexican vs. Italian Food)**
    * **Objective:** Count restaurants with an overall rating of 1, serving Mexican food, and compare this to restaurants with an overall rating of 1, serving Italian food.
    * **Methodology (Mexican):** Joined `Restaurants`, `Ratings`, and `Restaurant_Cuisines` tables, filtering for `Overall_Rating = 1` and `Cuisine = 'Mexican'`.
    * **Result (Mexican):** There were 87 restaurants serving Mexican food with an overall rating of 1.
    * **Methodology (Italian):** Used the same logic as above, but filtered for `Cuisine = 'Italian'`.
    * **Result (Italian):** There were only 11 restaurants serving Italian food with an overall rating of 1.
    * **Comparison:** A significant difference was observed, with 87 Mexican restaurants vs. 11 Italian restaurants having an overall rating of 1. This difference could be attributed to geographical location, different cuisine standards, customer expectations, or market competition. The dataset seems to represent a region with a higher number of Mexican restaurants, often with lower ratings compared to Italian cuisine.

3.  **Query: Average Age of Consumers with Service Rating 0**
    * **Objective:** Calculate the average age of consumers who gave a service rating of 0, rounded to the nearest whole number.
    * **Methodology:** Performed an `INNER JOIN` on `Consumers` and `Ratings` tables on `Consumer_ID`, then calculated the `AVG(Age)` and rounded it, filtering for `Service_Rating = 0`.
    * **Result:** The average age of consumers who gave a 0 service rating was 26.

4.  **Query: Restaurants Ranked by Youngest Consumer's Food Rating**
    * **Objective:** List restaurant names and their food ratings, given by the youngest consumer, sorted by food rating from high to low.
    * **Methodology:** Joined `Restaurants` and `Ratings` tables. A subquery was used to find the `Consumer_ID` of the youngest consumer (minimum age) from the `Consumers` table. The results were then ordered by `Food_Rating` in descending order.
    * **Result:** The youngest consumer (U1040, age 18) rated four restaurants: "Giovannis" (2), "Restaurant Bar Coty Y Pablo" (2), "El Cotorreo" (1), and "Kiku Cuernavaca" (1), sorted by food rating.

5.  **Stored Procedure: Update Service Rating for Restaurants with Parking**
    * **Objective:** Create a stored procedure to update the `Service_Rating` of all restaurants to '2' if they have parking available (either 'yes' or 'public').
    * **Methodology:** A stored procedure `UpdateServiceRating` was created. It updates the `Service_Rating` in the `Ratings` table to '2' for `Restaurant_ID`s found in the `Restaurants` table where `Parking` is 'yes' or 'public'.
    * **Execution & Result:** The stored procedure was executed. After execution, the `Service_Rating` column in the `Ratings` table showed updated values of '2' for relevant restaurants.

### Part 3: Custom SQL Queries

Four additional queries were created, utilizing nested queries (EXISTS, IN), system functions, and `GROUP BY`, `HAVING`, and `ORDER BY` clauses.

1.  **Query: Restaurants with at least one Service Rating of 1**
    * **Objective:** List restaurants that have at least one service rating of 1.
    * **Methodology:** Selected restaurant names from the `Restaurants` table using an `EXISTS` clause to check for restaurants that have a `Service_Rating` of 1 in the `Ratings` table.
    * **Result:** The query returned a list of restaurants that had received a service rating of 1.

2.  **Query: Average Age of Consumers Who Like Mexican Food**
    * **Objective:** Calculate the average age of consumers who have given a food rating greater than 1 to a Mexican restaurant.
    * **Methodology:** Used nested `IN` operators. The outer query calculated the `AVG(Age)` from the `Consumers` table. The inner queries filtered `Consumer_ID`s based on `Food_Rating > 1` from the `Ratings` table, and then `Restaurant_ID`s based on `Cuisine = 'Mexican'` from the `Restaurant_Cuisines` table.
    * **Result:** The average age of consumers who liked Mexican food (rating > 1) was 28.

3.  **Query: Restaurants with Average Food Rating Above 1**
    * **Objective:** List restaurant names, their average food rating, and average service rating for restaurants where the average food rating is greater than 1, sorted by average food rating in descending order.
    * **Methodology:** Joined `Restaurants` and `Ratings` tables, grouped by restaurant name. Used `HAVING AVG(ra.Food_Rating) > 1` to filter and `ORDER BY AvgFoodRating DESC` for sorting.
    * **Result:** Four restaurants met the criteria: "Giovannis", "Little Pizza Emilio Portes Gil", "Michiko Restaurant Japones", and "Restaurant Las Mañanitas", all with an average food rating of 2.

4.  **Query: Restaurants with More Than 5 Overall Ratings**
    * **Objective:** Return restaurants with their total number of overall ratings and their maximum overall rating, for restaurants that have received more than 5 overall ratings, sorted by maximum rating in descending order.
    * **Methodology:** Joined `Restaurants` and `Ratings` tables, grouped by restaurant name. Used `COUNT(*)` as a system function for `TotalRatings` and `MAX(ra.Overall_Rating)` for `MaxRating`. Filtered using `HAVING COUNT(*) > 5` and ordered by `MaxRating DESC`.
    * **Result:** The query returned a list of restaurants that had received more than 5 overall ratings, along with their total and maximum ratings.

## Conclusion

The project successfully designed and implemented a database for restaurant data with four interconnected tables: `Restaurants`, `Ratings`, `Restaurant_Cuisines`, and `Consumers`.

* **Data Integrity:** Primary and foreign keys were appropriately defined across tables to ensure data integrity and maintain crucial connections between data points.
* **Relationships:** Established relationships enable comprehensive data retrieval, allowing for complex queries that link consumer details with restaurant information and ratings.
* **Scalability:** The database design supports scalability, allowing for the accommodation of additional restaurants, consumers, and other data as the dataset grows.
