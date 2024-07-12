use case1;

select * from weekly_sales limit 10;

-- data cleaning
create table clean_weakly_sales as
select week_date,week(week_date) as week_number,
month(week_date) as month_number,
year(week_date) as calender_year,region,platform,
case when segment is null then 'unknown'
else segment end as segment,
case when segment like '%1' then 'young_adults'
when segment like '%2' then 'middle_aged'
when segment like '%3' or segment like '%4' then 'retires'
else 'unknown' end as age_band,
case when left(segment,1)='C' then 'couple'
when left(segment,1)='F' then 'family'
else 'unknown' end as demographic,customer_type,transactions,sales,
round(sales/transactions,2) as 'avg_transaction'
from weekly_sales;

select * from clean_weakly_sales limit 10;
--  1
create table seq100(x int auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select x + 50 from seq100;
select * from seq100;
create table seq52 as (select * from seq100 limit 52);
select * from seq52;
select x as week_not from seq52 where x not in (select distinct week_number from clean_weakly_sales);

-- 2
select calender_year,sum(transactions) as total_transaction
from clean_weakly_sales group by calender_year order by calender_year;

-- 3
select region,month_number,sum(sales) total_sales from clean_weakly_sales group by region,month_number order by region,month_number;
-- 4
select platform,sum(transactions) as count_transaction from clean_weakly_sales group by platform;

-- 5
WITH cte_monthly_platform_sales AS (
  SELECT
    month_number,calender_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weakly_sales
  GROUP BY month_number,calender_year, platform
)
SELECT
  month_number,calender_year,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number,calender_year
ORDER BY month_number,calender_year;


-- 6 
select calender_year,demographic,
sum(sales) as yearly_sales,
round(
(100*sum(sales)/sum(sum(sales)) over(partition by demographic)),2)as percent
from clean_weakly_sales
group by calender_year,demographic
order by calender_year,demographic;

-- 7
SELECT
  age_band,
  demographic,
  SUM(sales) AS total_sales
FROM clean_weakly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;