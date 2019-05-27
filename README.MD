--------------------------
CONFIG:
--------------------------

A config folder containing default.asp is required holding private values

<%
'// Connection string for Database access
    Const strConn = "Provider=MSDASQL;Driver={MySQL ODBC 8.0 Unicode Driver}; Server={{DB_SERVER}; Database={{DATABASE_NAME}; UID={{DB_USERNAME}; PWD={{DB_PASSWORD}; Option=3;"

'// Site-wide salt for password hashing
    Const strSiteSalt = "{{SITE_SALT_KEY}}"

'// Secret key for JSON Web Tokens
    Const jwtSecret = "{{JWT_SECRET}}"
%>


--------------------------
DATABASE
--------------------------

A RMDBS such as MySQL is required to store USER credentials, and a Stored Procedure for adding users, and returning the created ID

USE `password_hash`;
CREATE TABLE `password_hash`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `salt` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`));


DROP procedure IF EXISTS `password_hash`.`sp_insert_new_user`;
DELIMITER $$
USE `password_hash`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `password_hash`.`sp_insert_new_user`(p_email VARCHAR(255), p_hash VARCHAR(45), p_password VARCHAR(255))
BEGIN
	DECLARE v_output INT(11);
    INSERT INTO user (`email`, `hash`, `password`) VALUES (p_email, p_hash, p_password);
    SELECT LAST_INSERT_ID() as id;
END$$

    -- Example :
	-- call sp_insert_new_user('test@test.com', '7a3a6a99bf8c467ab0ed7e2e775f0a70', '7AeGGULx5l3N3ip3ofT9Hlw9p9TGr19sI8tgRJsaquB8uhM2XK745+YjI/Xe3i/CpB+NnJIOvNRX6pgTsXEz2g==');

DELIMITER ;


--------------------------
REFERENCES:
--------------------------
https://amadiere.com/blog/2011/2/c-net-classic-asp-password-hashing
Thanks for SHA512 handling

