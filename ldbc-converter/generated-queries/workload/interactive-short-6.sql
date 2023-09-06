WITH RECURSIVE chain(parent, child) as(
    SELECT m_c_replyof, m_messageid FROM (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
    FROM ((SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p1) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p2) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p3) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, m_ps_forumid, NULL as m_locationid FROM post_p4) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, m_locationid FROM post_p5)) as post
    UNION ALL
    SELECT m_messageid, NULL, m_creationdate, m_locationip, m_browserused, NULL, m_content, m_length, m_creatorid, m_locationid, NULl, coalesce(m_replyof_post, m_replyof_comment)
    FROM ((SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p1) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p2) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p3) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, m_replyof_post, NULL as m_replyof_comment FROM comment_p4) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as message where m_messageid = 824635044686
    UNION ALL
    SELECT p.m_c_replyof, p.m_messageid FROM 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
    FROM ((SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p1) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p2) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p3) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, m_ps_forumid, NULL as m_locationid FROM post_p4) 
    UNION ALL 
    (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, m_locationid FROM post_p5)) as post
    UNION ALL
    SELECT m_messageid, NULL, m_creationdate, m_locationip, m_browserused, NULL, m_content, m_length, m_creatorid, m_locationid, NULl, coalesce(m_replyof_post, m_replyof_comment)
    FROM ((SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p1) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p2) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p3) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, m_replyof_post, NULL as m_replyof_comment FROM comment_p4) 
    UNION ALL 
    (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as p, chain c where p.m_messageid = c.parent 
)
select f_forumid, f_title, p_personid, p_firstname, p_lastname
from 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
FROM ((SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p1) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p2) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p3) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, m_ps_forumid, NULL as m_locationid FROM post_p4) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, m_locationid FROM post_p5)) as post
UNION ALL
SELECT m_messageid, NULL, m_creationdate, m_locationip, m_browserused, NULL, m_content, m_length, m_creatorid, m_locationid, NULl, coalesce(m_replyof_post, m_replyof_comment)
FROM ((SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p1) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p2) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p3) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, m_replyof_post, NULL as m_replyof_comment FROM comment_p4) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as message, 
((SELECT p_personid, p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p1) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p2) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p3) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p4) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p5)) as person, 
((SELECT f_forumid, f_title, NULL as f_creationdate, f_moderatorid FROM forum_p1) 
 UNION ALL 
(SELECT f_forumid, f_title, f_creationdate, NULL as f_moderatorid FROM forum_p2)) as forum
where m_messageid = (select coalesce(min(parent), 824635044686) from chain)
  and m_ps_forumid = f_forumid and f_moderatorid = p_personid;
