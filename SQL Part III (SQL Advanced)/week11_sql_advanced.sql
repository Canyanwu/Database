SET ECHO ON
SPOOL week11_sql_advanced_output.txt

/*
Databases Week 11 Tutorial
week11_sql_advanced.sql


student name:CHUKWUDI ANYANWU
last modified date: 31/05/2020

*/

/* 1. Find the number of scheduled classes assigned to each staff member each year and semester.
If the number of classes is 2 then this should be labelled as a correct load,
more than 2 as an overload and less than 2 as an underload.
Order the list by decreasing order of scheduled class number. */

select to_char(ofyear, 'YYYY')as Year, semester, s.staffid,  s.stafffname, s.stafflname,count(*) as Numberclasses,
    case
        when count(*) > 2 then 'overload'
        when count(*) = 2 then 'Correct load'
        else 'underload'
        end as LOAD
from uni.schedclass c join uni.staff s on c.staffid = s.staffid
group by  ofyear, semester, s.staffid,  s.stafffname, s.stafflname
order by Numberclasses;


/* 2. Display unit code and unitname for units that do not have a prerequisite.
Order the list in increasing order of unit code.

There are many approaches that you can take in writing an SQL statement to answer this query.
You can use the SET OPERATORS, OUTER JOIN and a SUBQUERY.
Write SQL statements based on all of these approaches.*/


select u.unitcode, u.unitname from uni.unit u
where u.unitcode not in (select p.unitcode from UNI.prereq p)
order by u.unitcode;


/* 3. List all units offered in 2013 semester 2 which do not have any scheduled class.
Include unit code, unit name, and chief examiner name in the list.
Order the list based on the unit code. */

select o.unitcode, u.unitname, s.stafffname ||' '|| s.stafflname as CE_NAME
from uni.offering o
join uni.unit u on o.unitcode = u.unitcode
join uni.staff s on o.chiefexam = s.staffid
where o.semester = 2 and o.unitcode not in (select unitcode from uni.schedclass
where semester = 2)
order by o.unitcode;

/* 4. List full names of students who are enrolled in both Introduction to Databases and Programming Foundations
(note: unit names are unique). Order the list by student full name.*/

select s.studfname ||' '|| s.studlname as STUDENT_FULL_NAME from UNI.student s
join (select studid from uni.enrolment natural join uni.unit where unitname = 'Introduction to Databases'
intersect
select studid from uni.enrolment natural join uni.unit where unitname = 'Programming Foundations') l
on s.studid = l.studid
order by STUDENT_FULL_NAME;

/* 5. Given that payment rate for tutorial is $42.85 per hour and  payemnt rate for lecture is $75.60 per hour,
calculate weekly payment per type of class for each staff.
In the display, include staff name, type of class (lecture or tutorial),
number of classes, number of hours (total duration), and weekly payment (number of hours * payment rate).
Order the list by increasing order of staff name*/

With CTE as (select cltype, count(cltype) as NO_OF_CLASSES, sum(clduration) as TOTAL_HOURS, staffid,
    case
      when cltype = 'L' then  75.60
      when cltype = 'T' then  42.85
    end as multiplier
from uni.schedclass
group by cltype, staffid)
select s.stafffname ||' '|| s.stafflname as STAFFNAME, CTE.cltype as TYPE, NO_OF_CLASSES, TOTAL_HOURS, to_char((multiplier * TOTAL_HOURS), '$999,999.00') as WEEKLY_PAYMENT
FROM CTE join uni.staff s on CTE.staffid = s.staffid
order by STAFFNAME,CTE.cltype;

/* 6. Assume that all units worth 6 credit points each, calculate each student�s Weighted Average Mark (WAM) and GPA.
Please refer to these Monash websites: https://www.monash.edu/exams/results/wam and https://www.monash.edu/exams/results/gpa
for more information about WAM and GPA respectively.

Calculation example for student 111111111:
WAM = (65x3 + 45x3 + 74x3 +74*6)/(3+3+3+6) = 66.4
GPA = (2x6 + 0.3x6 + 3x6 + 3x6)/(6+6+6+6) = 2.08

Include student id, student full name (in a 40 character wide column headed �Student Full Name�), WAM and GPA in the display.
Order the list by descending order of WAM then descending order of GPA.
*/


SELECT
    studid,
    rpad(studfname
         || ' '
         || studlname, 40, ' ') AS "Student Full Name",
    to_char(SUM(
        CASE substr(unitcode, 4, 1)
            WHEN '1' THEN
                mark * 3
            ELSE
                mark * 6
        END
    ) / SUM(
        CASE substr(unitcode, 4, 1)
            WHEN '1' THEN
                3
            ELSE
                6
        END
    ), '990.99') AS wam,
    to_char(SUM(
        CASE grade
            WHEN 'N'    THEN
                0.3
            WHEN 'P'    THEN
                1
            WHEN 'C'    THEN
                2
            WHEN 'D'    THEN
                3
            WHEN 'HD'   THEN
                4
        END
        * 6) /(COUNT(unitcode) * 6), '990.99') AS gpa
FROM
    uni.enrolment
    NATURAL JOIN uni.student
GROUP BY
    studid,
    studfname,
    studlname
ORDER BY
    wam DESC,
    gpa DESC;



SPOOL OFF
SET ECHO OFF
