DROP FUNCTION IF EXISTS isValidEmail;
DROP FUNCTION IF EXISTS isValidPhoneNumber;


DROP PROCEDURE IF EXISTS insertUser;
DROP PROCEDURE IF EXISTS updateNameByUsername;
DROP PROCEDURE IF EXISTS updateGenderByUsername;
DROP PROCEDURE IF EXISTS updateBirthdateByUsername;
DROP PROCEDURE IF EXISTS updateAddressByUsername;
DROP PROCEDURE IF EXISTS updateEmailByUsername;
DROP PROCEDURE IF EXISTS updatePhoneNumByUsername;
DROP PROCEDURE IF EXISTS updatePasswordByUsername;
DROP PROCEDURE IF EXISTS deleteUserByUsername;
DROP PROCEDURE IF EXISTS deleteUserById;


DROP TRIGGER IF EXISTS preventClinicDeletion;
DROP TRIGGER IF EXISTS totalCostExamination;
