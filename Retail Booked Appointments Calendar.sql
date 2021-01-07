SELECT DATE (Appointment_Date,"America/Mexico_City") Date, Appointment_Status,
    
    
    SUM(CASE
        WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Monterrey" THEN 1 
    ELSE 0
    END) AS Monterrey,
    SUM(CASE
        WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Puebla" THEN 1 
    ELSE 0
    END) AS Puebla,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Guadalajara" THEN 1 
    ELSE 0
    END) AS Guadalajara,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Medellín" THEN 1 
    ELSE 0
    END) AS Medellin,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Cancún" THEN 1 
    ELSE 0
    END) AS Cancun,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas León" THEN 1 
    ELSE 0
    END) AS Leon,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Satelite" THEN 1 
    ELSE 0
    END) AS Satelite,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Querétaro" THEN 1 
    ELSE 0
    END) AS Queretaro,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Insurgentes Napoles" THEN 1 
    ELSE 0
    END) AS Insurgentes_Napoles,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Bogotá - Galerias" THEN 1 
    ELSE 0
    END) AS Bogota_Galerias,
    SUM(CASE
    WHEN Appointment_Calendar IS NOT NULL AND Appointment_Calendar = "Citas Bogotá" THEN 1 
    ELSE 0
    END) AS Bogota,
FROM dbmoonsprod.DealAppointment
WHERE DATE(Appointment_Date, "America/Mexico_City") >= PARSE_DATE('%Y%m%d', @DS_START_DATE) AND DATE(Appointment_Date, "America/Mexico_City") <= PARSE_DATE('%Y%m%d', @DS_END_DATE)
    
ORDER BY Date DESC
LIMIT 2