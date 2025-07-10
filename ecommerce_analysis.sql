--- 1. Monthly Revenue Trend
SELECT InvoiceMonth,
	  ROUND(SUM(TotalPrice), 2) AS MonthlyRevenue
FROM retail_data
GROUP BY InvoiceMonth
ORDER BY TO_DATE(InvoiceMonth, 'Mon-YYYY');

--- 2. Top 10 Best-Selling Products by Revenue
SELECT Description,
       SUM(Quantity) AS UnitsSold,
       ROUND(SUM(TotalPrice), 2) AS Revenue
FROM retail_data
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 10;

---3. Revenue by Country
SELECT Country,
       ROUND(SUM(TotalPrice), 2) AS Revenue
FROM retail_data
GROUP BY Country
ORDER BY Revenue DESC;

---4. Top 10 Customers by Spending
SELECT CustomerID,
       ROUND(SUM(TotalPrice), 2) AS TotalSpent,
       COUNT(DISTINCT Invoice) AS TotalInvoices
FROM retail_data
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 10;

--- 5. Repeat Customers vs One-Time Buyers
SELECT BuyerType,
COUNT(*) AS NumCustomers
FROM (SELECT CustomerID, COUNT(DISTINCT Invoice) AS invoice_count,
CASE WHEN COUNT(DISTINCT Invoice) = 1 THEN 'One-Time Buyer'
ELSE 'Repeat Buyer'
END AS BuyerType
FROM retail_data
GROUP BY CustomerID
) AS sub
GROUP BY BuyerType;


--- 6. RFM (Recency, Frequency, Monetary) Table
WITH customer_summary AS (
    SELECT
        CustomerID,
        MAX(InvoiceDate) AS LastPurchaseDate,
        COUNT(DISTINCT Invoice) AS Frequency,
        ROUND(SUM(TotalPrice), 2) AS Monetary
    FROM retail_data
    GROUP BY CustomerID
)
SELECT *,
       CURRENT_DATE - LastPurchaseDate AS Recency
FROM customer_summary;

---7. Product Return Rate (Quantity < 0)
SELECT
    COUNT(*) AS TotalReturns,
    ROUND(SUM(CASE WHEN Quantity < 0 THEN TotalPrice ELSE 0 END), 2) AS ReturnRevenueLoss
FROM retail_data
WHERE Quantity < 0;

--- 8. Daily Revenue Trend
SELECT DATE(InvoiceDate) AS SaleDate,
       ROUND(SUM(TotalPrice), 2) AS DailyRevenue
FROM retail_data
GROUP BY DATE(InvoiceDate)
ORDER BY SaleDate;




