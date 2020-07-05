--Q3-tds-mods.sql
--Student ID:   
--Student Name: CHUKWUDI ANYANWU


/* Comments for your marker:
I did not add any revoked offence in my revoked table because I have only 52 offences
and its 1% is less than 1.

*/


/*
3(i) Changes to live database 1
*/
-- add column total_number_of_drivers_booked
ALTER TABLE officer
  ADD (total_number_of_drivers_booked Number(3));

-- update total_number_of_drivers_booked in the table officer
update officer
set total_number_of_drivers_booked =
(
  select count(*)
  from offence
  where offence.officer_id = officer.officer_id
);

commit;

/*
3(ii) Changes to live database 2
*/
-- Drop Table Statement
DROP TABLE revoked cascade constraints PURGE;

-- add column "revoked"
ALTER TABLE offence
  ADD (revoked char(3) NOT NULL );

-- add constraint for revoked column
ALTER TABLE offence
  ADD CONSTRAINT check_revoked CHECK (revoked IN ('Yes', 'No'));

-- create revoked table
CREATE TABLE revoked (
    off_no         NUMBER(7) NOT NULL,
    revoked_datetime      DATE NOT NULL,
    revoked_by_fname      VARCHAR2(30) NOT NULL,
    revoked_by_lname      VARCHAR2(30) NOT NULL,
    revoked_reason     CHAR(3) NOT NULL);

-- adding constraints
ALTER TABLE revoked
    ADD constraint revoked_pk primary key(off_no, revoked_datetime);
ALTER TABLE revoked
    ADD constraint revoked_fk foreign key(off_no) references offence(off_no);
ALTER TABLE revoked
    ADD CONSTRAINT check_revoked_reason CHECK (revoked_reason IN ('FOS', 'FEU', 'DOU', 'COH', 'EIP'));

-- Change all data in the current office table to revoked : No
update offence
  set revoked = 'No';

commit;

/*
3(iii) Changes to live database 3
*/

-- drop exiting table and sequence
-- Tables
DROP TABLE colour cascade constraints PURGE;
DROP TABLE veh_outer_part cascade constraints PURGE;
DROP TABLE veh_outer_body_part cascade constraints PURGE;

-- Sequence
DROP SEQUENCE colour_seq;

-- Create Table
CREATE TABLE colour (
    colour_id       NUMBER(3) NOT NULL,
    colour_desc      VARCHAR2(20) NOT NULL
);
-- Add constraint
ALTER TABLE colour ADD CONSTRAINT colour_pk PRIMARY KEY ( colour_id );

-- creating sequence that start from 50
CREATE SEQUENCE colour_seq START WITH 50 INCREMENT BY 1;

-- Insert all the distinct colors from vehicle into the newly created table
INSERT INTO colour (colour_id, colour_desc)
SELECT colour_seq.nextval, veh_maincolor
FROM
(
    SELECT DISTINCT veh_maincolor FROM vehicle
);
commit;


-- Creating table to store the outer parts
Create table veh_outer_part
(
  veh_outer_part_code CHAR(2) NOT NULL,
  veh_outer_part_name VARCHAR2(20) NOT NULL
);

-- Add constraint
ALTER TABLE veh_outer_part ADD CONSTRAINT veh_outer_part_pk PRIMARY KEY ( veh_outer_part_code );

-- Inserting the three body parts TDS is interested in at the moment.
INSERT INTO veh_outer_part VALUES ('SP', 'Spoiler');
INSERT INTO veh_outer_part VALUES ('BM', 'Bumper');
INSERT INTO veh_outer_part VALUES ('GR', 'Grilles');

commit;

-- creating table to store vehicles and its outer body part colours
Create table veh_outer_body_part
(
  veh_vin             CHAR(17) NOT NULL,
  veh_outer_part_code CHAR(2) NOT NULL,
  colour_id           NUMBER(5) NOT NULL
);

-- adding constraints
ALTER TABLE veh_outer_body_part
    ADD constraint veh_out_pk primary key(veh_vin, veh_outer_part_code);
ALTER TABLE veh_outer_body_part
    ADD constraint veh_vin_fk foreign key(veh_vin) references vehicle(veh_vin);
ALTER TABLE veh_outer_body_part
    ADD constraint body_part_code_fk foreign key(veh_outer_part_code) references veh_outer_part(veh_outer_part_code);
ALTER TABLE veh_outer_body_part
   ADD constraint colour_id_fk foreign key(colour_id) references colour (colour_id);

-- Inserting outer body parts colours  into into vehicles in the  veh_outer_body_part table

Insert into veh_outer_body_part VALUES ('KM8JUCBC0A0015290','SP',50);
Insert into veh_outer_body_part VALUES ('ZFF74UFA1D0195883','GR',51);
Insert into veh_outer_body_part VALUES ('WB10172A0YZE32655','SP',52);
Insert into veh_outer_body_part VALUES ('WB10172A0YZE32655','BM',53);
Insert into veh_outer_body_part VALUES ('KMHDU45D19U618647','SP',50);
Insert into veh_outer_body_part VALUES ('ZHWBE37S09LA03599','GR',51);
Insert into veh_outer_body_part VALUES ('WDDHF8JB7CA658175','SP',52);
Insert into veh_outer_body_part VALUES ('WDDHF8JB7CA658175','BM',63);

commit;
