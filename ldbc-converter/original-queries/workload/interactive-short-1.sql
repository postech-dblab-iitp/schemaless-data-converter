/* IS1. Profile of a person
\set personId 10995116277794
 */
select p_firstname, p_lastname, p_birthday, p_locationip, p_browserused, p_placeid, p_gender,  p_creationdate
from person
where p_personid = :personId;
;
