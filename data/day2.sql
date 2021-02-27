SELECT all_genres, table_name, COUNT(name) AS app_count, SUM(review_count) AS reviews
FROM 
	(SELECT DISTINCT category AS all_genres, TEXT 'P' AS table_name, name, CAST(review_count AS integer)
	FROM play_store_apps
	UNION
	 SELECT DISTINCT primary_genre AS all_genres, TEXT 'A' AS table_name, name, CAST(review_count AS integer)
	 FROM app_store_apps) AS subquery
GROUP BY all_genres, table_name
ORDER BY all_genres;

SELECT all_genres, table_name, COUNT(name) AS app_count
FROM 
	(SELECT DISTINCT category AS all_genres, TEXT 'P' AS table_name, name
	FROM play_store_apps
	UNION
	 SELECT DISTINCT primary_genre AS all_genres, TEXT 'A' AS table_name, name
	 FROM app_store_apps) AS subquery
GROUP BY all_genres, table_name
ORDER BY all_genres;

SELECT table_name, COUNT(DISTINCT name) AS app_count, AVG(review_count)
FROM 
	(SELECT DISTINCT category AS all_genres, TEXT 'P' AS table_name, name, CAST(review_count AS integer)
	FROM play_store_apps
	UNION
	 SELECT DISTINCT primary_genre AS all_genres, TEXT 'A' AS table_name, name, CAST(review_count AS integer)
	 FROM app_store_apps) AS subquery
GROUP BY table_name
ORDER BY table_name;




SELECT DISTINCT a.name
FROM app_store_apps AS a
LEFT JOIN play_store_apps AS p
ON a.name = p.name;


