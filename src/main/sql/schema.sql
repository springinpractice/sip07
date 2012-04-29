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

create procedure createPermission($name varchar(50))
begin
    insert into permission (name) values ($name);
end //

create procedure createRole($name varchar(50), out $id smallint)
begin
    insert into role (name) values ($name);
    set $id := last_insert_id();
    
    -- Create the ACL SID for this role
    insert into acl_sid (principal, sid) values (0, $name);
end //

create procedure roleHasPermission($role_id smallint, $perm_name varchar(50))
begin
    declare _perm_id int;
    select id from permission where name = $perm_name into _perm_id;
    insert into role_permission (role_id, permission_id) values ($role_id, _perm_id);
end //

create procedure createAccount($name varchar(50), $first_name varchar(50), $last_name varchar(50), $email varchar(50), out $id int)
begin
    insert into account (username, password, first_name, last_name, email, enabled) values ($name, 'p@ssword', $first_name, $last_name, $email, 1);
    set $id := last_insert_id();
    
    -- Create the ACL SID for this account
    insert into acl_sid (principal, sid) values (1, $name);
end //

create procedure accountHasRole($account_id int, $role_id smallint)
begin
    insert into account_role (account_id, role_id) values ($account_id, $role_id);
end //

create procedure createAclClass($name varchar(100), out $id smallint)
begin
    insert into acl_class (class) values ($name);
    set $id := last_insert_id();
end //

create procedure createSite(out $site_oid int)
begin
    -- Create the ACL OID for the site.
    insert into acl_object_identity (object_id_class, object_id_identity, owner_sid, entries_inheriting) values
        (@site_class, 1, @role_admin, 0);
    set $site_oid := last_insert_id();
    
    -- Create the ACL for the site.
    insert into acl_entry (acl_object_identity, ace_order, sid, mask) values
        ($site_oid, 0, @role_user, 1), -- read
        ($site_oid, 1, @role_admin, 1), -- read
        ($site_oid, 2, @role_admin, 2), -- write
        ($site_oid, 3, @role_admin, 4), -- create
        ($site_oid, 4, @role_admin, 8), -- delete
        ($site_oid, 5, @role_admin, 16); -- admin
end //

create procedure createForum($name varchar(250), $owner_id int, out $id smallint)
begin
    declare _site_oid int;
    declare _owner_sid int;
    declare _forum_oid smallint;
    
    insert into forum (name, owner_id) values ($name, $owner_id);
    set $id := last_insert_id();
    
    -- Now we need to create the ACL for this forum
    
    -- Create the forum OID.
    select s.id from account a, acl_sid s where a.id = $owner_id and a.username = s.sid into _owner_sid;
    insert into acl_object_identity (object_id_class, object_id_identity, parent_object, owner_sid, entries_inheriting) values
        (@forum_class, $id, @site_oid, _owner_sid, 1);
    set _forum_oid := last_insert_id();
    
    -- Give the owner read, write, create, delete and admin permissions by creating a forum ACL.
    -- Bitwise permission mask semantics: read (bit 0), write (bit 1), create (bit 2), delete (bit 3), admin (bit 4).
    -- WARNING: The "mask" isn't really a mask at all as you can set only one bit at a time! See
    -- http://jira.springframework.org/browse/SEC-1140
    insert into acl_entry (acl_object_identity, ace_order, sid, mask) values
        (_forum_oid, 0, _owner_sid, 1), -- read
        (_forum_oid, 1, _owner_sid, 2), -- write
        (_forum_oid, 2, _owner_sid, 4), -- create
        (_forum_oid, 3, _owner_sid, 8), -- delete
        (_forum_oid, 4, _owner_sid, 16); -- admin
end //

create procedure createMessage($forum_id int, $author_id int, $create_date timestamp, $subject varchar(250))
begin
    declare _id int;
    declare _forum_oid smallint;
    declare _message_oid int;
    declare _author_sid int;
    
    insert into message (forum_id, subject, author_id, date_created, text) values
        ($forum_id, $subject, $author_id, $create_date, '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p>');
    set _id := last_insert_id();
    
    -- Create the ACL OID for this message
    select id from acl_object_identity where object_id_class = @forum_class and object_id_identity = $forum_id into _forum_oid;
    select s.id from account a, acl_sid s where a.id = $author_id and a.username = s.sid into _author_sid;
    insert into acl_object_identity (object_id_class, object_id_identity, parent_object, owner_sid, entries_inheriting) values
        (@message_class, _id, _forum_oid, _author_sid, 1);
    set _message_oid := last_insert_id();
    
    -- Give the author write access to the message.
    insert into acl_entry (acl_object_identity, ace_order, sid, mask) values
        (_message_oid, 0, _author_sid, 2); -- write
end //

delimiter ;
