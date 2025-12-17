-- Revenue summary
SELECT COUNT(*) total_payments,
       SUM(Amount) total_revenue,
       AVG(Amount) average_payment
FROM Payments
WHERE Payment_Status = 'Completed';

-- Monthly revenue
SELECT TO_CHAR(Payment_Date,'YYYY-MM') month,
       SUM(Amount) monthly_revenue
FROM Payments
WHERE Payment_Status = 'Completed'
GROUP BY TO_CHAR(Payment_Date,'YYYY-MM')
ORDER BY month;

-- Cumulative revenue
SELECT TO_CHAR(Payment_Date,'YYYY-MM') month,
       SUM(Amount) monthly_revenue,
       SUM(SUM(Amount)) OVER (ORDER BY TO_CHAR(Payment_Date,'YYYY-MM')) cumulative_revenue
FROM Payments
WHERE Payment_Status = 'Completed'
GROUP BY TO_CHAR(Payment_Date,'YYYY-MM')
ORDER BY month;
