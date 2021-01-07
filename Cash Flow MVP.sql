SELECT *
FROM(
       SELECT*
         FROM(

             SELECT * 
             FROM(
	             SELECT 
                 Payment_Type,
                 DATE(Payment_Date,"America/Mexico_City") AS Payment_Date,
                 DATE(Refund_Date,"America/Mexico_City") AS Refund_Date,(
                     CASE 
                     WHEN Payment_Date IS NOT NULL THEN 1 
                     ELSE 0 
                     END) AS PaymentD,
                 Amount, 
                 Payment_Method, 
                 Payment_Gateway,
                 Customer_Id, 
                 Payment_Origin,  
                 FROM dbmoonsprod.DealPayment) AS DealPayment

             LEFT JOIN

             (SELECT DATE(DATE_SUB(CURRENT_DATE("America/Mexico_City"),INTERVAL number.num DAY)) AS Day
             FROM(
                 SELECT num 
                 FROM UNNEST(GENERATE_ARRAY(0,5000)) AS num) number) AS Time

             ON Time.Day = DealPayment.Payment_Date) AS Payment
 
         FULL JOIN

         (SELECT *
         FROM(
     
             SELECT * 
             FROM(
	             SELECT 
                 Payment_Type,
                 DATE(Payment_Date,"America/Mexico_City") AS Payment_Date,
                 DATE(Refund_Date,"America/Mexico_City") AS Refund_Date,(
                 CASE 
                 WHEN Refund_Date IS NOT NULL THEN 1 
                 ELSE 0 
                 END) RefundD,
                 Amount, 
                 Payment_Method, 
	             Payment_Gateway,
	             Customer_Id, 
	             Payment_Origin,  
                 FROM dbmoonsprod.DealPayment) AS DealPayment

                 LEFT JOIN

                 (SELECT DATE(DATE_SUB(CURRENT_DATE("America/Mexico_City"), INTERVAL number.num DAY)) AS Day
                 FROM(
                 	SELECT num 
                 	 FROM UNNEST(GENERATE_ARRAY(0,5000)) AS num) number) AS Time


                 ON Time.Day = DealPayment.Refund_Date)) AS Refund

         USING (Day,Payment_Type,Payment_Date,Refund_Date,Amount,Payment_Method,Payment_Gateway,Customer_Id,Payment_Origin)) AS RefundQ


     FULL JOIN

     (SELECT CustomerId,(
     	 CASE WHEN days_diff < 6570 THEN "Under 18"
         WHEN days_diff BETWEEN 6570 AND 9124 THEN "18 to 24"
         WHEN days_diff BETWEEN 9125 AND 12774 THEN "25 to 34"
         WHEN days_diff BETWEEN 12775 AND 16424 THEN "35 to 44"
         WHEN days_diff BETWEEN 16425 AND 19579 THEN "45 to 54"
         WHEN days_diff BETWEEN 19580 AND 23724 THEN "45 to 54"
         WHEN days_diff >= 23725 THEN "More than 65"
         ELSE NULL
         END) AS Age_Range,(
         CASE 
         WHEN Incidence_Reason_Type LIKE "%Refinamiento%" THEN 1 
         ELSE 0
         END) AS Refinamientos,
         days_diff,
         DATE(Birthdate,"America/Mexico_City") Birthdate_Date
     FROM(SELECT DATE_DIFF(CURRENT_DATE("America/Mexico_City"),DATE(Birthdate),DAY) AS days_diff, 
     CustomerId, 
     Incidence_Reason_Type,
     Birthdate 
     FROM dbmoonsprod.Patient) AS Age) Filter


     ON RefundQ.Customer_Id = Filter.CustomerId

     # Versión 2 Currency
     
SELECT *
FROM(
       SELECT*
         FROM(

             SELECT * 
             FROM(
	             SELECT 
                 Payment_Type,
                 DATE(Payment_Date,"America/Mexico_City") AS Payment_Date,
                 DATE(Refund_Date,"America/Mexico_City") AS Refund_Date,(
                     CASE 
                     WHEN Payment_Date IS NOT NULL THEN 1 
                     ELSE 0 
                     END) AS PaymentD,
                 Amount,
                 Currency,
                 Exchange_Rate,
                 Payment_Method, 
                 Payment_Gateway,
                 Customer_Id, 
                 Payment_Origin,  
                 FROM dbmoonsprod.DealPayment) AS DealPayment

             LEFT JOIN

             (SELECT DATE(DATE_SUB(CURRENT_DATE("America/Mexico_City"),INTERVAL number.num DAY)) AS Day
             FROM(
                 SELECT num 
                 FROM UNNEST(GENERATE_ARRAY(0,5000)) AS num) number) AS Time

             ON Time.Day = DealPayment.Payment_Date) AS Payment
 
         FULL JOIN

         (SELECT *
         FROM(
     
             SELECT * 
             FROM(
	             SELECT 
                 Payment_Type,
                 DATE(Payment_Date,"America/Mexico_City") AS Payment_Date,
                 DATE(Refund_Date,"America/Mexico_City") AS Refund_Date,(
                 CASE 
                 WHEN Refund_Date IS NOT NULL THEN 1 
                 ELSE 0 
                 END) RefundD,
                 Amount, 
                 Currency,
                 Exchange_Rate,
                 Payment_Method, 
	               Payment_Gateway,
	               Customer_Id, 
	               Payment_Origin,  
                 FROM dbmoonsprod.DealPayment) AS DealPayment

                 LEFT JOIN

                 (SELECT DATE(DATE_SUB(CURRENT_DATE("America/Mexico_City"), INTERVAL number.num DAY)) AS Day
                 FROM(
                 	SELECT num 
                 	 FROM UNNEST(GENERATE_ARRAY(0,5000)) AS num) number) AS Time


                 ON Time.Day = DealPayment.Refund_Date)) AS Refund

         USING (Day,Payment_Type,Payment_Date,Refund_Date,Amount,Payment_Method,Payment_Gateway,Customer_Id,Payment_Origin,Currency, Exchange_Rate)) AS RefundQ


     FULL JOIN

     (SELECT CustomerId,(
     	 CASE WHEN days_diff < 6570 THEN "Under 18"
         WHEN days_diff BETWEEN 6570 AND 9124 THEN "18 to 24"
         WHEN days_diff BETWEEN 9125 AND 12774 THEN "25 to 34"
         WHEN days_diff BETWEEN 12775 AND 16424 THEN "35 to 44"
         WHEN days_diff BETWEEN 16425 AND 19579 THEN "45 to 54"
         WHEN days_diff BETWEEN 19580 AND 23724 THEN "45 to 54"
         WHEN days_diff >= 23725 THEN "More than 65"
         ELSE NULL 
         END) AS Age_Range,(
         CASE 
         WHEN Incidence_Reason_Type LIKE "%Refinamiento%" THEN 1 
         ELSE 0
         END) AS Refinamientos,
         days_diff,
         DATE(Birthdate,"America/Mexico_City") Birthdate_Date,
         Final_Payment_Date
     FROM(SELECT DATE_DIFF(CURRENT_DATE("America/Mexico_City"),DATE(Birthdate),DAY) AS days_diff, 
     CustomerId, 
     Incidence_Reason_Type,
     Final_Payment_Date,
     Currency,
     Birthdate 
     FROM dbmoonsprod.Patient) AS Age) Filter


     ON RefundQ.Customer_Id = Filter.CustomerId
     LIMIT 1