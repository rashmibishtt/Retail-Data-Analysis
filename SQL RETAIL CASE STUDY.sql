Create database RETAIL_CASESTUDY

SELECT* FROM CUSTOMER
SELECT* FROM TRANSACTIONS
SELECT*FROM PROD_CAT_INFO


---------- DATA PREPARATION AND UNDERSTANDING--------------

1. 
SELECT COUNT(*) FROM CUSTOMER AS CUSTOMER_COUNT
UNION ALL
SELECT COUNT(*) FROM PROD_CAT_INFO AS PROD_COUNT
UNION ALL
SELECT COUNT(*) FROM TRANSACTIONS AS TRANSACTIONS_COUNT


2. SELECT COUNT(QTY) AS RETURN_TRANSACTIONS
FROM TRANSACTIONS WHERE QTY<0

3. ALREADY CONVERTED WHILE IMPORTING
  

4. SELECT DATEDIFF(YEAR,MIN(TRAN_DATE),MAX(TRAN_DATE)) AS YEARS,
DATEDIFF(MONTH, MIN(TRAN_DATE), MAX(TRAN_DATE)) AS MONTHS,
DATEDIFF(DAY,MIN(TRAN_DATE),MAX(TRAN_DATE)) AS DAYS FROM TRANSACTIONS



5. SELECT PROD_CAT, PROD_SUBCAT FROM prod_cat_info WHERE PROD_SUBCAT= 'DIY'




----------DATA ANALYSIS---------------

1. SELECT TOP 1 STORE_TYPE, COUNT(TRANSACTION_ID)AS TOTAL_TRANSACTION
FROM TRANSACTIONS
GROUP BY STORE_TYPE
ORDER BY COUNT(TRANSACTION_ID) DESC


2. SELECT GENDER, COUNT(CUSTOMER_ID) AS GENDER_COUNT FROM CUSTOMER WHERE GENDER IS NOT NULL
GROUP BY GENDER


3. SELECT TOP 1 CITY_CODE, COUNT(CUSTOMER_ID) AS NO_OF_CUSTOMERS
FROM CUSTOMER GROUP BY CITY_CODE ORDER BY COUNT(CUSTOMER_ID) DESC


4. SELECT PROD_CAT, COUNT(PROD_SUBCAT) AS SUBCATEGORY_COUNT
FROM PROD_CAT_INFO WHERE PROD_CAT= 'BOOKS' GROUP BY PROD_CAT


5. SELECT PROD_CAT, SUM(QTY) AS TOTAL_QTY
FROM PROD_CAT_INFO AS A
INNER JOIN TRANSACTIONS AS B
ON A.PROD_CAT_CODE= B.PROD_CAT_CODE
GROUP BY PROD_CAT ORDER BY TOTAL_QTY DESC


6. SELECT PROD_CAT, SUM(TOTAL_AMT) AS TOTAL_REVENUE
FROM PROD_CAT_INFO A
RIGHT JOIN TRANSACTIONS AS B
ON A.PROD_CAT_CODE = B.PROD_CAT_CODE AND A.PROD_SUB_CAT_CODE = B.PROD_SUBCAT_CODE
WHERE PROD_CAT IN ('ELECTRONICS','BOOKS')
GROUP BY PROD_CAT


7. SELECT COUNT(CUSTOMER_ID) AS CUST_COUNT FROM
(SELECT CUSTOMER_ID, COUNT(TRANSACTION_ID) AS TRANSACTIONSS
FROM CUSTOMER AS A
INNER JOIN TRANSACTIONS AS B
ON A.CUSTOMER_ID= B.CUST_ID
WHERE QTY>0
GROUP BY CUSTOMER_ID
HAVING COUNT(TRANSACTION_ID)>10) AS X


8. SELECT SUM(TOTAL_AMT) AS TOTAL_REVENUE
FROM TRANSACTIONS AS A
INNER JOIN PROD_CAT_INFO AS B
ON A.PROD_SUBCAT_CODE= B.PROD_SUB_CAT_CODE AND A.PROD_CAT_CODE= B.PROD_CAT_CODE
WHERE STORE_TYPE= 'FLAGSHIP STORE' AND 
PROD_CAT ='ELECTRONICS' OR PROD_CAT= 'CLOTHING'




