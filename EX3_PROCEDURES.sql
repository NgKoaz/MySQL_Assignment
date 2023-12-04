DELIMITER //
CREATE PROCEDURE numberOfRoom(
	IN clinic_id INT
)
BEGIN
    SELECT c.id, c._name, COUNT(*)
    FROM clinic AS c, room AS r
    WHERE c.id = r.clinic_id
    GROUP BY c.id;
END //


CREATE


CREATE PROCEDURE historyExamination(
	IN username VARCHAR(50)
)
BEGIN
	DECLARE userId INT;
	
    -- Find userId by using username;
	SELECT id INTO userId;
    FROM _user
    WHERE _user.username = username;
    IF userId IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tìm thấy tài khoản!';
    END IF;
    
    -- Find patientId by using userId, 
    -- check whether user is exists or a patient.
    DECLARE patientId INT;
    
    SELECT id INTO patientId
    FROM patient
    WHERE patient.id = userId;
    IF patientId IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tìm thấy bệnh nhân!';
    END IF;
    
	SELECT SUM()
    FROM examination
    WHERE examination.patient_id = patientId
    GROUP BY bill_id
    
    
END
DELIMITER ;