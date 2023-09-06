((SELECT fp_forumid, fp_personid, fp_joindate FROM forum_person_p1) 
 UNION ALL 
(SELECT fp_forumid, fp_personid, NULL as fp_joindate FROM forum_person_p2)) as forum_person