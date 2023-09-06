-- Define the base path variable
\set base_path '/home/schemaless-data-generator/ldbc-converter/generated-dataset'

-- Populate forum table
COPY forum_p1 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/forum_0_0_p1.csv' WITH DELIMITER '|';
COPY forum_p2 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/forum_0_0_p2.csv' WITH DELIMITER '|';

-- Populate forum_person table
COPY forum_person_p1 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/forum_hasMember_person_0_0_p1.csv' WITH DELIMITER '|';
COPY forum_person_p2 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/forum_hasMember_person_0_0_p2.csv' WITH DELIMITER '|';

-- Populate forum_tag table
COPY forum_tag FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/forum_hasTag_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate organisation table
COPY organisation FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/static/organisation_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate person table
COPY person_p1 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/person_0_0_p1.csv' WITH DELIMITER '|';
COPY person_p2 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/person_0_0_p2.csv' WITH DELIMITER '|';
COPY person_p3 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/person_0_0_p3.csv' WITH DELIMITER '|';
COPY person_p4 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/person_0_0_p4.csv' WITH DELIMITER '|';
COPY person_p5 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/person_0_0_p5.csv' WITH DELIMITER '|';

-- Populate person_email table
COPY person_email FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_email_emailaddress_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate person_tag table
COPY person_tag FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_hasInterest_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate knows table
COPY knows ( k_person1id, k_person2id, k_creationdate) FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_knows_person_0_0.csv' WITH DELIMITER '|' CSV HEADER;
COPY knows ( k_person2id, k_person1id, k_creationdate) FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_knows_person_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate likes table
COPY likes FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_likes_post_0_0.csv' WITH DELIMITER '|' CSV HEADER;
COPY likes FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_likes_comment_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate person_language table
COPY person_language FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_speaks_language_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate person_university table
COPY person_university FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_studyAt_organisation_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate person_company table
COPY person_company FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/person_workAt_organisation_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate place table
COPY place FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/static/place_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate message_tag table
COPY message_tag FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/post_hasTag_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;
COPY message_tag FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/dynamic/comment_hasTag_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate tagclass table
COPY tagclass FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/static/tagclass_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- Populate tag table
COPY tag FROM '/home/schemaless-data-generator/ldbc-converter/original-dataset/static/tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

CREATE TABLE country AS
    SELECT city.pl_placeid AS ctry_city, ctry.pl_name AS ctry_name
    FROM place city, place ctry
    WHERE city.pl_containerplaceid = ctry.pl_placeid
      AND ctry.pl_type = 'country';

-- Populate posts and comments tables, union them into message
COPY post_p1 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/post_0_0_p1.csv' WITH DELIMITER '|';
COPY post_p2 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/post_0_0_p2.csv' WITH DELIMITER '|';
COPY post_p3 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/post_0_0_p3.csv' WITH DELIMITER '|';
COPY post_p4 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/post_0_0_p4.csv' WITH DELIMITER '|';
COPY post_p5 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/post_0_0_p5.csv' WITH DELIMITER '|';
COPY comment_p1 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/comment_0_0_p1.csv' WITH DELIMITER '|';
COPY comment_p2 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/comment_0_0_p2.csv' WITH DELIMITER '|';
COPY comment_p3 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/comment_0_0_p3.csv' WITH DELIMITER '|';
COPY comment_p4 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/comment_0_0_p4.csv' WITH DELIMITER '|' CSV HEADER;
COPY comment_p5 FROM '/home/schemaless-data-generator/ldbc-converter/generated-dataset/dynamic/comment_0_0_p5.csv' WITH DELIMITER '|' CSV HEADER;

-- Note: to distinguish between "post" and "comment" records:
--   - m_c_replyof IS NULL for all "post" records
--   - m_c_replyof IS NOT NULL for all "comment" records
-- CREATE TABLE message AS
--     SELECT m_messageid, m_ps_imagefile, m_creationdate, m_locationip, m_browserused, m_ps_language, m_content, m_length, m_creatorid, m_locationid, m_ps_forumid, NULL AS m_c_replyof
--     FROM post
--     UNION ALL
--     SELECT m_messageid, NULL, m_creationdate, m_locationip, m_browserused, NULL, m_content, m_length, m_creatorid, m_locationid, NULl, coalesce(m_replyof_post, m_replyof_comment)
--     FROM comment;

-- DROP TABLE post;
-- DROP TABLE comment;
