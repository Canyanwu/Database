--Q1b-tds-dm.sql
--Student ID:   
--Student Name: CHUKWUDI ANYANWU


SET SERVEROUTPUT ON;

/* Comments for your marker:
*/

/*
1b(i) Create a sequence
*/
--create sequence
-- drop sequence if already exited
Drop SEQUENCE offence_seq;
-- if sequence does not exit, create sequence
CREATE SEQUENCE offence_seq START WITH 100 INCREMENT BY 1;

/*
1b(ii) Take the necessary steps in the database to record data.
*/

INSERT INTO offence VALUES (offence_seq.nextval, TO_DATE('10-AUG-2019 08:04 AM', 'DD-MON-YYYY HH:MI AM'), '123 south street, Noranda',(select dem_code from demerit
where dem_description = 'Blood alcohol charge'), 10000011, 100389, 'JYA3HHE05RA070562');
INSERT INTO offence VALUES (offence_seq.nextval, TO_DATE('16-OCT-2019 09:00 PM', 'DD-MON-YYYY HH:MI AM'), '88A bronx street, Narre Warren',(select dem_code from demerit
where dem_description = 'Level crossing offence'), 10000015, 100389, 'JYA3HHE05RA070562');
INSERT INTO offence VALUES (offence_seq.nextval, TO_DATE('07-JAN-2020 07:07 AM', 'DD-MON-YYYY HH:MI AM'), '14 station street, Oakleigh',(select dem_code from demerit
where dem_description = 'Exceeding the speed limit by 25 km/h or more'), 10000015, 100389, 'JYA3HHE05RA070562');

commit;

/*
1b(iii) Take the necessary steps in the database to record changes.
*/
UPDATE offence
SET dem_code = (select d.dem_code from demerit d  where d.dem_description = 'Exceeding the speed limit by 10 km/h or more but less than 25 km/h')
where lic_no = 100389 and TO_CHAR(off_datetime,'DD-MON-YYYY HH:MI AM') = '07-JAN-2020 07:07 AM';

commit;
