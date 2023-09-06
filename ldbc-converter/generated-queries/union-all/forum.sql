((SELECT f_forumid, f_title, NULL as f_creationdate, f_moderatorid FROM forum_p1) 
 UNION ALL 
(SELECT f_forumid, f_title, f_creationdate, NULL as f_moderatorid FROM forum_p2)) as forum