SELECT INITCAP(all_genres)as genres, name, float_price, ROUND(rating,1) AS RATING, ROUND(AVG(review_count),0) AS avg_reviews
FROM 
	(SELECT name, 
	 		content_rating, 
	 		CAST(REPLACE(price,'$','')AS float) AS float_price,
	 		TEXT 'P' as Table_name , 
	 		category AS all_genres, 
	 		ROUND(rating * 2, 0)/2 AS rating,
	 		CAST(review_count AS INTEGER)
	 FROM play_store_apps AS p
	LEFT JOIN
	SELECT name, 
	 		content_rating, 
	 		price AS float_price, 
	 		TEXT 'A' as Table_name, 
	 		primary_genre AS all_genres, 
	 		rating,
	 		CAST(review_count AS INTEGER)
	FROM  app_store_apps AS ) AS subquery
WHERE float_price <= 1 AND INITCAP(all_genres) ilike '%Game%' AND rating IS NOT null
GROUP BY INITCAP(all_genres),name, float_price, rating
ORDER BY float_price, avg_reviews DESC, rating DESC;


--- Inner Join Subquery

SELECT 	p.name,
	 	p.content_rating, 
	 	CAST(REPLACE(p.price,'$','')AS float) AS p_float_price,
		a.price AS a_float_price,
	 	p.category AS p_all_genres,
		primary_genre AS a_all_genres,
	 	ROUND(p.rating * 2, 0)/2 AS p_rating,
		a.rating AS a_rating,
	 	CAST(p.review_count AS INTEGER) AS p_review_count,
		CAST(a.review_count AS INTEGER) AS a_review_count
FROM  play_store_apps AS p
JOIN
app_store_apps AS a
ON lower(a.name) = lower(p.name);

--- Application by Game Genre joined with app store & play store with the highest average review counts followed by Highest Ratings
SELECT INITCAP(a_all_genres)as genres, name, p_float_price, a_float_price, ROUND(p_rating,1) AS p_rating, a_rating, ROUND((p_review_count+a_review_count)/2) AS avg_reviews
FROM 
	(SELECT p.name,
	 	p.content_rating, 
	 	CAST(REPLACE(p.price,'$','')AS float) AS p_float_price,
		a.price AS a_float_price,
	 	p.category AS p_all_genres,
		primary_genre AS a_all_genres,
	 	ROUND(p.rating * 2, 0)/2 AS p_rating,
		a.rating AS a_rating,
	 	CAST(p.review_count AS INTEGER) AS p_review_count,
		CAST(a.review_count AS INTEGER) AS a_review_count
FROM  play_store_apps AS p
JOIN
app_store_apps AS a
ON lower(a.name) = lower(p.name)) AS subquery

WHERE p_float_price <= 5 AND a_float_price <= 5
	AND INITCAP(a_all_genres) ilike '%Game%' 
	AND p_rating IS NOT null
GROUP BY INITCAP(a_all_genres),name, p_float_price, a_float_price, p_rating, a_rating, avg_reviews
ORDER BY avg_reviews DESC, p_rating DESC;

--- Application by Game Genre joined with app store & play store with the highest average review counts followed by Highest Ratings
SELECT INITCAP(all_genres)as genres, 
		name, 
		float_price, 
		ROUND(rating,1) AS RATING,
		ROUND(AVG(review_count),0) AS avg_reviews,
		((rating * 2)+1) AS longevity_years,
		CASE WHEN float_price <= 1 THEN 10000
			ELSE ROUND(float_price *10000) 
			END AS purchase_price,
		(((rating * 2)+1)*12000) AS total_subscription_cost, -- longevity * 12000
		(((rating * 2)+1)*12000)+ (CASE WHEN float_price <= 1 THEN 10000
			ELSE ROUND(float_price *10000) 
			END) AS total_cost,  --Add the Case Statement value as an Alias AS total_cost
		(((rating * 2)+1)*60000) AS total_expected_revenue, 
		((((rating * 2)+1)*60000)-(((rating * 2)+1)*12000)) AS total_ROI -- Missing Subscription cost to be subtracted
FROM 
	(SELECT p.name,
	 	p.content_rating, 
	 	CAST(REPLACE(p.price,'$','')AS float) AS float_price,
	 	p.category AS all_genres, 
	 	ROUND(p.rating * 2, 0)/2 AS rating,
	 	CAST(p.review_count AS INTEGER) AS review_count
	FROM  play_store_apps AS p
	JOIN
	app_store_apps AS a
	ON a.name = p.name) AS subquery
WHERE float_price <= 5 AND INITCAP(all_genres) ilike '%Game%' AND rating IS NOT null
GROUP BY INITCAP(all_genres),name, float_price, rating
ORDER BY avg_reviews DESC, rating DESC;

--- Help from Andrew as NEW SUBQUERY

SELECT sub.name, 
		ROUND((ROUND(sub.rating * 2, 0)/2),1) as play_rating,
		a.rating as apple_rating,
		CAST(REPLACE(sub.price,'$','')AS float) AS play_price,
		a.price as apple_price,
		sub.review_count as play_reviews,
		a.review_count as apple_reviews,
		ROUND((sub.review_count + CAST(a.review_count AS FLOAT) ) / 2) as avg_review_count,
		ROUND((((ROUND(sub.rating * 2, 0)/2) * 2)+1),1) AS p_longevity_years,
		((a.rating * 2)+1) AS a_longevity_years,
		CASE WHEN CAST(REPLACE(sub.price,'$','')AS float) <= 1 THEN 10000
			ELSE ROUND(CAST(REPLACE(sub.price,'$','')AS float)*10000) 
			END AS play_purchase_price,
		CASE WHEN a.price <= 1 THEN 10000
			ELSE a.price*10000 
			END AS apple_purchase_price
		
FROM(
		SELECT DISTINCT p.name, p.category, p.rating,
				p.review_count, p.size, p.install_count,
				p.type, p.price, p.content_rating,
				p.genres, max_sub.max_reviews
		FROM play_store_apps p
		INNER JOIN (
			SELECT name,
					MAX(review_count) as max_reviews
			FROM play_store_apps
			GROUP BY name
		) max_sub
			ON p.name = max_sub.name
		WHERE p.review_count = max_sub.max_reviews
	) sub
INNER JOIN app_store_apps a
	ON lower(a.name) = lower(sub.name)
ORDER BY avg_review_count DESC;