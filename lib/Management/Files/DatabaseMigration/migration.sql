-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS top_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    level INTEGER
);

CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time_utc_epoch INTEGER,
    end_time_utc_epoch INTEGER,
    detail TEXT,
    top_category_id INTEGER,
    foreign key(top_category_id) references top_categories(id)
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
        (name, level)
    VALUES 
        ('PLANNING','1'),
        ('YOUTUBE','1');

INSERT INTO
    top_categories
        (name)
    VALUES
        ('MANAGEMENT'),
        ('COMMUNICATION'),
        ('ROUTINE'),
        ('ACTION'),
        ('OTHER');

-- 1 down

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS top_categories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS entries;
DROP TABLE IF EXISTS entries_categories;

