
SET ECHO ON
SPOOL Week8_SQLBasic_PartB_output.txt

/*
Databases Week 8 Tutorial Sample Solution
week8_SQLBasic_PartB.sql

--Student Name:     CHUKWUDI ANYANWU
last modified date: 16/05/2020

*/

/* B1. List all the unit codes, semester and name of the chief examiner for all
   the units that are offered in 2014.*/

SELECT
    o.unitcode,
    o.semester,
    s.stafffname,
    s.stafflname
FROM
    uni.offering   o
    JOIN uni.staff s ON s.staffid = o.chiefexam
WHERE
    to_char(ofyear, 'YYYY') = 2014
ORDER BY
    unitcode;

/* B2. List all the unit codes and the unit names and their year and semester
      offerings. To display the date correctly in Oracle, you need to use to_char function.
      For example, to_char(ofyear,'YYYY'). */

SELECT
    unitcode,
    unitdesc,
    to_char(ofyear, 'YYYY') AS "Year",
    semester
FROM
    ( uni.offering
    NATURAL JOIN uni.unit )
ORDER BY
    unitcode,
    unitdesc,
    ofyear;

/* B3. List the unit code, semester, class type (lecture or tutorial),
      day and time for all units taught by Albus Dumbledore in 2013.
      Sort the list according to the unit code.*/

SELECT
    c.unitcode,
    c.semester,
    c.cltype,
    c.clday,
    c.cltime
FROM
    uni.schedclass c
    NATURAL JOIN uni.staff s
WHERE
    s.stafffname = 'Albus'
    AND s.stafflname = 'Dumbledore'
    AND to_char(ofyear, 'YYYY') = 2013
ORDER BY
    c.unitcode;

/* B4. Create a study statement for Mary Smith. A study statement contains
      unit code, unit name, semester and year study was attempted, the mark
      and grade. */

SELECT
    u.unitcode,
    u.unitname,
    e.semester,
    to_char(ofyear, 'YYYY') AS "Year",
    e.mark,
    e.grade
FROM
    ( ( uni.enrolment   e
    JOIN uni.student     s ON s.studid = e.studid ) )
    JOIN uni.unit        u ON u.unitcode = e.unitcode
WHERE
    s.studfname = 'Mary'
    AND s.studlname = 'Smith'
ORDER BY
    u.unitcode;

/* B5. List the unit code and unit name of the pre-requisite units of
      'Advanced Data Management' unit */

SELECT
    u.unitcode,
    u.unitname
FROM
    uni.unit u
WHERE
    u.unitcode IN (
        SELECT
            r.has_prereq_of
        FROM
            uni.unit     u
            NATURAL JOIN uni.prereq   r
        WHERE
            u.unitname = 'Advanced Data Management'
    );

/* B6. Find all students (list their id, firstname and surname) who
       have a failed unit in the year 2013 */

SELECT
    s.studid,
    s.studfname,
    s.studlname
FROM
    ( ( uni.enrolment   e
    JOIN uni.student     s ON s.studid = e.studid ) )
WHERE
    e.grade = 'N'
    AND to_char(e.ofyear, 'YYYY') = 2013
ORDER BY
    e.studid;

/* B7.	List the student name, unit code, semester and year for those
        students who do not have marks recorded */

SELECT
    s.studfname,
    s.studlname,
    e.unitcode,
    e.semester,
    to_char(ofyear, 'YYYY') AS "Year"
FROM
    ( ( uni.enrolment   e
    JOIN uni.student   s ON s.studid = e.studid ) )
WHERE
    e.mark IS NULL
ORDER BY
    e.studid;



SPOOL OFF
SET ECHO OFF
