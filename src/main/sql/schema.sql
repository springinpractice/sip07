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

create procedure createForum(in fowner int, in fname varchar(250), out lastid int)
begin
    insert into forum (name, owner_id) values (fname, fowner);
    select last_insert_id() into lastid;
end //

create procedure createMessage(in forum int, in author int, in pdate timestamp, in subj varchar(250))
begin
    insert into message (forum_id, subject, author_id, date_created, text) values (
        forum, subj, author, pdate,
        '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p>'
    );
end //

delimiter ;
