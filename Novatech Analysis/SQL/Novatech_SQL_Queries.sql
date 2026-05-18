
-- Q1 ✅ What is the total sales, expenses, profit and profit margin by region
select region, sum(total_sales) AS sum_of_sales , sum(expenses) AS total_expenses ,sum(profit) as total_profit from sales_data
GROUP BY region;

-- Q2 ✅ Which product makes the most profit? Rank highest to lowest with profit margin!-- 
select product, sum(total_sales) AS sum_of_sales,sum(profit) as total_profit from sales_data
Group by product
ORDER BY total_profit;

-- Q3 -Who are the Top 3 sales reps by profit? How many transactions did each make?
select sales_rep,sum(total_sales) AS sum_of_sales,sum(profit) as total_profit, COUNT(*) as total_transactions from sales_data
group by sales_rep
ORDER BY total_profit DESC
limit 3;

-- Q4 What is the monthly sales trend throughout the year?
SELECT 
    MONTH(date) AS month_num,
    MONTHNAME(date) AS month_name,
    SUM(total_sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY 
    MONTH(date),
    MONTHNAME(date)
ORDER BY month_num ASC;

-- Q5- which region performs best for each product?
----  SELECT region, product, sum(total_sales) AS sum_of_sales,sum(profit) as total_profit from sales_data
-- -- Group By product,region
-- -- Order by product, total_profit DESC;

-- Query 6 — Category Performance-- 
Select category,COUNT(*) AS total_transcation,SUM(units_sold) AS total_units,  SUM(total_sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit) / SUM(total_sales)) * 100, 2) AS profit_margin_pct
FROM sales_data
GROUP BY category
ORDER BY total_profit DESC;

-- Q7 What are the monthly gross margin, EBITDA margin and net profit margin percentages?
select month, revenue, ROUND((gross_profit/ revenue)*100,2) AS gross_margin_pct,
ROUND((ebitda/ revenue)*100,2) AS ebitda_margin_pct,
ROUND((net_profit / revenue)*100,2) AS net_margin_pct FROM income_statement ORDER BY month_num;

-- Q8 Which month had the best and worst net profit?
Select month,revenue, net_profit from income_statement 
WHERE net_profit = (SELECT max(net_profit) from income_statement)
OR net_profit = (SELECT min(net_profit) from income_statement);

-- Q9)How does each quarter perform in revenue, gross profit and net profit?
SELECT 
 CASE
    WHEN month_num BETWEEN 1 and 3 THEN "Q1"
    WHEN month_num BETWEEN 4 and 6 THEN "Q2"
    WHEN month_num BETWEEN 7 and 9 THEN "Q3"
    ELSE "Q4"
END AS QUARTER,
Sum(revenue) AS total_revenue,
SUM(gross_profit) AS total_gross_profit,
SUM(net_profit) AS total_net_profit
FROM Income_statement
GROUP BY QUARTER
ORDER BY QUARTER;


-- Q10)What is NovaTech's complete annual P&L with all margins?"
select 
 SUM(revenue) as annual_revenue,
 SUM(cogs) as annual_cogs,
 sum(gross_profit) as annual_gross_profit,
 ROUND((SUM(gross_profit)/SUM(revenue))*100,2)as gross_margin_pct,
 SUM(ebitda) AS annual_ebitda,
 ROUND((SUM(ebitda)/SUM(revenue))*100,2) as ebitda_margin_pct,
 SUM(net_profit) AS annual_net_profit ,
 ROUND((SUM(net_profit) / SUM(revenue)) * 100, 2) AS net_profit_margin
 From income_statement;

-- Q11) What are NovaTech's quarterly current ratio, working capital and debt to equity?
SELECT 
    quarter,
    total_current_assets,
    total_current_liabilities,
    ROUND(total_current_assets / total_current_liabilities, 2) AS current_ratio,
    total_current_assets - total_current_liabilities AS working_capital,
    ROUND(total_liabilities / equity, 2) AS debt_to_equity
FROM balance_sheet
ORDER BY id;

-- Q12) What percentage of total assets are cash vs fixed assets each quarter?
Select
quarter,cash,fixed_assets,total_assets,
ROUND((cash/total_assets)*100,2) as cash_pct,
ROUND((fixed_assets/total_assets)*100,2) as fixed_assets_pct
from balance_sheet
order by id;

-- Q13) What percentage of total assets are cash vs fixed assets each quarter?
SELECT 
    month,
    operating_cash_flow,
    investing_cash_flow,
    financing_cash_flow,
    net_cash_flow,
    closing_balance
FROM cash_flow
ORDER BY month_num;

-- Q14) Which months had healthy vs concerning cash flow?
SELECT 
    month,
    operating_cash_flow,
    net_cash_flow,
    closing_balance,
    CASE 
        WHEN operating_cash_flow > 500000 AND net_cash_flow > 0 THEN 'Strong ✅'
        WHEN operating_cash_flow > 0 AND net_cash_flow > 0 THEN 'Healthy 🟡'
        WHEN operating_cash_flow > 0 AND net_cash_flow < 0 THEN 'Watch Out ⚠️'
        ELSE 'Critical 🔴'
    END AS cash_health
FROM cash_flow
ORDER BY month_num;

SELECT 
    i.month,
    i.revenue AS reported_revenue,
    SUM(s.total_sales) AS sales_transactions,
    i.net_profit,
    ROUND((i.net_profit / i.revenue) * 100, 2) AS net_margin_pct
from income_statement i
LEFT JOIN sales_data s ON month(s.date) = i.month_num
GROUP BY i.month, i.revenue, i.net_profit, i.month_num
ORDER BY i.month_num; 
