drop database if exists sip07;
create database sip07;
use sip07;


-- =====================================================================================================================
-- Tables
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
end //

create procedure accountHasRole($account_id int, $role_id smallint)
begin
    insert into account_role (account_id, role_id) values ($account_id, $role_id);
end //

create procedure createForum($name varchar(250), $owner_id int, out $id smallint)
begin
    insert into forum (name, owner_id) values ($name, $owner_id);
    set $id := last_insert_id();
end //

create procedure createMessage($forum_id int, $author_id int, $create_date timestamp, $subject varchar(250))
begin
    insert into message (forum_id, subject, author_id, date_created, text) values
        ($forum_id, $subject, $author_id, $create_date, '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p>');
end //

delimiter ;
