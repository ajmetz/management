-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

create table entries (
    id integer primary key autoincrement,
    start_time text,
    end_time text,
    detail text,
    category_id integer NOT NULL,
    foreign key(category_id) references categories(id)
);

create table categories (
    id integer primary key autoincrement,
    name text
);

-- Initial Population of Tables with Default values:

INSERT INTO
    categories 
        (name)
    VALUES 
        ('PLANNING'),
        ('YOUTUBE');

-- 1 down

PRAGMA foreign_keys = OFF;

drop table if exists entries;
drop table if exists categories;