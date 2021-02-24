select *
from app_store_apps
WHERE name ilike '%waze%'


select *
from play_store_apps
WHERE name ilike '%waze%'

Select name, content_rating
FROM app_store_apps
CASE WHEN

UNION
Select name, content_rating
FROM play_store_apps

SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_NAME = 'app_store_apps'
	 AND COLUMN_NAME = 'price'

SELECT CAST('price' as STRING) 
FROM app_store_apps
SELECT CAST(CAST ('price' AS NUMERIC(19,4)) AS INT)
/*
select count(*)
from app_store_apps 
*/


select *
from app_store_apps
LIMIT 1

select distinct primary_genre
from app_store_apps
select *
from play_store_apps
LIMIT 1
select distinct category
from play_store_apps



--- Find WAZE app in both tables

SELECT name, content_rating

FROM 

	(SELECT name, content_rating

	FROM play_store_apps

	UNION ALL

	SELECT name , content_rating

	FROM  app_store_apps) AS subquery

WHERE name ILIKE '%waze%';

​

-- query with Pricing

--- Covert Play Store price values from Text to float

SELECT price, REPLACE(price,'$','') AS trim_price, CAST(REPLACE(price,'$','')AS float) AS float_price

FROM play_store_apps

WHERE CAST(REPLACE(price,'$','')AS float) > 3.99;

​

​

--Union ALL data with Float price and added a TEXT column to identify app from Each Table

SELECT name, float_price

FROM 

	(SELECT name, content_rating, CAST(REPLACE(price,'$','')AS float) AS float_price, TEXT 'P' as Table_name

	FROM play_store_apps

	UNION ALL

	SELECT name , content_rating, price AS float_price, TEXT 'A' as Table_name

	FROM  app_store_apps) AS subquery

GROUP BY name, float_price

ORDER BY float_price DESC;