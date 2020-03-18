PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
SET @a = 5;
SET @b = 12;
EXECUTE stmt1 USING @a, @b;
SET @a = 4;
SET @b = 3;
EXECUTE stmt1 USING @a, @b;