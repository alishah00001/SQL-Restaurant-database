create database FoodserviceDB
go


--Write a query that lists all restaurants with a Medium range price with open area, serving Mexican food.
SELECT r.Name
FROM [restaurants.csv] r
JOIN Restaurant_Cuisines rc ON r.Restaurant_id = rc.Restaurant_id
WHERE r.Price = 'Medium' 
AND r.Area = 'open' 
AND rc.Cuisine = 'Mexican'
;




--Write a query that returns the total number of restaurants who have the overall rating 
--as 1 and are serving Mexican food. Compare the results with the total number of 
--restaurants who have the overall rating as 1 serving Italian food

-- Query for restaurants with overall rating 1 serving Mexican food
SELECT r.Name, r.City, r.State, r.Country
FROM [restaurants.csv] r
JOIN Ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines rc ON r.Restaurant_id = rc.Restaurant_id
WHERE ra.Overall_Rating = 1
AND rc.Cuisine = 'Mexican';


-- Query for restaurants with overall rating 1 serving Italian food
SELECT r.Name, r.City, r.State, r.Country
FROM [restaurants.csv] r
JOIN Ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN Restaurant_Cuisines rc ON r.Restaurant_id = rc.Restaurant_id
WHERE ra.Overall_Rating = 1
AND rc.Cuisine = 'Italian';



--Calculate the average age of consumers who have given a 0 rating to the 'Service_rating' column.
SELECT ROUND(AVG(Age), 0) AS Avg_Age_for_Service_Rating
FROM ratings
INNER JOIN Consumers ON ratings.Consumer_ID = consumers.Consumer_id
WHERE Service_Rating = 0;


--Write a query that returns the restaurants ranked by the youngest consumer. You 
---should include the restaurant name and food rating that is given by that customer to 
---the restaurant in your result. Sort the results based on food rating from high to low.
SELECT 
    r.Name AS ResturantName,
    ra.Food_Rating,
    ra.Consumer_id
FROM 
    [restaurants.csv] r
JOIN 
    Ratings ra ON r.Restaurant_id = ra.Restaurant_id
JOIN 
    (SELECT 
         Consumer_id,
         MIN(Age) AS MinAge
     FROM 
         Consumers
     GROUP BY 
         Consumer_id) c ON ra.Consumer_id = c.Consumer_id
	WHERE
    c.MinAge = (SELECT MIN(Age) FROM Consumers)
ORDER BY 
    ra.Food_Rating DESC;



	---Write a stored procedure for the query given as:
----Update the Service_rating of all restaurants to '2' if they have parking available, either 
----as 'yes' or 'public'
CREATE PROCEDURE UpdateServiceRating
AS
BEGIN
    -- Update Service_rating of restaurants with parking available to '2'
    UPDATE Ratings
    SET Service_Rating = '2'
    WHERE Restaurant_id IN (
        SELECT Restaurant_id
        FROM [restaurants.csv]
        WHERE Parking IN ('yes', 'public')
    );
END;

EXEC UpdateServiceRating;


---You should also write four queries of your own and provide a brief explanation of the 
---results which each query returns. You should make use of all of the following at least 
---once:
---Nested queries-EXISTS
---Nested queries-IN
---System functions
---Use of GROUP BY, HAVING and ORDER BY clauses


---1-	Restaurants with Average Rating Above 1
SELECT Name
FROM [restaurants.csv] r
WHERE EXISTS (
  SELECT 1
  FROM ratings rt
  WHERE rt.Restaurant_id = r.Restaurant_id
  AND rt.Service_Rating = 1
);



---2-	Average Age of Consumers Who Like Mexican Food
SELECT ROUND(AVG(Age), 0) AS Avg_Age_Mexican_Likers
FROM consumers c
WHERE Consumer_id IN (
  SELECT Consumer_id
  FROM ratings rt
  WHERE rt.Food_Rating > 1  
  AND rt.Restaurant_id IN (
    SELECT Restaurant_id
    FROM restaurant_cuisines 
    WHERE Cuisine = 'Mexican'
  )
);


----3.	Restaurants with Average Food Rating Above 1
SELECT
  r.Name AS RestaurantName,
  AVG(ra.Food_Rating) AS AvgFoodRating,
  AVG(ra.Service_Rating) AS AvgServiceRating
FROM
  [restaurants.csv] r  
LEFT JOIN
  Ratings ra ON r.Restaurant_id = ra.Restaurant_id
GROUP BY
  r.Name
HAVING
  AVG(ra.Food_Rating) > 1  -- Filter for restaurants with average food rating above 1
ORDER BY
  AvgFoodRating DESC;


  ----4.	Restuarants that have received more than 1 over all rating
 SELECT 
    r.Name AS RestaurantName,
    COUNT(*) AS TotalRatings,
    MAX(ra.Overall_Rating) AS MaxRating
FROM 
    [restaurants.csv] r
LEFT JOIN 
    Ratings ra ON r.Restaurant_id = ra.Restaurant_id
GROUP BY 
    r.Name
HAVING 
    COUNT(*) > 5
ORDER BY 
    MaxRating DESC;



