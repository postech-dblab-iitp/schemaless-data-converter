create table post_p1 (
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_ps_language varchar,
    m_content text
);

create table post_p2 (
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_ps_language varchar,
    m_length int not null
);

create table post_p3 (
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_ps_language varchar,
    m_creatorid bigint not null
);

create table post_p4 (
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_ps_language varchar,
    m_ps_forumid bigint
);

create table post_p5 (
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_ps_language varchar,
    m_locationid bigint not null
);

create table comment_p1 (
    m_messageid bigint not null,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text,
    m_length int not null
);

create table comment_p2 (
    m_messageid bigint not null,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text,
    m_creatorid bigint not null
);

create table comment_p3 (
    m_messageid bigint not null,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text,
    m_locationid bigint not null
);

create table comment_p4 (
    m_messageid bigint not null,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text,
    m_replyof_post bigint
);

create table comment_p5 (
    m_messageid bigint not null,
    m_creationdate timestamp with time zone not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text,
    m_replyof_comment bigint
);

create table forum_p1 (
   f_forumid bigint not null,
   f_title varchar not null,
   f_moderatorid bigint not null
);

create table forum_p2 (
   f_forumid bigint not null,
   f_title varchar not null,
   f_creationdate timestamp with time zone not null
);

create table forum_person_p1 (
   fp_forumid bigint not null,
   fp_personid bigint not null,
   fp_joindate timestamp with time zone not null
);

create table forum_person_p2 (
   fp_forumid bigint not null,
   fp_personid bigint not null
);

create table forum_tag (
   ft_forumid bigint not null,
   ft_tagid bigint not null
);

create table organisation (
   o_organisationid bigint not null,
   o_type varchar not null,
   o_name varchar not null,
   o_url varchar not null,
   o_placeid bigint not null
);

create table person_p1 (
   p_personid bigint not null,
   p_firstname varchar not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid bigint not null
);

create table person_p2 (
   p_personid bigint not null,
   p_lastname varchar not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid bigint not null
);

create table person_p3 (
   p_personid bigint not null,
   p_gender varchar not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid bigint not null
);

create table person_p4 (
   p_personid bigint not null,
   p_birthday date not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid bigint not null
);

create table person_p5 (
   p_personid bigint not null,
   p_creationdate timestamp with time zone not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid bigint not null
);

create table person_email (
   pe_personid bigint not null,
   pe_email varchar not null
);


create table person_tag (
   pt_personid bigint not null,
   pt_tagid bigint not null
);

create table knows (
   k_person1id bigint not null,
   k_person2id bigint not null,
   k_creationdate timestamp with time zone not null
);

create table likes (
   l_personid bigint not null,
   l_messageid bigint not null,
   l_creationdate timestamp with time zone not null
);

create table person_language (
   plang_personid bigint not null,
   plang_language varchar not null
);

create table person_university (
   pu_personid bigint not null,
   pu_organisationid bigint not null,
   pu_classyear int not null
);

create table person_company (
   pc_personid bigint not null,
   pc_organisationid bigint not null,
   pc_workfrom int not null
);

create table place (
   pl_placeid bigint not null,
   pl_name varchar not null,
   pl_url varchar not null,
   pl_type varchar not null,
   pl_containerplaceid bigint -- null for continents
);

create table message_tag (
   mt_messageid bigint not null,
   mt_tagid bigint not null
);

create table tagclass (
   tc_tagclassid bigint not null,
   tc_name varchar not null,
   tc_url varchar not null,
   tc_subclassoftagclassid bigint -- null for the root tagclass (Thing)
);

create table tag (
   t_tagid bigint not null,
   t_name varchar not null,
   t_url varchar not null,
   t_tagclassid bigint not null
);
