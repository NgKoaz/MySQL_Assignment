USE clinicSystemDB;

CALL insertUser('Khoa', 
				'Đăng', 
                'Nguyễn', 
                'KHÁC', 
                '22-07-203', 
                'Gần KTX khu A', 
                'nguyendskhodsa@gmail.com', 
                '0905077025', 
                'nguyendsddsdskh232oa', 
                'passwordlỏ');
SELECT *
FROM _user;