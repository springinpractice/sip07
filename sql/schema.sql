drop table if exists message;
drop table if exists forum;
drop table if exists role_permission;
drop table if exists account_role;
drop table if exists permission;
drop table if exists role;
drop table if exists account;


-- ============================================================================
-- Domain schema
-- ============================================================================

create table account (
    id bigint(20) unsigned not null auto_increment primary key,
    username varchar(50) not null,
    password varchar(50) not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(50) not null,
    enabled boolean not null,
    unique index account_idx1 (username)
) engine = InnoDb;

create table role (
    id bigint(20) unsigned not null auto_increment primary key,
    name varchar(50) not null
) engine = InnoDb;

create table permission (
    id bigint(20) unsigned not null auto_increment primary key,
    name varchar(50) not null
) engine = InnoDb;

create table account_role (
    id bigint(20) unsigned not null auto_increment primary key,
    account_id bigint(20) unsigned not null,
    role_id bigint(20) unsigned not null,
    foreign key (account_id) references account (id),
    foreign key (role_id) references role (id),
    unique index account_role_idx1 (account_id, role_id)
) engine = InnoDb;

create table role_permission (
    id bigint(20) unsigned not null auto_increment primary key,
    role_id bigint(20) unsigned not null,
    permission_id bigint(20) unsigned not null,
    foreign key (role_id) references role (id),
    foreign key (permission_id) references permission (id),
    unique index role_permission_idx1 (role_id, permission_id)
) engine = InnoDb;

create table forum (
    id bigint(20) unsigned not null auto_increment primary key,
    name varchar(250) not null,
    owner_id bigint(20) unsigned not null,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    foreign key (owner_id) references account (id),
    unique index forum_idx1 (name)
) engine = InnoDb;

create table message (
    id bigint(20) unsigned not null auto_increment primary key,
    forum_id bigint(20) unsigned not null,
    subject varchar(250) not null,
    author_id bigint(20) unsigned not null,
    text text(8000) not null,
    visible boolean not null,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    foreign key (forum_id) references forum (id),
    foreign key (author_id) references account (id),
    index message_idx1 (date_created)
) engine = InnoDb;
