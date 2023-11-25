CREATE DATABASE IF NOT EXISTS clinicSystemDB;
USE clinicSystemDB;

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS clinic
(
	id					INT 				AUTO_INCREMENT,
    _name				VARCHAR(50)			UNIQUE,
    worktime 			VARCHAR(100)		NOT NULL,
    email    			VARCHAR(50)			NOT NULL,
    _desc				VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS room
(
	num					INT,
    clinic_id			INT,
    _name				VARCHAR(50)			NOT NULL,
	_desc				VARCHAR(200),
    _status				VARCHAR(50)			NOT NULL,
    doctor_id 			INT,
    
    PRIMARY KEY (num, clinic_id),
    
    CONSTRAINT room_check_1 CHECK (_status = "KHÔNG HOẠT ĐỘNG" OR _status = "HOẠT ĐỘNG"),
    
	CONSTRAINT fk_room_doctor_id FOREIGN KEY (doctor_id)
		REFERENCES doctor(id) 
		ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS appointment
(
	id 					INT 				AUTO_INCREMENT,
    _time				TIME				NOT NULL,
    _date				DATE				NOT NULL,
	cur_people			INT					NOT NULL DEFAULT 0,
    max_people			INT					NOT NULL,
    _status	 			INT					NOT NULL,
    clinic_id			INT,
    
    PRIMARY KEY (id),
    
    CONSTRAINT appointment_check_1 
		CHECK (cur_people >= 0),
	CONSTRAINT appointment_check_2
		CHECK (max_people >= 0),    
    
    CONSTRAINT fk_appointment_clinic_id FOREIGN KEY (clinic_id)
		REFERENCES clinic(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS _user
(
	id 					INT					AUTO_INCREMENT,
    fullname			TIME				NOT NULL,
    gender				BOOL				NOT NULL,
	birthdate			DATE				NOT NULL,
    addr				VARCHAR(50),
    email 				VARCHAR(50),
    phone				VARCHAR(15)			NOT NULL,
    is_active			BOOL				NOT NULL DEFAULT TRUE,
    username			VARCHAR(50)			UNIQUE,
    _password			VARCHAR(50)			NOT NULL,
    
    CONSTRAINT user_check_1
		CHECK (gender = "NAM" OR gender = "NỮ"),
    
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS patient
(
	id 					INT 				PRIMARY KEY,
    
    CONSTRAINT fk_patient_id FOREIGN KEY (id)
		REFERENCES _user(id) 
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS medical_staff
(
	id 					INT 				PRIMARY KEY,
    start_date 			DATE				DEFAULT CURRENT_TIMESTAMP,
    YOE 				INT					NOT NULL,
    license_number 		VARCHAR(50)			NOT NULL,
    salary 				INT					NOT NULL,
    
    CONSTRAINT medical_staff_check_1 
		CHECK (YOE >= 0),
        
	CONSTRAINT medical_staff_check_2
		CHECK (salary >= 0),
    
    CONSTRAINT fk_medical_staff_id 			FOREIGN KEY (id)
		REFERENCES _user(id) 
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS doctor
(
	id 					INT 				PRIMARY KEY,
    specialty			VARCHAR(50)			NOT NULL,
    
    CONSTRAINT fk_doctor_id FOREIGN KEY (id)
		REFERENCES medical_staff(id) 
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS  nurse
(
	id 					INT 				PRIMARY KEY,
    
    CONSTRAINT fk_nurse_id FOREIGN KEY (id)
		REFERENCES medical_staff(id) 
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS examination
(
	id 					INT 				PRIMARY KEY,
    diagnose 			VARCHAR(100)		NOT NULL,
    _desc 				VARCHAR(50),
    image 				VARCHAR(100),
    doctor_id			INT,
    patient_id 			INT,
    app_id 				INT,
    bill_id				INT,
    service_id			INT,
    
	CONSTRAINT fk_examination_doctoc_id 	FOREIGN KEY (doctor_id)
		REFERENCES doctor(id) 					
		ON DELETE SET NULL,
    CONSTRAINT fk_examination_patient_id 	FOREIGN KEY (patient_id)
		REFERENCES patient(id) 					
		ON DELETE SET NULL,
    CONSTRAINT fk_examination_app_id 		FOREIGN KEY (app_id)
		REFERENCES appointment(id) 				
        ON DELETE SET NULL,
    CONSTRAINT fk_examination_bill_id 		FOREIGN KEY (bill_id)
		REFERENCES bill(id) 					
        ON DELETE SET NULL,
    CONSTRAINT fk_examination_service_id 	FOREIGN KEY (service_id)
		REFERENCES service(id) 					
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS bill
(
	id 					INT					AUTO_INCREMENT,		
    _status 			BOOL				NOT NULL DEFAULT FALSE, /* 0: Not pay yet, 1: Paid */
    _timestamp 			TIMESTAMP 			NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS medicine
(
	serial_num 			VARCHAR(50) 		PRIMARY KEY,
    _name 				VARCHAR(50)			NOT NULL,
    cost 				INT					NOT NULL,
    _desc 				VARCHAR(50),
    
    CONSTRAINT medicine_check_1	
		CHECK (cost > 0)
		
);

CREATE TABLE IF NOT EXISTS service
(
	id					INT					PRIMARY KEY,
    _name 				VARCHAR(50)			NOT NULL,
    cost 				INT					NOT NULL,
    _desc 				VARCHAR(50),
    
    CONSTRAINT service_check_1
		CHECK (cost > 0)
);

CREATE TABLE IF NOT EXISTS work_at
(
	ms_id 				INT					PRIMARY KEY,
    room_num 			INT,
    clinic_id 			INT,
    
    CONSTRAINT fk_work_at_ms_id					FOREIGN KEY (ms_id)
		REFERENCES medical_staff(id)				
        ON DELETE CASCADE,
    
    CONSTRAINT fk_work_at_room_num_clinic_id	FOREIGN KEY (room_num, clinic_id)
		REFERENCES room(num, clinic_id)				
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS work_with
(
	nurse_id 			INT						PRIMARY KEY,
    doctor_id 			INT,
    
    CONSTRAINT fk_work_with_nurse_id 			FOREIGN KEY (nurse_id)
		REFERENCES nurse(id)						
        ON DELETE CASCADE,
        
    CONSTRAINT fk_work_with_doctoc_id 			FOREIGN KEY (doctor_id)
		REFERENCES doctor(id)						
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS app_of_patient
(
	patient_id 			INT,
    app_id 				INT,
    _status 			VARCHAR(50),
    
    PRIMARY KEY (patient_id, app_id),
    
    CONSTRAINT app_of_patient_check_1
		CHECK (_status ="CHƯA XÁC NHẬN" OR _status ="ĐÃ XÁC NHẬN" OR _status="KẾT THÚC"),
    
    CONSTRAINT fk_app_of_patient_patient_id 	FOREIGN KEY (patient_id)
		REFERENCES patient(id) 						
        ON DELETE CASCADE,
    
    CONSTRAINT fk_app_of_patient_app_id 		FOREIGN KEY (app_id)
		REFERENCES appointment(id) 					
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS medicine_in_clinic
(
	clinic_id 			INT,
    serial_num 			VARCHAR(50),
    quantity 			INT					NOT NULL DEFAULT 0,
    
    CONSTRAINT medicine_in_clinic_check_1
		CHECK (quantity >= 0),
    
    PRIMARY KEY (clinic_id, serial_num),
    
    CONSTRAINT fk_medicine_in_clinic_clinic_id 		FOREIGN KEY (clinic_id)
		REFERENCES clinic(id) 							
        ON DELETE CASCADE,
    
    CONSTRAINT fk_medicine_in_clinic_serial_num 	FOREIGN KEY (serial_num)
		REFERENCES medicine(serial_num) 				
        ON DELETE CASCADE,
    
    CHECK (quantity > 0)
);

CREATE TABLE IF NOT EXISTS prescription
(
	exam_id 			INT,
    serial_num			VARCHAR(50),
    _desc				VARCHAR(50),
    quantity 			INT					NOT NULL DEFAULT 0,
    
	PRIMARY KEY (exam_id, serial_num),
    
    CONSTRAINT medicine_in_clinic_check_1
		CHECK (quantity >= 0),
    
    CONSTRAINT fk_prescription_exam_id			FOREIGN KEY (exam_id)
		REFERENCES examination(id)					
        ON DELETE CASCADE,
    
    CONSTRAINT fk_prescription_serial_num 		FOREIGN KEY (serial_num)
		REFERENCES medicine(serial_num)				
        ON DELETE SET NULL,
    
    CHECK (quantity > 0)
);

CREATE TABLE IF NOT EXISTS clinic_hotline(
	clinic_id 			INT,
    hotline				INT,
    
    PRIMARY KEY (clinic_id, hotline),
    
    CONSTRAINT fk_clinic_hotline_clinic_id 		FOREIGN KEY (clinic_id)
		REFERENCES clinic(id) 						
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS patient_allergy(
	patient_id 			INT,
    allergy				INT,
    
    PRIMARY KEY (patient_id, allergy),
    
    CONSTRAINT fk_patient_allergy_patient_id 	FOREIGN KEY (patient_id)
		REFERENCES patient(id) 						
        ON DELETE CASCADE
);

SET FOREIGN_KEY_CHECKS=1;
