--Title :           Tutorial 7: CREATING TABLES
--Student Name:     CHUKWUDI ANYANWU


SET ECHO ON

SPOOL week7_schema_output.txt

-- Dropping Tables and sequences if they are already created.
DROP TABLE unit CASCADE CONSTRAINTS;

DROP TABLE student CASCADE CONSTRAINTS;

DROP TABLE enrolment CASCADE CONSTRAINTS;

DROP SEQUENCE STUDENT_SEQ;

--Drop Table FIT5111_STUDENT Purge;


-- CREATING UNIT Table
CREATE TABLE unit (
    unit_code   CHAR(7) NOT NULL,
    unit_name   VARCHAR(50) NOT NULL,
    CONSTRAINT unit_pk PRIMARY KEY ( unit_code )
);

--- STUDENT Table
CREATE TABLE student (
    stu_nbr     NUMERIC(8) NOT NULL CHECK ( stu_nbr > 10000000 ),
    stu_lname   VARCHAR(50) NOT NULL,
    stu_fname   VARCHAR(50) NOT NULL,
    stu_dob     DATE NOT NULL,
    CONSTRAINT student_pk PRIMARY KEY ( stu_nbr )
);

-- Alteriing UNIT Table: unique key
ALTER TABLE unit ADD CONSTRAINT unique_constraint_name UNIQUE ( unit_name );

-- Creating Enrolment Table
CREATE TABLE enrolment (
    stu_nbr          NUMERIC(8) NOT NULL,
    unit_code        CHAR(7) NOT NULL,
    enrol_year       NUMERIC(4) NOT NULL,
    enrol_semester   CHAR(1) NOT NULL,
    enrol_mark       NUMERIC(3),
    enrol_grade      CHAR(2),
    CONSTRAINT enrolment_pk PRIMARY KEY ( stu_nbr,
                                          unit_code,
                                          enrol_year,
                                          enrol_semester )
);

---Alteriing ENROLMENT Table:
ALTER TABLE enrolment ADD (
    CONSTRAINT check_enrol_sem CHECK ( enrol_semester IN (
        '1',
        '2',
        '3'
    ) ),
    CONSTRAINT fk_enrol_ref_unit FOREIGN KEY ( unit_code )
        REFERENCES unit ( unit_code )
            ON DELETE CASCADE,
    CONSTRAINT fk_enrol_ref_student FOREIGN KEY ( stu_nbr )
        REFERENCES student ( stu_nbr )
            ON DELETE CASCADE
);


DROP TABLE product CASCADE CONSTRAINTS;

DROP TABLE vendor CASCADE CONSTRAINTS;

DROP SEQUENCE product_prod_no_seq;

DROP SEQUENCE vendor_vendor_id_seq;

CREATE TABLE product (
    prod_no            NUMBER(4) NOT NULL,
    prod_name          VARCHAR2(50) NOT NULL,
    prod_price         NUMBER(6, 2) NOT NULL,
    prod_stock         NUMBER(3) NOT NULL,
    vendor_vendor_id   NUMBER(3) NOT NULL
);

ALTER TABLE product ADD CONSTRAINT product_pk PRIMARY KEY ( prod_no );

CREATE TABLE vendor (
    vendor_id      NUMBER(3) NOT NULL,
    vendor_name    VARCHAR2(50) NOT NULL,
    vendor_phone   CHAR(10) NOT NULL
);

ALTER TABLE vendor ADD CONSTRAINT vendor_pk PRIMARY KEY ( vendor_id );

ALTER TABLE vendor ADD CONSTRAINT vendor_un UNIQUE ( vendor_name );

ALTER TABLE product
    ADD CONSTRAINT product_vendor_fk FOREIGN KEY ( vendor_vendor_id )
        REFERENCES vendor ( vendor_id )
            ON DELETE CASCADE;


CREATE SEQUENCE product_prod_no_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE vendor_vendor_id_seq START WITH 1 INCREMENT BY 1;


---- Create a table called FIT5111_STUDENT
--CREATE TABLE FIT5111_STUDENT
--AS select * From enrolment
--where unit_code = 'FIT5111';
--commit;

-- Checking if the table exit
select tname from tab where tname = 'FIT5111_STUDENT';






SPOOL OFF

SET ECHO OFF
