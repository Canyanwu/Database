
--Title :           Tutorial 9 : UPDATE & DELETE
--Student Name:     CHUKWUDI ANYANWU



SET ECHO ON
SPOOL week9_dml_output.txt

---Update the unit name of FIT9999 from 'FIT Last Unit' to 'place holder unit'.
UPDATE unit
SET unit_name = 'place holder unit'
WHERE unit_name = 'FIT Last Unit' AND unit_code ='FIT9999';

--Enter the mark and grade for the student with the student number of 11111113 for the unit
--code FIT5132 that the student enrolled in semester 2 of 2014. The mark is 75 and the grade
--is D.
UPDATE enrolment
SET enrol_mark = 75, enrol_grade = 'D'
WHERE stu_nbr = 11111113 AND unit_code = 'FIT5132' AND enrol_year = 2014 AND enrol_semester = '2';

--Change the database to reflect the new grade classification.
--UPDATE enrolment
--SET enrol_grade = 'P1' WHERE enrol_mark >= 45 and enrol_mark  <= 54;
--UPDATE enrolment
--SET enrol_grade = 'P2' WHERE enrol_mark >= 55 and enrol_mark  <= 64;
--UPDATE enrolment
--SET enrol_grade = 'C' WHERE enrol_mark >= 65 and enrol_mark  <= 74;
--UPDATE enrolment
--SET enrol_grade = 'D' WHERE enrol_mark >= 75 and enrol_mark  <= 84;
--UPDATE enrolment
--SET enrol_grade = 'HD' WHERE enrol_mark >= 85 and enrol_mark  <= 100;

--Better Way of updating table at once.

UPDATE enrolment set enrol_grade = CASE
    WHEN enrol_mark >= 0
         AND enrol_mark <= 44 THEN
        'N'
    WHEN enrol_mark >= 45
         AND enrol_mark <= 54 THEN
        'P1'
    WHEN enrol_mark >= 55
         AND enrol_mark <= 64 THEN
        'P2'
    WHEN enrol_mark >= 65
         AND enrol_mark <= 74 THEN
        'C'
    WHEN enrol_mark >= 75
         AND enrol_mark <= 84 THEN
        'D'
    WHEN enrol_mark >= 85
         AND enrol_mark <= 100 THEN
        'HD'
    ELSE
        NULL
    END;



--A student with student number 11111114 has taken intermission in semester 2 2014, hence
--all the enrolment of this student for semester 2 2014 should be removed. Change the
--database to reflect this situation.
DELETE FROM enrolment
WHERE (stu_nbr = '11111114' AND enrol_year = 2014 AND enrol_semester = '2');

--Assume that Wendy Wheat (student number 11111113) has withdrawn from the university.
--Remove her details from the database.
DELETE FROM enrolment WHERE (stu_nbr = '11111113');
DELETE FROM student WHERE (stu_nbr = '11111113');

--Add Wendy Wheat back to the database (use the INSERT statements you have created
--when completing module Tutorial 7 SQL Data Definition Language DDL).
insert into student values (11111113, 'Wheat','Wendy','05-May-1990');
insert into enrolment values (11111113, 'FIT5111',2014,'2',null,null);

--Change the FOREIGN KEY constraints definition for table STUDENT
ALTER TABLE enrolment
DROP CONSTRAINT fk_enrolment_student;

ALTER TABLE enrolment
ADD CONSTRAINT fk_enrol_ref_student FOREIGN KEY ( stu_nbr )
        REFERENCES student ( stu_nbr )
            ON DELETE CASCADE;

--- With ON DELETE CASCADE Constraint deleting the row in the  parent class automaticaly deleted the row in the child class.
--- Wendy Wheat was automaticaly deleted from the enrolment table when deleted from the student table


COMMIT;

SPOOL OFF
SET ECHO OFF
