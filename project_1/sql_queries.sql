-- Анализ продаж по месяцам
SELECT 
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(*) as order_count,
    SUM(amount) as total_revenue
FROM orders 
GROUP BY month
ORDER BY month;
