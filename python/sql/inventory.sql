DROP TABLE IF EXISTS customer ;

CREATE TABLE IF NOT EXISTS customer (
    cust_id TEXT PRIMARY KEY NOT NULL,
    cust_name TEXT NOT NULL,
    cust_phone TEXT NOT NULL,
    cust_location TEXT NOT NULL
);

DROP TABLE IF EXISTS manager ;

CREATE TABLE IF NOT EXISTS manager (
    mgr_id TEXT PRIMARY KEY NOT NULL,
    mgr_name TEXT NOT NULL,
    mgr_phone TEXT NOT NULL
);

DROP TABLE IF EXISTS manufacturer ;

CREATE TABLE IF NOT EXISTS manufacturer (
    mfr_id TEXT PRIMARY KEY NOT NULL,
    mfr_name TEXT UNIQUE NOT NULL
);

DROP TABLE IF EXISTS delivery_note;

CREATE TABLE IF NOT EXISTS delivery_note (
    del_id TEXT PRIMARY KEY NOT NULL,
    order_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    note TEXT NULL DEFAULT NULL,
    status TEXT DEFAULT NULL,
    cust_id TEXT NOT NULL,
    mgr_id TEXT NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES customer (cust_id) FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id)
);

DROP TABLE IF EXISTS staff ;

CREATE TABLE IF NOT EXISTS staff (
    stf_id TEXT PRIMARY KEY NOT NULL,
    stf_name TEXT NOT NULL,
    stf_phone INTEGER NULL DEFAULT NULL,
    mgr_id TEXT NOT NULL,
    inv_id TEXT NOT NULL,
    FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id) FOREIGN KEY (inv_id) REFERENCES inventory (inv_id)
);

DROP TABLE IF EXISTS inventory ;

CREATE TABLE IF NOT EXISTS inventory (
    inv_id TEXT PRIMARY KEY NOT NULL,
    inv_capacity INTEGER NOT NULL,
    inv_location TEXT NOT NULL,
    stf_id TEXT DEFAULT NULL,
    FOREIGN KEY (stf_id) REFERENCES staff (stf_id)
);

DROP TABLE IF EXISTS order_note ;

CREATE TABLE IF NOT EXISTS order_note (
    ord_id TEXT PRIMARY KEY NOT NULL,
    ord_date DATE NOT NULL,
    ord_note TEXT NOT NULL,
    ord_status TEXT NOT NULL,
    mfr_name TEXT NOT NULL,
    mgr_id TEXT NOT NULL,
    FOREIGN KEY (mfr_name) REFERENCES manufacturer (mfr_name) FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id)
);

DROP TABLE IF EXISTS electronics;

CREATE TABLE IF NOT EXISTS electronics (
    el_id TEXT PRIMARY KEY NOT NULL,
    el_type TEXT NOT NULL,
    el_series TEXT NOT NULL,
    el_stock INTEGER UNSIGNED NOT NULL,
    inv_id TEXT NOT NULL,
    mfr_name TEXT NOT NULL,
    FOREIGN KEY (inv_id) REFERENCES inventory (inv_id) FOREIGN KEY (mfr_name) REFERENCES manufacture (mfr_name)
);

DROP TABLE IF EXISTS receive_note ;

CREATE TABLE IF NOT EXISTS receive_note (
    rcv_id TEXT PRIMARY KEY NOT NULL,
    rcv_date DATE NOT NULL,
    rcv_note TEXT,
    rcv_status TEXT NOT NULL,
    ord_id TEXT NOT NULL,
    inv_id TEXT not NULL,
    FOREIGN KEY (ord_id) REFERENCES order_note (ord_id) FOREIGN KEY (inv_id) REFERENCES inventory (inv_id)
);

DROP TABLE IF EXISTS temp_rcv;

CREATE TABLE IF NOT EXISTS temp_rcv (
    temp_rcv_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    rcv_id TEXT NOT NULL,
    ord_id TEXT NOT NULL,
    el_id TEXT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (rcv_id) REFERENCES receive_note (rcv_id) FOREIGN KEY (ord_id) REFERENCES order_note (ord_id) FOREIGN KEY (el_id) REFERENCES electronics (el_id)
);

DROP TABLE IF EXISTS temp_del;

CREATE TABLE IF NOT EXISTS temp_del (
    temp_del_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    del_id TEXT NOT NULL,
    el_id TEXT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (del_id) REFERENCES delivery_note (del_id) FOREIGN KEY (el_id) REFERENCES electronics (el_id)
);

DROP TABLE IF EXISTS temp_ord;

CREATE TABLE IF NOT EXISTS temp_ord (
    temp_ord_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ord_id TEXT NOT NULL,
    el_id TEXT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (ord_id) REFERENCES order_note (ord_id) FOREIGN KEY (el_id) REFERENCES electronics (el_id)
);

DROP TRIGGER IF EXISTS validate_manufacturer;

CREATE TRIGGER IF NOT EXISTS validate_manufacturer BEFORE
INSERT
    ON electronics BEGIN
