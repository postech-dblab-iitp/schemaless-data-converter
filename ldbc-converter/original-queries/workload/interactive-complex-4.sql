/* Q4. New topics
\set personId 10995116277918
\set startDate '\'2010-10-01\''::date
\set durationDays 31
 */
EXPLAIN (ANALYZE, FORMAT JSON)
select m_creationdate, count(*) as postCount
from tag, message, message_tag recent, knows
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
  (select distinct mt_tagid from message, message_tag, knows
        where
    k_person1id = 21990232559429 and
        k_person2id = m_creatorid and
        m_c_replyof IS NULL and -- post, not comment
        mt_messageid = m_messageid and
        m_creationdate < to_timestamp(1335830400000/1000)::date) tags
  where  tags.mt_tagid = recent.mt_tagid)
group by m_creationdate
order by postCount desc, m_creationdate asc
limit 10
;
