-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS top_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    top_category TEXT
);

CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT,
    level INTEGER
);

CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time_utc_epoch INTEGER,
    end_time_utc_epoch INTEGER,
    details TEXT,
    top_category_id INTEGER,
    foreign key(top_category_id) references top_categories(id)
);

CREATE TABLE IF NOT EXISTS entries_categories (
    entry_id INTEGER NOT NULL,
    category_id  INTEGER NOT NULL,
    PRIMARY KEY (entry_id, category_id),
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);


-- Initial Population of Tables with Default values:

INSERT INTO
    categories
        (category, level)
    VALUES 
        ('PLANNING','1'),
        ('YOUTUBE','1');

INSERT INTO
    top_categories
        (top_category)
    VALUES
        ('OTHER'),
        ('MANAGEMENT'),
        ('COMMUNICATION'),
        ('ROUTINE'),
        ('ACTION');

-- 1 down

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS top_categories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS entries;
DROP TABLE IF EXISTS entries_categories;

