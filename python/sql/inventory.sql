DROP TABLE IF EXISTS customer;

CREATE TABLE IF NOT EXISTS customer (
    cust_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    cust_name TEXT NOT NULL,
    cust_phone TEXT NOT NULL,
    cust_location TEXT NOT NULL
);

INSERT INTO
    customer (cust_name, cust_phone, cust_location)
VALUES
    ('Vlad', '119-223-444-967', 'Russia'),
    ('Dmitri', '219-223-444-614', 'Russia'),
    ('Brad', '119-562-451-912', 'USA');