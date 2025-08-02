-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time_utc_epoch INTEGER,
    end_time_utc_epoch INTEGER,
    detail TEXT
);

CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

CREATE TABLE IF NOT EXISTS entries_categories (
    entry INTEGER NOT NULL,
    category  INTEGER NOT NULL,
    PRIMARY KEY (entry, category),
    FOREIGN KEY (entry) REFERENCES entries(id),
    FOREIGN KEY (category) REFERENCES categories(id)
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

DROP TABLE IF EXISTS entries;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS entries_categories;