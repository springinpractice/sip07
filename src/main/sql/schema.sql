drop database if exists sip07;
create database sip07;
use sip07;


-- =====================================================================================================================
-- Domain tables
-- =====================================================================================================================

create table account (
    id int unsigned not null auto_increment primary key,
    username varchar(50) not null,
    password varchar(50) not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(50) not null,
    enabled boolean not null,
    unique index account_idx1 (username)
) engine = InnoDb;

create table role (
    id smallint unsigned not null auto_increment primary key,
    name varchar(50) not null
) engine = InnoDb;

create table permission (
    id smallint unsigned not null auto_increment primary key,
    name varchar(50) not null
) engine = InnoDb;

create table account_role (
    id int unsigned not null auto_increment primary key,
    account_id int unsigned not null,
    role_id smallint unsigned not null,
    foreign key (account_id) references account (id),
    foreign key (role_id) references role (id),
    unique index account_role_idx1 (account_id, role_id)
) engine = InnoDb;

create table role_permission (
    id smallint unsigned not null auto_increment primary key,
    role_id smallint unsigned not null,
    permission_id smallint unsigned not null,
    foreign key (role_id) references role (id),
    foreign key (permission_id) references permission (id),
    unique index role_permission_idx1 (role_id, permission_id)
) engine = InnoDb;

create table forum (
    id smallint unsigned not null auto_increment primary key,
    name varchar(250) not null,
    owner_id int unsigned not null,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    foreign key (owner_id) references account (id),
    unique index forum_idx1 (name)
) engine = InnoDb;

create table message (
    id int unsigned not null auto_increment primary key,
    forum_id smallint unsigned not null,
    subject varchar(250) not null,
    author_id int unsigned not null,
    text text(8000) not null,
    visible boolean not null default 1,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    foreign key (forum_id) references forum (id),
    foreign key (author_id) references account (id),
    index message_idx1 (date_created)
) engine = InnoDb;


-- ============================================================================
-- ACL tables
-- ============================================================================

create table acl_sid (
    id int unsigned not null auto_increment primary key,
    principal boolean not null,
    sid varchar(100) not null,
    unique index acl_sid_idx_1 (sid, principal)
) engine = InnoDb;

create table acl_class (
    id smallint unsigned not null auto_increment primary key,
    class varchar(100) unique not null
) engine = InnoDb;

create table acl_object_identity (
    id int unsigned not null auto_increment primary key,
    object_id_class smallint unsigned not null,
    object_id_identity int unsigned not null,
    parent_object int unsigned,
    owner_sid int unsigned,
    entries_inheriting boolean not null,
    unique index acl_object_identity_idx_1 (object_id_class, object_id_identity),
    foreign key (object_id_class) references acl_class (id),
    foreign key (parent_object) references acl_object_identity (id),
    foreign key (owner_sid) references acl_sid (id)
) engine = InnoDb;

create table acl_entry (
    id int unsigned not null auto_increment primary key,
    acl_object_identity int unsigned not null,
    ace_order int unsigned not null,
    sid int unsigned not null,
    mask int not null,
    granting boolean not null default 1,
    audit_success boolean not null default 0,
    audit_failure boolean not null default 0,
    unique index acl_entry_idx_1 (acl_object_identity, ace_order),
    foreign key (acl_object_identity) references acl_object_identity (id),
    foreign key (sid) references acl_sid (id)
) engine = InnoDb;


-- =====================================================================================================================
-- Procedures
-- =====================================================================================================================

delimiter //

create procedure createPermission(in pname varchar(50))
begin
    insert into permission (name) values (pname);
end //

create procedure createRole(in rname varchar(50), out rid smallint)
begin
    insert into role (name) values (rname);
    set rid := last_insert_id();
    
    -- Create the ACL SID for this role
    insert into acl_sid (principal, sid) values (0, rname);
end //

create procedure bindRoleAndPermission(in rid smallint, in pname varchar(50))
begin
    select id from permission where name = pname into @pid;
    insert into role_permission (role_id, permission_id) values (rid, @pid);
end //

