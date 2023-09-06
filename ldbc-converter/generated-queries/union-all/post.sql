((SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p1) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, m_length, NULL as m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p2) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, m_creatorid, NULL as m_ps_forumid, NULL as m_locationid FROM post_p3) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, m_ps_forumid, NULL as m_locationid FROM post_p4) 
 UNION ALL 
(SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, NULL as m_content, NULL as m_length, NULL as m_creatorid, NULL as m_ps_forumid, m_locationid FROM post_p5)) as post