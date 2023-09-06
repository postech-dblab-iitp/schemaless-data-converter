EXPLAIN (ANALYZE, FORMAT JSON)
select p_personid, p_firstname, p_lastname, k_creationdate
from knows, 
((SELECT p_personid, p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p1) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p2) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p3) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p4) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p5)) as person
where k_person1id = 933 and k_person2id = p_personid
order by k_creationdate desc, p_personid asc;