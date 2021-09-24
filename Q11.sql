-- Retrieve data from temporal table using FOR SYSTEM_TIME
-- Becuase some cities existed before 2015 but were updated after 2015, use CONTAINED IN

SELECT DISTINCT CityID FROM WideWorldImporters.Application.Cities 
FOR SYSTEM_TIME CONTAINED IN ('2015-01-01' , '9999-12-31 23:59:59.9999999');