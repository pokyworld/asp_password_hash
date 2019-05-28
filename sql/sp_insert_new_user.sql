USE `password_hash`;
DROP procedure IF EXISTS `sp_insert_new_user`;

DELIMITER $$
USE `password_hash`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_new_user`(p_email VARCHAR(255), p_salt VARCHAR(45), p_password VARCHAR(255))
BEGIN
	DECLARE v_output INT(11);
    INSERT INTO user (`email`, `salt`, `password`) VALUES (p_email, p_salt, p_password);
    SELECT LAST_INSERT_ID() as id;
END$$
	-- Based on : password@1W
	-- call sp_insert_new_user('test@test.com', '7a3a6a99bf8c467ab0ed7e2e775f0a70', '7AeGGULx5l3N3ip3ofT9Hlw9p9TGr19sI8tgRJsaquB8uhM2XK745+YjI/Xe3i/CpB+NnJIOvNRX6pgTsXEz2g==');

DELIMITER ;
