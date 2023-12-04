USE clinicSystemDB;

INSERT INTO clinic(_name, email, _desc)
VALUES('Phòng Khám Bách Khoa', 'pkbk@gmail.com', 'Phòng khám số một Đông Lào');

INSERT INTO room(num, clinic_id, _name, _desc, _status)
VALUES(123, 1, 'Khám tổng thể', '???', 'HOẠT ĐỘNG');

INSERT INTO room(num, clinic_id, _name, _desc, _status)
VALUES(13223, 1, 'Khám tổng thể1', '???', 'HOẠT ĐỘNG');

INSERT INTO room(num, clinic_id, _name, _desc, _status)
VALUES(12123, 1, 'Khám tổng thể2', '???', 'HOẠT ĐỘNG');

INSERT INTO room(num, clinic_id, _name, _desc, _status)
VALUES(12213, 1, 'Khám tổng thể3', '???', 'HOẠT ĐỘNG');

SELECT *
FROM clinic;


DELETE 
FROM clinic
WHERE clinic.id IN (SELECT id FROM clinic);


DELETE 
FROM room
WHERE room.num = 123;
DELETE 
FROM room
WHERE room.num = 13223;
DELETE 
FROM room
WHERE room.num = 12123;
DELETE 
FROM room
WHERE room.num = 12213;


DELETE 
FROM clinic
WHERE clinic.id IN (SELECT id FROM clinic);


