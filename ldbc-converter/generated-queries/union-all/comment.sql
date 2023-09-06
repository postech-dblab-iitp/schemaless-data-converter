((SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p1) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, m_creatorid, NULL as m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p2) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, m_locationid, NULL as m_replyof_post, NULL as m_replyof_comment FROM comment_p3) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, m_replyof_post, NULL as m_replyof_comment FROM comment_p4) 
 UNION ALL 
(SELECT m_messageid, m_creationdate, m_locationip, m_browserused, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_locationid, NULL as m_replyof_post, m_replyof_comment FROM comment_p5)) as comment