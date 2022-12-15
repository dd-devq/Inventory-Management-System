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
    del_note TEXT NULL DEFAULT NULL,
    del_status TEXT DEFAULT NULL,
    cust_id TEXT,
    mgr_id TEXT,
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
    inv_location TEXT NOT NULL,
    stf_id TEXT DEFAULT NULL,
    FOREIGN KEY (stf_id) REFERENCES staff (stf_id)
);

DROP TABLE IF EXISTS order_note ;

CREATE TABLE IF NOT EXISTS order_note (
    ord_id TEXT PRIMARY KEY NOT NULL,
    ord_date DATE NOT NULL,
    ord_note TEXT NOT NULL,
    mfr_name TEXT NOT NULL,
    mgr_id TEXT,
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

UPDATE
    electronics
SET
    inv_id = (
        SELECT
            inv_id
        FROM
            receive_note
        WHERE
            NEW.ord_id = ord_id
            AND NEW.rcv_id = rcv_id
    )
WHERE
    el_id = NEW.el_id;

END;

DROP TRIGGER IF EXISTS validate_delivery_note;

CREATE TRIGGER IF NOT EXISTS validate_delivery_note BEFORE
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

DROP TRIGGER IF EXISTS validate_temp_del;

CREATE TRIGGER IF NOT EXISTS validate_temp_del BEFORE
INSERT
    ON temp_del BEGIN
SELECT
    CASE
        WHEN NEW.del_id NOT IN (
            SELECT
                del_id
            FROM
                delivery_note
        ) THEN (RAISE(ABORT, 'Unknown Delivery Note'))
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

END;

DROP TRIGGER IF EXISTS update_electroncis_after_delivery;

CREATE TRIGGER IF NOT EXISTS update_electroncis_after_delivery
AFTER
INSERT
    ON temp_del
    WHEN (
        SELECT
            del_status
        FROM
            delivery_note
        WHERE
            del_id = NEW.del_id
    ) = 'Finished' BEGIN
UPDATE
    electronics
SET
    el_stock = el_stock - NEW.quantity
WHERE
    el_id = NEW.el_id;

END;

DROP TRIGGER IF EXISTS update_status_receive_note;

CREATE TRIGGER IF NOT EXISTS update_status_receive_note
AFTER
UPDATE
    ON receive_note
    WHEN (
        SELECT
            rcv_status
        FROM
            receive_note
        WHERE
            rcv_id = NEW.rcv_id
    ) != NEW.rcv_status BEGIN
UPDATE
    electronics
SET
    el_stock = el_stock + (
        SELECT
            quantity
        FROM
            temp_rcv
        WHERE
            NEW.rcv_id = rcv_id
            AND NEW.ord_id = ord_id
            AND electronics.el_id = el_id
    )
WHERE
    el_id = (
        SELECT
            el_id
        FROM
            temp_rcv
        WHERE
            NEW.rcv_id = rcv_id
            AND NEW.ord_id = ord_id
            AND electronics.el_id = el_id
    );

UPDATE
    temp_ord
SET
    quantity = quantity - (
        SELECT
            quantity
        FROM
            temp_rcv
        WHERE
            temp_ord.el_id = el_id
            AND NEW.ord_id = ord_id
            AND NEW.rcv_id = rcv_id
    )
WHERE
    el_id = (
        SELECT
            el_id
        FROM
            temp_rcv
        WHERE
            NEW.rcv_id = rcv_id
            AND NEW.ord_id = ord_id
            AND temp_ord.el_id = el_id
    )
    AND ord_id = NEW.ord_id;

END;

DROP TRIGGER IF EXISTS update_status_deliveery_note;

CREATE TRIGGER IF NOT EXISTS update_status_delivery_note BEFORE
UPDATE
    ON delivery_note
    WHEN (
        SELECT
            del_status
        FROM
            delivery_note
        WHERE
            del_id = NEW.del_id
    ) != NEW.del_status BEGIN
UPDATE
    electronics
SET
    el_stock = el_stock - (
        SELECT
            quantity
        FROM
            temp_del
        WHERE
            NEW.del_id = del_id
            AND el_id = electronics.el_id
    )
WHERE
    el_id = (
        SELECT
            el_id
        FROM
            temp_del
        WHERE
            NEW.del_id = del_id
            AND el_id = electronics.el_id
    );

END;

DROP TABLE IF EXISTS TEMP_TABLE;

DROP TRIGGER IF EXISTS update_manufacturer;

CREATE TRIGGER IF NOT EXISTS update_manufacturer BEFORE
UPDATE
    ON manufacturer BEGIN
SELECT
    RAISE(ABORT, 'Unable to update manufacturer')
WHERE
    (1 = 1);

END;

DROP TRIGGER IF EXISTS delete_staff;

CREATE TRIGGER IF NOT EXISTS delete_staff BEFORE DELETE ON staff BEGIN
UPDATE
    inventory
SET
    stf_id = NULL
WHERE
    OLD.stf_id = stf_id;

END;

DROP TRIGGER IF EXISTS delete_manager;

CREATE TRIGGER IF NOT EXISTS delete_manager BEFORE DELETE ON manager BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                del_status
            FROM
                delivery_note
            WHERE
                mgr_id = OLD.mgr_id
        ) = 'Processing'
        OR (
            SELECT
                rcv_status
            FROM
                receive_note
            WHERE
                ord_id = (
                    SELECT
                        ord_id
                    FROM
                        order_note
                    WHERE
                        OLD.mgr_id = mgr_id
                )
        ) = 'Processing' THEN RAISE(ABORT, 'Manager responsiblity is not done!')
    END;

