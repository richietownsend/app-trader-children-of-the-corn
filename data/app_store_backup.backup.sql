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