9. SELECT PROD_CAT, GENDER,PROD_SUBCAT,SUM(TOTAL_AMT) AS TOTAL_REVENUE
   FROM CUSTOMER AS A
   INNER JOIN TRANSACTIONS AS B
   ON A.CUSTOMER_ID= B.CUST_ID
   INNER JOIN PROD_CAT_INFO AS C 
   ON C.PROD_CAT_CODE = B.PROD_CAT_CODE AND B.PROD_SUBCAT_CODE =C.PROD_SUB_CAT_CODE
   WHERE GENDER='M' AND PROD_CAT = 'ELECTRONICS'
   GROUP BY PROD_SUBCAT,PROD_CAT,GENDER


  
10. SELECT TOP 5 PROD_SUBCAT, (SUM(TOTAL_AMT)/(SELECT SUM(TOTAL_AMT) FROM TRANSACTIONS))*100 AS SALES_PERC, 
(COUNT(CASE WHEN QTY< 0 THEN QTY ELSE NULL END)/SUM(QTY))*100 AS RETURN_PERC
FROM TRANSACTIONS AS A
INNER JOIN PROD_CAT_INFO AS B
ON A.PROD_CAT_CODE = B.PROD_CAT_CODE AND PROD_SUBCAT_CODE= PROD_SUB_CAT_CODE
GROUP BY PROD_SUBCAT
ORDER BY SUM(TOTAL_AMT) DESC




11. SELECT CUST_ID,SUM(TOTAL_AMT) AS REVENUE
	FROM TRANSACTIONS AS A
	INNER JOIN CUSTOMER AS B
	ON A.CUST_ID = B.CUSTOMER_ID 
	WHERE DATEDIFF(YEAR,DOB,GETDATE()) BETWEEN '25' AND '35' 
	AND
	TRAN_DATE>= DATEADD(DAY,-30,(SELECT MAX(TRAN_DATE) FROM TRANSACTIONS))
    GROUP BY CUST_ID ORDER BY REVENUE DESC




12. SELECT PROD_CAT, SUM(TOTAL_AMT) AS RETURNS
    FROM PROD_CAT_INFO AS A
	INNER JOIN TRANSACTIONS AS B
	ON A.PROD_CAT_CODE= B.PROD_CAT_CODE AND A.PROD_CAT_CODE= B.PROD_CAT_CODE
	WHERE TOTAL_AMT<0
	AND 
	TRAN_DATE>= DATEADD(MONTH,-3,(SELECT MAX(TRAN_DATE) FROM TRANSACTIONS))
	GROUP BY PROD_CAT ORDER BY RETURNS DESC



13. SELECT TOP 1 STORE_TYPE, ROUND(SUM(TOTAL_AMT),2)AS SALES, SUM(QTY) AS QTYY
    FROM TRANSACTIONS GROUP BY STORE_TYPE 
	ORDER BY ROUND(SUM(TOTAL_AMT),2)DESC, SUM(QTY) DESC




14. SELECT PROD_CAT AS CATEGORIES, ROUND(AVG(TOTAL_AMT),2) AS AVG_REVENUE
FROM TRANSACTIONS AS A
INNER JOIN PROD_CAT_INFO AS B   
ON A.PROD_CAT_CODE= B.PROD_CAT_CODE AND A.PROD_SUBCAT_CODE= B.PROD_SUB_CAT_CODE
GROUP BY PROD_CAT HAVING AVG(TOTAL_AMT)> (SELECT AVG(TOTAL_AMT)FROM TRANSACTIONS)



15. SELECT PROD_CAT, PROD_SUBCAT, AVG(TOTAL_AMT) AS AVG_REVENUE, SUM(TOTAL_AMT) AS TOTAL_REVENUE,SUM(QTY) AS QTYY
FROM TRANSACTIONS AS A
INNER JOIN PROD_CAT_INFO AS B
ON A.PROD_CAT_CODE= B.PROD_CAT_CODE AND A.PROD_SUBCAT_CODE= B.PROD_SUB_CAT_CODE
WHERE PROD_CAT IN 
(SELECT TOP 5
PROD_CAT FROM TRANSACTIONS AS A
INNER JOIN PROD_CAT_INFO AS B
ON A.PROD_CAT_CODE= B.PROD_CAT_CODE AND A.PROD_SUBCAT_CODE= B.PROD_SUB_CAT_CODE
GROUP BY PROD_CAT
)
GROUP BY PROD_CAT, PROD_SUBCAT
ORDER BY SUM(QTY) DESC
