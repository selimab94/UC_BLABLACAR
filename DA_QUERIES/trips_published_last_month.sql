--i. How many trip offers have been published last month?

SELECT COUNT(Dim_Offer.offer_id) AS total_offers_published
FROM Dim_Offer 
LEFT JOIN Dim_Calendar ON Dim_Offer.offer_start_date = Dim_Calendar.date
WHERE Dim_Calendar.month = MONTH(CURRENT_DATE - DAY(CURRENT_DATE))
  AND Dim_Calendar.year = YEAR(CURRENT_DATE - DAY(CURRENT_DATE))
  AND Dim_Offer.is_published = TRUE;

--ii. What country had the highest number of publications last month?
SELECT 
    Dim_Country.country_name, 
    COUNT(Fact_Trips.trip_id) AS trip_count
FROM 
    Fact_Trips
-- Join to Dim_Offer to link trip offers
LEFT JOIN Dim_Offer  ON Fact_Trips.offer_id = Dim_Offer.offer_id
-- Join to Dim_Calendar to filter by offer start dates
LEFT JOIN Dim_Calendar ON Dim_Offer.offer_start_date = Dim_Calendar.date
-- Join to Dim_City to get city, then country information
LEFT JOIN Dim_City  ON Fact_Trips.origin_city_id = Dim_City.city_id
LEFT JOIN Dim_Country ON Dim_City.country_id = Dim_Country.country_id
WHERE 
    Dim_Calendar.month = MONTH(CURRENT_DATE - DAY(CURRENT_DATE))
    AND Dim_Calendar.year = YEAR(CURRENT_DATE - DAY(CURRENT_DATE))
    AND Dim_Offer.is_published = TRUE
GROUP BY  Dim_Country.country_name
ORDER BY  trip_count DESC
LIMIT 1;
