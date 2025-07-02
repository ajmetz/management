-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS entry (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time TEXT,
    end_time TEXT,
    detail TEXT
);

CREATE TABLE IF NOT EXISTS category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

CREATE TABLE IF NOT EXISTS entry_category (
    entry_id INTEGER NOT NULL,
    category_id  INTEGER NOT NULL,
    PRIMARY KEY (entry_id, category_id),
    FOREIGN KEY (entry_id) REFERENCES entry(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
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

DROP TABLE IF EXISTS entry;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS entry_category;