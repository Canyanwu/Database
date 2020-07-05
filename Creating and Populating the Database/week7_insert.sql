

--Title :           Tutorial 7: CREATING TABLES
--Student Name:     CHUKWUDI ANYANWU




SET ECHO ON
SPOOL week7_insert_output.txt

Drop Table FIT5111_STUDENT Purge;

---STUDENT
INSERT INTO STUDENT VALUES (11111111, 'Bloggs',  'Fred', '1-Jan-1990');
INSERT INTO STUDENT VALUES (11111112, 'Nice',    'Nick', '10-Oct-1994');
INSERT INTO STUDENT VALUES (11111113, 'Wheat',   'Wendy','5-May-1990');
INSERT INTO STUDENT VALUES (11111114, 'Sheen',   'Cindy','25-Dec-1996');


---UNIT
INSERT INTO UNIT VALUES ('FIT9999',  'FIT Last Unit');
INSERT INTO UNIT VALUES ('FIT5132',  'Introduction to Databases');
INSERT INTO UNIT VALUES ('FIT5016',  'Project');
INSERT INTO UNIT VALUES ('FIT5111',  'Student''s Life');

---ENROLMENT
INSERT INTO ENROLMENT VALUES (11111111, 'FIT5132', 2013, '1', 35, 'N');
INSERT INTO ENROLMENT VALUES (11111111, 'FIT5016', 2013, '1', 61, 'C');
INSERT INTO ENROLMENT VALUES (11111111, 'FIT5132', 2013, '2', 42, 'N');

INSERT INTO ENROLMENT VALUES (11111111, 'FIT5111', 2013, '2', 76, 'D');
INSERT INTO ENROLMENT VALUES (11111111, 'FIT5132', 2014, '2', NULL, NULL);
INSERT INTO ENROLMENT VALUES (11111112, 'FIT5132', 2013, '2', 83, 'HD');

INSERT INTO ENROLMENT VALUES (11111112, 'FIT5111', 2013, '2', 79, 'D');
INSERT INTO ENROLMENT VALUES (11111113, 'FIT5132', 2014, '2', NULL, NULL);
INSERT INTO ENROLMENT VALUES (11111113, 'FIT5111', 2014, '2', NULL, NULL);
INSERT INTO ENROLMENT VALUES (11111114, 'FIT5111', 2014, '2', NULL, NULL);


CREATE SEQUENCE STUDENT_SEQ START WITH 11111115 INCREMENT by 1;

INSERT INTO STUDENT VALUES (STUDENT_SEQ.nextval, 'Mickey', 'Mouse','29-Nov-1999');
INSERT INTO ENROLMENT VALUES (STUDENT_SEQ.currval, 'FIT5132', 2016, '2', NULL, NULL);

-- Add Vendor 1 and the products they supply
insert into vendor values (VENDOR_vendor_id_SEQ.nextval,'Western Digital', '1234567890');
insert into product values (PRODUCT_prod_no_SEQ.nextval,'2TB My Cloud Drive',195,5,VENDOR_vendor_id_SEQ.currval);
insert into product values (PRODUCT_prod_no_SEQ.nextval,'1TB Portable Hard Drive',76,4,VENDOR_vendor_id_SEQ.currval);
insert into product values (PRODUCT_prod_no_SEQ.nextval,'Live Media Player',119,2,VENDOR_vendor_id_SEQ.currval);
commit;

-- Add Vendor 2 and the products they supply
insert into vendor values (VENDOR_vendor_id_SEQ.nextval,'Seagate','2468101234');
insert into product values (PRODUCT_prod_no_SEQ.nextval,'2TB Desktop Drive',94,12,VENDOR_vendor_id_SEQ.currval);
insert into product values (PRODUCT_prod_no_SEQ.nextval,'4TB 4 Bay NAS',76,4,VENDOR_vendor_id_SEQ.currval);
insert into product values (PRODUCT_prod_no_SEQ.nextval,'2TB Central Personal Storage' ,169,5,VENDOR_vendor_id_SEQ.currval);


INSERT INTO product VALUES (
    product_prod_no_seq.NEXTVAL,'GoFlex Thunderbolt Adaptor', 134, 2,
    (
        SELECT vendor_id
        FROM vendor
        WHERE vendor_name = 'Seagate'
    )
);

-- Inserting new student into Student Table and Enrolment Table (James Flow, 25-Nov-1977 undertaking Introduction to Databases)
INSERT ALL
INTO STUDENT (stu_nbr, stu_lname, stu_fname, stu_dob) VALUES (STUDENT_SEQ.nextval, 'James', 'Flow', '25-Nov-1977')
INTO ENROLMENT (stu_nbr, unit_code, enrol_year, enrol_semester, enrol_mark, enrol_grade ) VALUES (STUDENT_SEQ.currval, code, 2015, '2', 50, 'C')
SELECT unit_code AS code FROM unit where unit_name = 'Introduction to Databases' ;

-- Creating Table FIT5111_STUDENT that contains all enrolments for the unit FIT5111
CREATE TABLE FIT5111_STUDENT
AS select * From enrolment
where unit_code = 'FIT5111';
commit;

-- Checking if the table exit
select tname from tab where tname = 'FIT5111_STUDENT';


-- List the contents of the table
SELECT
    *
FROM
    fit5111_student;


COMMIT;

SPOOL OFF
SET ECHO OFF