create procedure createAccount(in uname varchar(50), in ufirst varchar(50), in ulast varchar(50), in uemail varchar(50), out uid int)
begin
    insert into account (username, password, first_name, last_name, email, enabled) values
        (uname, 'p@ssword', ufirst, ulast, uemail, 1);
    set uid := last_insert_id();
    
    -- Create the ACL SID for this account
    insert into acl_sid (principal, sid) values (1, uname);
end //

create procedure bindAccountAndRole(in uid int, in rname varchar(50))
begin
    select id from role where name = rname into @rid;
    insert into account_role (account_id, role_id) values (uid, @rid);
end //

create procedure createSite()
begin
    select id from acl_class where class = 'java.lang.Object' into @class_id;
    select id from acl_sid where sid = 'ROLE_ADMIN' into @admin_sid;
    
    -- Create the ACL OID for the site.
    insert into acl_object_identity (object_id_class, object_id_identity, owner_sid, entries_inheriting) values
        (@class_id, 1, @admin_sid, 0);
end //

create procedure createForum(in fname varchar(250), in fowner varchar(50), out fid int)
begin
    
    -- Find the forum owner
    select id from account where username = fowner into @fowner_id;
    
    -- Create the forum, setting the owner
    insert into forum (name, owner_id) values (fname, @fowner_id);
    set fid := last_insert_id();
    
    -- Now we need to create the ACL for this forum
    
    -- Look up the Forum class since we'll need it to create the forum's ACL object identity (OID)
    select id from acl_class where class = 'com.springinpractice.ch07.domain.Forum' into @fclass;
    
    -- Look up the site object, which is the parent of all forums. We'll need this to create the OID too.
    select oid.id
        from acl_object_identity oid, acl_class c
        where oid.object_id_class = c.id and c.class = 'java.lang.Object'
        into @site;
    
    -- Look up the owner's SID
    select id from acl_sid where sid = fowner into @owner_sid;
    
    -- Create the ACL OID for this forum
    -- FIXME Don't pass the fowner ID, we need the SID
    insert into acl_object_identity (object_id_class, object_id_identity, parent_object, owner_sid, entries_inheriting) values
        (@fclass, fid, @site, @owner_sid, 1);
    set @forum_oid := last_insert_id();
    
    -- Give the owner read, write, create, delete and admin permissions by creating a forum ACL.
    -- Bitwise permission mask semantics: read (bit 0), write (bit 1), create (bit 2), delete (bit 3), admin (bit 4).
    -- WARNING: The "mask" isn't really a mask at all as you can set only one bit at a time! See
    -- http://jira.springframework.org/browse/SEC-1140
    insert into acl_entry (acl_object_identity, ace_order, sid, mask) values
        (@forum_oid, 0, @owner_sid, 1), -- read
        (@forum_oid, 1, @owner_sid, 2), -- write
        (@forum_oid, 2, @owner_sid, 4), -- create
        (@forum_oid, 3, @owner_sid, 8), -- delete
        (@forum_oid, 4, @owner_sid, 16); -- admin
end //

create procedure createMessage(in forum int, in author varchar(50), in mdate timestamp, in subj varchar(250))
begin
    select @author_id := id from account where username = author;
    insert into message (forum_id, subject, author_id, date_created, text) values (
        forum, subj, @author_id, mdate,
        '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p>'
    );
    set @msg_id := last_insert_id();
    
    -- Look up the Message class.
    select @msg_class := id from acl_class where class = 'com.springinpractice.ch07.domain.Message';
    
    -- Look up the author's SID
    select @author_sid := id from acl_sid where sid = author;
    
    -- Create the ACL OID for this message
    insert into acl_object_identity (object_id_class, object_id_identity, parent_object, owner_sid, entries_inheriting) values
        (@msg_class, @msg_id, @forum_oid, @author_sid, 1);
    select @msg_oid := last_insert_id();
    
    -- Give the author write access to the message.
    insert into acl_entry (acl_object_identity, ace_order, sid, mask) values
        (@msg_oid, 0, @author_sid, 2); -- write
end //

delimiter ;
