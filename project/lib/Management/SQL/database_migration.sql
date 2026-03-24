-- 1 up

-- Create Tables

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS top_categories (
    top_category TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS categories (
    category TEXT PRIMARY KEY,
    top_category TEXT,
    FOREIGN KEY (top_category) REFERENCES top_categories(top_category)
);

CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time_utc_epoch INTEGER,
    end_time_utc_epoch INTEGER,
    details TEXT
);

CREATE TABLE IF NOT EXISTS entries_categories (
    entry_id INTEGER NOT NULL,
    category TEXT NOT NULL,
    CONSTRAINT PK_entry_category PRIMARY KEY (entry_id, category),
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    FOREIGN KEY (category) REFERENCES categories(category)
);


-- Initial Population of Tables with Default values:

INSERT INTO
    categories
        (category, top_category)
    VALUES 
        ('PLANNING','MANAGEMENT'),
        ('YOUTUBE','ACTION');

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

