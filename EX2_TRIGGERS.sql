USE clinicSystemDB;

DELIMITER //
CREATE TRIGGER preventClinicDeletion
BEFORE DELETE ON clinic
FOR EACH ROW
BEGIN
    DECLARE clinic_count INT;
    
    -- Kiểm tra có phòng nào liên quan đến clinic này hay không.
    SELECT COUNT(*) INTO clinic_count
    FROM room
    WHERE clinic_id = OLD.id;
    
    -- Nếu còn không xóa
    IF clinic_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa hàng Clinic vì còn liên quan đến bảng Room';
    END IF;
END //


CREATE TRIGGER totalCostExamination
AFTER INSERT ON examination
FOR EACH ROW
BEGIN
    DECLARE total_cost INT;
    
    SELECT SUM(cost) INTO total_cost
    FROM service
    WHERE service.id = NEW.bill_id;
	
    UPDATE examination
    SET examination.total_cost = total_cost
    WHERE examination.id = NEW.id;
END //


CREATE TRIGGER increaseCurrentPeople
BEFORE INSERT ON patient_appointment
FOR EACH ROW
BEGIN
	DECLARE current_people INT;
    DECLARE max_people INT;
    
    SELECT cur_people, max_people INTO current_people, max_people
    FROM appointment AS A
    WHERE A.id = NEW.app_id;
    
    IF current_people + 1 > max_people THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Quá số lượng người đặt lịch hẹn!";
    END IF;
    
    UPDATE appointment AS A
    SET A.cur_people = currentPeople + 1
	WHERE A.id = NEW.app_id;
END //


CREATE TRIGGER decreaseCurrentPeople
BEFORE DELETE ON patient_appointment
FOR EACH ROW
BEGIN
	DECLARE current_people INT;
    
    IF current_people <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Không xóa được vì lỗi ở Database! Lỗi: Số người sau khi xóa sẽ là số âm!";
    END IF;
    
    UPDATE appointment AS A
    SET A.cur_people = currentPeople - 1
	WHERE A.id = OLD.app_id;
END //


CREATE TRIGGER costForExamination
BEFORE INSERT ON examination
FOR EACH ROW
BEGIN
	DECLARE totalCost INT;
    
	SELECT SUM(P.quantity * M.cost) INTO totalCost
    FROM medicine AS M, (SELECT *
						FROM prescription
						WHERE prescription.exam_id = NEW.id) AS P
    WHERE M.serial_num = P.serial_num;
	
	SET NEW.total_price = totalCost;

END //






DELIMITER ;