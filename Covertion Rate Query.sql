use conversionrate;
select * from crp;

# Conversion Rate & Trend Analysis
#1. What is the overall conversion rate across all quotes?
SELECT 
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*), 2) AS conversion_rate_percentage
FROM crp;

#2. How does the conversion rate vary by region?
SELECT region,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage
FROM crp
GROUP BY region
ORDER BY conversion_rate_percentage DESC;

#3. What is the daily trend of conversions over time?

SELECT request_date,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage
FROM crp
GROUP BY request_date
ORDER BY request_date;

#4. Which sales channel has the highest conversion rate?

select * from crp;
SELECT channel,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage
FROM crp
GROUP BY channel
ORDER BY conversion_rate_percentage desc;

#5. What is the average customer age for converted vs non-converted users?

SELECT converted, COUNT(*) AS user_count, AVG(customer_age) AS avg_age
FROM crp
GROUP BY converted;

#Price & Discount Analysis
#6. What is the average price offered for converted vs non-converted quotes?

select * from crp;

SELECT converted, COUNT(*) AS user_count, Round(AVG(price_offered),2) AS avg_age
FROM crp
GROUP BY converted;

#7. Does higher discount percentage correlate with higher conversion?

SELECT 
  CASE 
    WHEN discount_percent < 5 THEN '<5%'
    WHEN discount_percent BETWEEN 5 AND 10 THEN '5-10%'
    WHEN discount_percent BETWEEN 10 AND 15 THEN '10-15%'
    WHEN discount_percent > 15 THEN '>15%'
  END AS discount_bucket,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted= '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage
FROM crp
GROUP BY discount_bucket
ORDER BY discount_bucket;

#8. What is the average discount offered by channel?


select channel, avg(discount_percent) as avg_dicount
from crp
group by channel;

#9. What’s the conversion rate per discount bucket (0%, 5%, 10%, etc.)?
SELECT 
  discount_percent,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*), 2) AS conversion_rate_percentage
FROM crp
GROUP BY discount_percent
ORDER BY discount_percent;

#10. What is the revenue lost (in price terms) due to unconverted quotes?

select * from crp;
SELECT COUNT(*) AS unconverted_quotes,
  SUM(price_offered) AS total_lost_revenue
FROM crp
WHERE converted != '1';

#Customer Demographics
#11. How does conversion rate differ between male and female customers?
select * from crp;

SELECT gender,COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*), 2) AS conversion_rate_percentage
FROM crp
GROUP BY gender
ORDER BY conversion_rate_percentage DESC;


#12. What is the age distribution of customers who converted?

select customer_age, count(*) as total_qoutes from crp
where converted ='1'
group by customer_age
order by customer_age asc;


#13. Which age group (18–25, 26–35, etc.) converts the most?

SELECT 
  CASE 
    WHEN customer_age BETWEEN 18 AND 25 THEN '18–25'
    WHEN customer_age BETWEEN 26 AND 35 THEN '26–35'
    WHEN customer_age BETWEEN 36 AND 45 THEN '36–45'
    WHEN customer_age BETWEEN 46 AND 55 THEN '46–55'
    WHEN customer_age > 55 THEN '56+'
    ELSE 'Unknown'
  END AS age_group,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage
FROM crp
GROUP BY age_group
ORDER BY conversion_rate_percentage DESC;

#Region & Channel Insights
#15. What are the top 3 regions with the highest total number of conversions?
select region, count(*) as total_qoutes from crp
where converted ='1'
group by region 
order by region desc
limit 3;

#16. What is the average price offered by region and by channel?
select avg(price_offered) as avgpriceoffered from crp
group by region and channel;

#17. Which region-channel combinations have the best conversion performance?

SELECT region,channel,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage,
RANK() OVER (PARTITION BY channel ORDER BY (COUNT(CASE WHEN converted = '1' THEN 1 END) * 1.0) / COUNT(*) DESC) AS channel_rank_in_region
FROM crp
GROUP BY region, channel
ORDER BY channel DESC;

SELECT region,channel,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND((COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0) / COUNT(*),2) AS conversion_rate_percentage
FROM crp
GROUP BY region, channel
ORDER BY conversion_rate_percentage DESC;

#Time-Based Performance
#18. What is the monthly  conversion trend?

SELECT 
  DATE_FORMAT(STR_TO_DATE(request_date, '%Y-%m-%d'), '%m') AS month,
  COUNT(*) AS total_quotes,
  COUNT(CASE WHEN converted = '1' THEN 1 END) AS converted_quotes,
  ROUND(COUNT(CASE WHEN converted = '1' THEN 1 END) * 100.0 / COUNT(*), 2) AS conversion_rate_percentage
FROM crp
WHERE request_date IS NOT NULL
GROUP BY  month
ORDER BY month;

select * from crp;


#19. Which days (or hours, if timestamp used) see the highest quote volumes?

select DATE_FORMAT(STR_TO_DATE(request_date, '%d-%m-%Y'), '%d')AS day,
count(case when converted = '1' then '1' end ) as converted_quots,
count(case when converted = '1' then '1' end ) * 100/ count(*) AS conversion_rate_percentage
from crp
group by day
order by day;

#20. What is the average quote volume per day and how does that relate to conversion?

SELECT 
  ROUND(COUNT(*) / COUNT(DISTINCT STR_TO_DATE(request_date, '%Y-%m-%d')), 2) AS avg_daily_quote_volume,
  ROUND(SUM(CASE WHEN converted = '1' THEN 1 ELSE 0 END) / COUNT(DISTINCT STR_TO_DATE(request_date, '%Y-%m-%d')), 2) AS avg_daily_converted_quotes,
  ROUND(SUM(CASE WHEN converted = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_conversion_rate_percentage
FROM crp
WHERE request_date IS NOT NULL;

