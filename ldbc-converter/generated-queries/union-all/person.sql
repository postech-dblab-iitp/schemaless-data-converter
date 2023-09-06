((SELECT p_personid, p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p1) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p2) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p3) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p4) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p5)) as person