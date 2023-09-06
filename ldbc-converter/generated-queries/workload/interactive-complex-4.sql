/* Q4. New topics
\set personId 10995116277918
\set startDate '\'2010-10-01\''::date
\set durationDays 31
 */
SET client_min_messages = debug5;
EXPLAIN (ANALYZE, FORMAT JSON)
select t_name, count(*) as postCount
from tag, (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
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
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as message, message_tag recent, knows
where
    m_messageid = mt_messageid and
    mt_tagid = t_tagid and
    m_creatorid = k_person2id and
    m_c_replyof IS NULL and -- post, not comment
    k_person1id = 21990232559429 and
    m_creationdate >= to_timestamp(1335830400000/1000)::date and
    m_creationdate < (to_timestamp(1335830400000/1000)::date + INTERVAL '1 days' * 37) and
    not exists (
        select * from
  (select distinct mt_tagid from (SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
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
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment) as message, message_tag, knows
        where
    k_person1id = 21990232559429 and
        k_person2id = m_creatorid and
        m_c_replyof IS NULL and -- post, not comment
        mt_messageid = m_messageid and
        m_creationdate < to_timestamp(1335830400000/1000)::date) tags
  where  tags.mt_tagid = recent.mt_tagid)
group by t_name
order by postCount desc, t_name asc
limit 10
;
