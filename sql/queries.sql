-- sanity check
SELECT COUNT(*) FROM sales as total_column;                          
SELECT COUNT(DISTINCT CustomerID) FROM sales as total_customer ;         
SELECT MIN(TransactionDate) as oldestItransaction, MAX(TransactionDate) FROM sales as latest_transaction;
SELECT DISTINCT Region FROM sales;      

--Query Insight Bisnis
	-- revenue / product kategory
SELECT 
  Product_Category,
  SUM(Amount) AS total_revenue,
  SUM(Quantity) AS total_unit_sold
FROM sales
GROUP BY Product_Category
ORDER BY total_revenue DESC;

	-- Revenue / Region
SELECT 
  Region,
  SUM(Amount) AS total_revenue,
  COUNT(DISTINCT CustomerID) AS total_customers,
  COUNT(*) AS total_transaction
FROM sales
GROUP BY Region
ORDER BY total_revenue DESC;

	--best selling product
SELECT 
  Product_Name,
  Product_Category,
  SUM(Quantity) AS total_qty_sold,
  SUM(Amount) AS total_revenue
FROM sales
GROUP BY Product_Name, Product_Category
ORDER BY total_revenue DESC;

	--monthly tren
SELECT 
  FORMAT(TransactionDate, 'yyyy-MM') AS month,
  SUM(Amount) AS total_revenue,
  COUNT(*) AS total_transactions
FROM sales
GROUP BY FORMAT(TransactionDate, 'yyyy-MM')
ORDER BY month;

	--Top Customers by Total Shopping
SELECT 
  CustomerID,
  Region,
  COUNT(*) AS jumlah_transaksi,
  SUM(Amount) AS total_belanja
FROM sales
GROUP BY CustomerID, Region
ORDER BY total_belanja DESC;

--Query RFM

WITH rfm_base AS (
  SELECT
    CustomerID,
    MAX(Region) AS Region,
    DATEDIFF(DAY, MAX(TransactionDate), (SELECT MAX(TransactionDate) FROM sales)) AS recency,
    COUNT(*) AS frequency,
    SUM(Amount) AS monetary
  FROM sales
  GROUP BY CustomerID
)
SELECT
  CustomerID,
  Region,
  recency,
  frequency,
  monetary,
  NTILE(4) OVER (ORDER BY recency DESC) AS r_score,
  NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
  NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
FROM rfm_base;