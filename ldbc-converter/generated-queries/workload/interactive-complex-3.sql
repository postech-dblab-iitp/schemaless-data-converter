/* Q3. Friends and friends of friends that have been to given countries
\set personId 6597069766734
\set countryXName '\'Angola\''
\set countryYName '\'Colombia\''
\set startDate '\'2010-06-01\''::date
\set durationDays 28
 */
SET client_min_messages = debug5;
EXPLAIN (ANALYZE, FORMAT JSON)
select p_personid, p_firstname, p_lastname, ct1, ct2, total as totalcount
from
 ( select k_person2id
   from knows
   where
   k_person1id = 17592186055119
   union
   select k2.k_person2id
   from knows k1, knows k2
   where
   k1.k_person1id = 17592186055119 and k1.k_person2id = k2.k_person1id and k2.k_person2id <> 17592186055119
 ) f,  ((SELECT p_personid, p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p1) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, p_lastname, NULL as p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p2) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, p_gender, NULL as p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p3) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, p_birthday, NULL as p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p4) 
 UNION ALL 
(SELECT p_personid, NULL as p_firstname, NULL as p_lastname, NULL as p_gender, NULL as p_birthday, p_creationdate, p_locationip, p_browserused, p_placeid FROM person_p5)) as person, place p1, place p2,
 (
  select chn.m_c_creatorid, ct1, ct2, ct1 + ct2 as total
  from
   (
      select m_creatorid as m_c_creatorid, count(*) as ct1 from (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
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
      (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as message, place
      where
        m_locationid = pl_placeid and pl_name = 'Laos' and
        m_creationdate >= to_timestamp(1306886400000/1000)::date and  m_creationdate < (to_timestamp(1306886400000/1000)::date + INTERVAL '1 days' * 42)
      group by m_c_creatorid
   ) chn,
   (
      select m_creatorid as m_c_creatorid, count(*) as ct2 from (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
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
      (SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as message, place
      where
        m_locationid = pl_placeid and pl_name = 'Scotland' and
        m_creationdate >= to_timestamp(1306886400000/1000)::date and  m_creationdate < (to_timestamp(1306886400000/1000)::date + INTERVAL '1 days' * 42)
      group by m_creatorid --m_c_creatorid
   ) ind
  where CHN.m_c_creatorid = IND.m_c_creatorid
 ) cpc
where
f.k_person2id = p_personid and p_placeid = p1.pl_placeid and
p1.pl_containerplaceid = p2.pl_placeid and p2.pl_name <> 'Laos' and p2.pl_name <> 'Laos' and
f.k_person2id = cpc.m_c_creatorid
order by totalcount desc, p_personid asc
limit 20
;