SELECT
    CASE
        WHEN NEW.mfr_name NOT IN (
            SELECT
                mfr_name
            FROM
                manufacturer
        ) THEN (RAISE(ABORT, 'Unknown Manufacturer'))
    END;

END;

DROP TRIGGER IF EXISTS validate_inventory;

CREATE TRIGGER IF NOT EXISTS validate_inventory BEFORE
INSERT
    ON staff BEGIN
SELECT
    CASE
        WHEN NEW.inv_id NOT IN (
            SELECT
                inv_id
            FROM
                inventory
        ) THEN (RAISE(ABORT, 'Unknown Inventory'))
    END;

SELECT
    CASE
        WHEN NEW.mgr_id NOT IN (
            SELECT
                mgr_id
            FROM
                manager
        ) THEN (RAISE(ABORT, 'Unknown Manager'))
    END;

SELECT
    CASE
        WHEN NEW.inv_id IN (
            SELECT
                inv_id
            FROM
                staff
        ) THEN (RAISE(ABORT, 'Repeated Inventory'))
    END;

UPDATE
    inventory
SET
    stf_id = NEW.stf_id
WHERE
    NEW.inv_id = inv_id;

END ;

DROP TRIGGER IF EXISTS validate_order;

CREATE TRIGGER IF NOT EXISTS validate_order BEFORE
INSERT
    ON order_note BEGIN
SELECT
    CASE
        WHEN NEW.mfr_name NOT IN (
            SELECT
                mfr_name
            FROM
                manufacturer
        ) THEN (RAISE(ABORT, 'Unknown Manufacturer'))
    END;

SELECT
    CASE
        WHEN NEW.mgr_id NOT IN (
            SELECT
                mgr_id
            FROM
                manager
        ) THEN (RAISE(ABORT, 'Unknown Manager'))
    END;

END;

DROP TRIGGER IF EXISTS validate_order_electronic;

CREATE TRIGGER IF NOT EXISTS validate_order_electronic BEFORE
INSERT
    ON temp_ord BEGIN
SELECT
    CASE
        WHEN NEW.ord_id NOT IN (
            SELECT
                ord_id
            FROM
                order_note
        ) THEN (RAISE(ABORT, 'Unknown Manufacturer'))
    END;

END;

DROP TRIGGER IF EXISTS validate_receive_note;

CREATE TRIGGER IF NOT EXISTS validate_receive_note BEFORE
INSERT
    ON receive_note BEGIN
SELECT
    CASE
        WHEN NEW.inv_id NOT IN (
            SELECT
                inv_id
            FROM
                inventory
        ) THEN (RAISE(ABORT, 'Unknown Inventory'))
    END;

SELECT
    CASE
        WHEN NEW.ord_id NOT IN (
            SELECT
                ord_id
            FROM
                order_note
        ) THEN (RAISE(ABORT, 'Unknown Order'))
    END;

END;

DROP TRIGGER IF EXISTS validate_receive_electronics;

CREATE TRIGGER IF NOT EXISTS validate_receive_electronics BEFORE
INSERT
    ON temp_rcv BEGIN
SELECT
    CASE
        WHEN NEW.rcv_id NOT IN (
            SELECT
                rcv_id
            FROM
                receive_note
        ) THEN (RAISE(ABORT, 'Unknown Receive Note'))
    END;

SELECT
    CASE
        WHEN NEW.el_id NOT IN (
            SELECT
                el_id
            FROM
                electronics
        ) THEN (RAISE(ABORT, 'Unknown Electronics'))
    END;

SELECT
    RAISE(ABORT, 'Invalid Elctronics Stock')
WHERE
    EXISTS(
        SELECT
            *
        FROM
            temp_ord
        WHERE
            quantity < NEW.quantity
            AND NEW.ord_id = ord_id
            AND el_id = NEW.el_id
    );

END;

DROP TRIGGER IF EXISTS update_receive_electronics;

CREATE TRIGGER IF NOT EXISTS update_receive_electronics
AFTER
INSERT
    ON temp_rcv
    WHEN (
        SELECT
            rcv_status
        FROM
            receive_note
        WHERE
            rcv_id = NEW.rcv_id
    ) = 'Finished' BEGIN
UPDATE
    temp_ord
SET
    quantity = quantity - NEW.quantity
WHERE
    el_id = NEW.el_id
    AND NEW.ord_id = ord_id;

UPDATE
    electronics
SET
    el_stock = el_stock + NEW.quantity
WHERE
    el_id = NEW.el_id;

END;

DROP TRIGGER IF EXISTS validate_delivery_note;

CREATE TRIGGER IF NOT EXISTS validate_receive_electronics BEFORE
INSERT
    ON delivery_note BEGIN
SELECT
    CASE
        WHEN NEW.mgr_id NOT IN (
            SELECT
                mgr_id
            FROM
                manager
        ) THEN (RAISE(ABORT, 'Unknown Manager'))
    END;

SELECT
    CASE
        WHEN NEW.cust_id NOT IN (
            SELECT
                cust_id
            FROM
                customer
        ) THEN (RAISE(ABORT, 'Unknown Customer'))
    END;

END;