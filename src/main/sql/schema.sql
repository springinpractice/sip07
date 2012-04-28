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

create procedure createPermission(in pname varchar(50))
begin
    insert into permission (name) values (pname);
end //

create procedure createRole(in rname varchar(50), out rid smallint)
begin
    insert into role (name) values (rname);
    select last_insert_id() into rid;
end //

create procedure bindRoleAndPermission(in rid smallint, in pname varchar(50))
begin
    select @pid := id from permission where name = pname;
    insert into role_permission (role_id, permission_id) values (rid, @pid);
end //

create procedure createAccount(in uname varchar(50), in ufirst varchar(50), in ulast varchar(50), in uemail varchar(50), out uid int)
begin
    insert into account (username, password, first_name, last_name, email, enabled) values
        (uname, 'p@ssword', ufirst, ulast, uemail, 1);
    select last_insert_id() into uid;
end //

create procedure bindAccountAndRole(in uid int, in rname varchar(50))
begin
    select @rid := id from role where name = rname;
    insert into account_role (account_id, role_id) values (uid, @rid);
end //

create procedure createForum(in fname varchar(250), in fowner varchar(50), out fid int)
begin
    select @fowner_id := id from account where username = fowner;
    insert into forum (name, owner_id) values (fname, @fowner_id);
    select last_insert_id() into fid;
end //

create procedure createMessage(in forum int, in author varchar(50), in mdate timestamp, in subj varchar(250))
begin
    select @author_id := id from account where username = author;
    insert into message (forum_id, subject, author_id, date_created, text) values (
        forum, subj, @author_id, mdate,
        '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris in odio ligula. Aliquam massa magna, auctor eget viverra eget, euismod nec dolor. Quisque suscipit feugiat ipsum a porttitor. Fusce dolor lectus, accumsan ut faucibus et, elementum eget leo. Curabitur sodales dui fringilla mi pretium faucibus. Praesent nulla dolor, iaculis vel tempus eu, venenatis consequat ipsum. Nunc eros lorem, interdum non fringilla eu, lobortis at nulla. Vivamus eu ligula at quam adipiscing pellentesque. Praesent vitae erat sit amet felis eleifend egestas ut vel leo. Phasellus ultrices dui ut odio condimentum tristique. Sed ultricies justo at turpis tempus semper. Nulla consequat libero ut nunc facilisis viverra. Fusce molestie pulvinar varius. Vestibulum luctus nisl urna. Nam bibendum feugiat enim, faucibus mollis elit vehicula fermentum.</p>'
    );
end //

delimiter ;
