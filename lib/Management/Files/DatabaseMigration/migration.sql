-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

create table if not exists entry (
    id integer primary key autoincrement,
    start_time text,
    end_time text,
    detail text
);

create table if not exists category (
    id integer primary key autoincrement,
    name text
);

create table if not exists entry_category (
    entry_id integer NOT NULL,
    category_id  integer NOT NULL,
    primary key (entry_id, category_id),
    foreign key (entry_id) references entry(id),
    foreign key (category_id) references category(id)
);

-- Initial Population of Tables with Default values:

INSERT INTO
    category
        (name)
    VALUES 
        ('PLANNING'),
        ('YOUTUBE');

-- 1 down

PRAGMA foreign_keys = OFF;

drop table if exists entry;
drop table if exists category;
drop table if exists entry_category;