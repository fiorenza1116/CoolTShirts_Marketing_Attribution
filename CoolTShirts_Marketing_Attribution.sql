--CoolTShirts, an innovative apparel shop, is running a bunch of marketing campaigns. In this project, you�ll be helping them answer these questions about their campaigns:

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Part 1
--	How many campaigns and sources does CoolTShirts use and how are they related? What pages are on their website?

SELECT COUNT(DISTINCT utm_campaign) num_campaigns, 
	COUNT(DISTINCT utm_source) num_sources
FROM page_visits;

SELECT DISTINCT utm_campaign, 
	utm_source
FROM page_visits;

SELECT DISTINCT page_name
FROM page_visits;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Part 2
--	How many first touches is each campaign responsible for?



WITH first_touch AS(
	SELECT user_id, 
		MIN(timestamp) first_touch_at
	FROM page_visits
	GROUP BY user_id
	),
ft_attr AS (
	SELECT ft.user_id,
		ft.first_touch_at,
		pv.utm_source,
		pv.utm_campaign
	FROM first_touch ft
	JOIN page_visits pv
	 ON ft.user_id = pv.user_id
	 AND ft.first_touch_at = pv.timestamp
	)
SELECT ft_attr.utm_source,
	ft_attr.utm_campaign,
	COUNT(*) first_touches
FROM ft_attr
GROUP BY ft_attr.utm_source, ft_attr.utm_campaign
ORDER BY COUNT(*) DESC;




------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Part 3
--	How many last touches is each campaign responsible for?


WITH last_touch AS(
	SELECT user_id, 
		MAX(timestamp) last_touch_at
	FROM page_visits
	GROUP BY user_id
	),
lt_attr AS (
	SELECT lt.user_id,
		lt.last_touch_at,
		pv.utm_source,
		pv.utm_campaign
	FROM last_touch lt
	JOIN page_visits pv
	 ON lt.user_id = pv.user_id
	 AND lt.last_touch_at = pv.timestamp
	)
SELECT lt_attr.utm_source,
	lt_attr.utm_campaign,
	COUNT(*) last_touches
FROM lt_attr
GROUP BY lt_attr.utm_source, lt_attr.utm_campaign
ORDER BY COUNT(*) DESC;



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Part 4
--	How many visitors make a purchase?

SELECT COUNT(DISTINCT user_id) distinct_purchasers
FROM page_visits
WHERE page_name = '4 - purchase';



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Part 5
--	How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS(
	SELECT user_id, 
		MAX(timestamp) last_touch_at
	FROM page_visits
	WHERE page_name = '4 - purchase'
	GROUP BY user_id
	),
lt_attr AS (
	SELECT lt.user_id,
		lt.last_touch_at,
		pv.utm_source,
		pv.utm_campaign
	FROM last_touch lt
	JOIN page_visits pv
	 ON lt.user_id = pv.user_id
	 AND lt.last_touch_at = pv.timestamp
	)
SELECT lt_attr.utm_source,
	lt_attr.utm_campaign,
	COUNT(*) last_touch_purchases
FROM lt_attr
GROUP BY lt_attr.utm_source, lt_attr.utm_campaign
ORDER BY COUNT(*) DESC;


