SELECT
		s3.name,
		s3.apptrader_total_roi,
		SUM(s3.apptrader_total_roi) OVER(ORDER BY apptrader_total_roi ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_roi
FROM (
SELECT 	s2.name,
	s2.genre,
	--s2.play_rating,
	--s2.apple_rating,
	--s2.play_price,
	--s2.apple_price,
	--s2.play_reviews,
	--s2.apple_reviews,
	--s2.avg_review_count,
	--s2.p_longevity_years,
	--s2.a_longevity_years,
	--ROUND((s2.p_longevity_years + a_longevity_years) / 2, 1 ) AS avg_longevity,
	s2.play_purchase_price,
	s2.apple_purchase_price,
	ROUND((s2.p_longevity_years + a_longevity_years) / 2, 2 ) * 12000 AS total_marketing_cost,
	s2.play_purchase_price + s2.apple_purchase_price + (ROUND((s2.p_longevity_years + a_longevity_years) / 2, 2 ) * 12000) AS total_spend,
	--s2.p_longevity_years * 60000 AS p_expected_revenue,
	--s2.a_longevity_years * 60000 AS a_expected_revenue,
	ROUND((s2.p_longevity_years + a_longevity_years) / 2, 2 ) * 60000 AS apptrader_expected_revenue,
	(ROUND((s2.p_longevity_years + a_longevity_years) / 2, 2 ) * 60000) - (s2.play_purchase_price + s2.apple_purchase_price + 
	ROUND((s2.p_longevity_years + a_longevity_years) / 2, 2 ) * 12000) AS apptrader_total_roi
FROM  (
	SELECT 	sub.name,
		a.primary_genre AS genre,
		sub.play_rating,
		a.rating AS apple_rating,
		sub.play_price,
		a.price AS apple_price,
		CAST(sub.review_count AS INT) AS play_reviews,
		CAST(a.review_count AS INT) AS apple_reviews,
		ROUND((sub.review_count + CAST(a.review_count AS float) )/2) AS avg_review_count,
		ROUND(((play_rating * 2) + 1), 1) AS p_longevity_years,
		((a.rating * 2) + 1) AS a_longevity_years,
		CASE WHEN play_price <= 1 THEN 10000
	     			ELSE play_price * 10000
	     			END AS play_purchase_price,
		CASE WHEN a.price <= 1 THEN 10000
 			    	ELSE a.price * 10000
	     			END AS apple_purchase_price
	FROM (
		SELECT DISTINCT p.name, 
			INITCAP(p.category) AS genre, 
			ROUND((ROUND(p.rating * 2, 0) / 2), 1) AS play_rating,
			p.review_count,
			CAST(REPLACE(p.price,'$','')AS DEC(5,2)) AS play_price,
			p.content_rating
		FROM play_store_apps AS p
		JOIN (
		     	SELECT 	name,
				MAX(review_count) AS max_reviews
		     	FROM play_store_apps
		     	GROUP BY name) AS max_sub
	     		ON p.name = max_sub.name
	     		WHERE p.review_count = max_sub.max_reviews
	     		) AS sub
		JOIN app_store_apps AS a
		ON lower(a.name) = lower(sub.name)
		WHERE a.primary_genre = 'Games'
		ORDER BY avg_review_count DESC
		) AS s2
		ORDER BY apptrader_total_roi DESC
		LIMIT 10) AS s3
ORDER BY total_roi DESC