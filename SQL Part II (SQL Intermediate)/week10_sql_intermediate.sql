SET ECHO ON
SPOOL week10_sql_intermediate_output.txt

/*
Databases Week 10 Tutorial
week10_sql_intermediate.sql

student name:CHUKWUDI ANYANWU
last modified date: 31/05/2020
*/

/* 1. Find the average mark of FIT1040 in semester 2, 2013. */

select unitcode, round(avg(mark),1) as "AVERAGE MARK"
from uni.enrolment
where unitcode = 'FIT1040' and TO_CHAR(ofyear,'YYYY' )= 2013 and semester = 2
group by unitcode;

/* 2. List the average mark for each offering of FIT1040.
In the listing, you need to include the year and semester number.
Sort the result according to the year..*/

select unitcode, round(avg(mark),2) as "average mark", TO_CHAR(ofyear,'YYYY' ) as year, semester
from uni.enrolment
where unitcode = 'FIT1040'
group by unitcode, ofyear,  semester;

/* 3. Find the number of students enrolled in the unit FIT1040 in the year 2013, under the following conditions: */
/* a. Repeat students are counted each time */
select count(1) from uni.enrolment
where unitcode = 'FIT1040' and TO_CHAR(ofyear,'YYYY' )= 2013;

/* b. Repeat students are only counted once */
select count(distinct studid) from uni.enrolment
where unitcode = 'FIT1040' and TO_CHAR(ofyear,'YYYY' )= 2013;

/* 4. Find the total number of prerequisite units for FIT2077. */

select unitcode, sum(1)as "total number"
from uni.prereq
where unitcode = 'FIT2077'
group by unitcode;

/* 5. Find the total number of prerequisite units for each unit.
In the list, include the unitcode for which the count is applicable.*/
select unitcode,count(1) as "total number"
from uni.prereq
group by unitcode;

/* 6. For each prerequisite unit, calculate how many times it has been used as prerequisite.
Include the name of the prerequisite unit in the listing .*/
select r.has_prereq_of, u.unitname,  count(1) as total
From uni.unit u join uni.prereq r on r.has_prereq_of = u.unitcode
group by has_prereq_of, unitname;

/* 7. Find the unit with the highest number of enrolments in a given offering in the year 2013. */

select unitcode, semester, count(studid)as student_num
from uni.enrolment
where TO_CHAR(ofyear,'YYYY' )= 2013
group by unitcode, semester, ofyear
having count(studid) =  ( select max(count(studid))
                          from uni.enrolment
                          where TO_CHAR(ofyear,'YYYY' )= 2013
                          group by unitcode, semester, ofyear );

/* 8. Find all students enrolled in FIT1004 in semester 1, 2013
who have scored more than the average mark of FIT1004 in the same offering?
Display the students' name and the mark.
Sort the list in the order of the mark from the highest to the lowest.*/

select s.studfname, s.studlname, e.mark
from uni.enrolment e join uni.student s on s.studid = e.studid
where e.unitcode = 'FIT1040' and e.semester = 1
group by s.studfname, s.studlname, e.mark
HAVING   mark >
            (select round(avg(mark),2) as mark
            from uni.enrolment
            where unitcode = 'FIT1040' and semester = 1);


SPOOL OFF
SET ECHO OFF