UPDATE
    delivery_note
SET
    mgr_id = NULL
WHERE
    mgr_id = OLD.mgr_id;

UPDATE
    order_note
SET
    mgr_id = NULL
WHERE
    mgr_id = OLD.mgr_id;

END;

DROP TRIGGER IF EXISTS delete_inventory;

CREATE TRIGGER IF NOT EXISTS delete_inventory BEFORE DELETE ON inventory BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                el_stock
            FROM
                electronics
            WHERE
                inv_id = OLD.inv_id
        ) != 0 THEN RAISE(ABORT, 'Inventory not empty')
    END;

UPDATE staff SET inv_id = NULL WHERE inv_id = OLD.inv_id;

END;

DROP TRIGGER IF EXISTS delete_customer;

CREATE TRIGGER IF NOT EXISTS delete_customer BEFORE DELETE ON customer BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                del_status
            FROM
                delivery_note
            WHERE
                cust_id = OLD.cust_id
        ) = 'Processing' THEN RAISE(ABORT, 'Exist shipment to this customer')
    END;

UPDATE delivery_note SET cust_id = NULL WHERE cust_id = OLD.cust_id;

END;

DROP TRIGGER IF EXISTS delete_electronics;

CREATE TRIGGER IF NOT EXISTS delete_electronics BEFORE DELETE ON electronics BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                el_stock
            FROM
                electronics
            WHERE
                el_id = OLD.el_id
        ) != 0 THEN RAISE(
            ABORT,
            'Exist product in Inventory! Please empty first'
        )
    END;

END;

DROP TRIGGER IF EXISTS delete_receive_note;

CREATE TRIGGER IF NOT EXISTS delete_receive_note BEFORE DELETE ON receive_note BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                rcv_status
            FROM
                receive_note
            WHERE
                rcv_id = OLD.rcv_id
        ) = 'Finished' THEN RAISE(
            ABORT,
            'Receive note alreay finished'
        )
    END;

DELETE FROM temp_rcv WHERE rcv_id = OLD.rcv_id;

END;

CREATE TRIGGER IF NOT EXISTS delete_delivery_note BEFORE DELETE ON delivery_note BEGIN
SELECT
    CASE
        WHEN (
            SELECT
                del_status
            FROM
                delivery_note
            WHERE
                del_id = OLD.del_id
        ) = 'Finished' THEN RAISE(
            ABORT,
            'Delivery note alreay finished'
        )
    END;

DELETE FROM temp_del WHERE del_id = OLD.del_id;

END;