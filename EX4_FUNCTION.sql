DELIMITER //
CREATE FUNCTION totalRevenue(
	clinic_id 	INT,
    begin_date	DATE,
    end_date 	DATE
)
RETURNS INT
BEGIN
	DECLARE totalRevenue INT;
    
	SELECT SUM(B.total_price) INTO totalRevenue
    FROM bill AS B
    WHERE 	B.ispaid = TRUE 
			AND B.clinic_id = clinic_id
			AND begin_date <= B._timestamp 
            AND B._timestamp <= end_date;

	RETURN totalRevenue;
END
//


DELIMITER ;