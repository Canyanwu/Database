--Q2-tds-queries.sql
--Student ID:
--Student Name:CHUKWUDI ANYANWU


/* Comments for your marker:

*/

/*
2(i) Query 1
*/

SELECT dem_points as "Demerit Points", dem_description as "Demerit Description"
FROM demerit
WHERE dem_description LIKE '%heavy%'
OR dem_description LIKE '%Heavy%'
OR dem_description LIKE 'Exceed%'
ORDER BY dem_points, dem_description ;


/*
2(ii) Query 2
*/

SELECT veh_maincolor as "Main Colour", veh_vin as VIN, to_char(veh_yrmanuf, 'YYYY') as "Year Manufactured"
FROM vehicle
WHERE (veh_modname LIKE '%Range Rover%' OR veh_modname LIKE '%Range Rover Sport%')
AND veh_yrmanuf BETWEEN TO_DATE('2012', 'YYYY') AND TO_DATE('2014', 'YYYY')
order by veh_yrmanuf desc, veh_maincolor asc;

/*
2(iii) Query 3
*/

SELECT lic_no as "Licence No.", lic_fname ||' '|| lic_lname as "Driver Fullname", to_char(lic_dob, 'DD-MON-YYYY') as DOB, lic_street ||' '|| lic_town ||' '|| lic_postcode as "Driver Address", sus_date as "Suspended On", sus_enddate as "Suspended Till"
FROM driver natural join suspension
where sus_date <= ADD_MONTHS(TRUNC(SYSDATE), -30)
order by lic_no asc, sus_date desc;

/*
2(iv) Query 4
*/

select e.dem_code as "Demerit Code", e.dem_description as "Demerit Description", count(1) as "Total Offences (All Months)", sum((case when to_char(off_datetime,'MON') = 'JAN' then 1 else 0 end )) Jan,
    sum((case when to_char(off_datetime,'MON') = 'FEB' then 1 else 0 end )) Feb,
    sum((case when to_char(off_datetime,'MON') = 'MAR' then 1 else 0 end )) Mar,
    sum((case when to_char(off_datetime,'MON') = 'APR' then 1 else 0 end )) Apr,
    sum((case when to_char(off_datetime,'MON') = 'MAY' then 1 else 0 end )) May,
    sum((case when to_char(off_datetime,'MON') = 'JUN' then 1 else 0 end )) Jun,
    sum((case when to_char(off_datetime,'MON') = 'JUL' then 1 else 0 end )) Jul,
    sum((case when to_char(off_datetime,'MON') = 'AUG' then 1 else 0 end )) Aug,
    sum((case when to_char(off_datetime,'MON') = 'SEP' then 1 else 0 end )) Sep,
    sum((case when to_char(off_datetime,'MON') = 'OCT' then 1 else 0 end )) Oct,
    sum((case when to_char(off_datetime,'MON') = 'NOV' then 1 else 0 end )) Nov,
    sum((case when to_char(off_datetime,'MON') = 'DEC' then 1 else 0 end )) Dec
from demerit e join offence o on e.dem_code = o.dem_code
group by e.dem_code, e.dem_description
order by count(1) desc, e.dem_code asc;


/*
2(v) Query 5
*/
SELECT * FROM
(
select v.veh_manufname  as "Manufacturer Name", count(1) as "Total No. of Offences"
from offence o
join vehicle v on v.veh_vin = o.veh_vin
join demerit d on o.dem_code = d.dem_code
where d.dem_points >= 2
group by v.veh_manufname
order by count(1) desc, v.veh_manufname asc
) resultSet
WHERE ROWNUM=1;


/*
2(vi) Query 6
*/

with drivers_booked as (
    select o.lic_no, d.lic_fname, d.lic_lname, f.officer_id ,f.officer_fname, f.officer_lname, count(1) as total
    from offence o
    join driver d on d.lic_no = o.lic_no
    join officer f on o.officer_id = f.officer_id and d.lic_lname = f.officer_lname
    group by o.lic_no, d.lic_fname, d.lic_lname, f.officer_id ,f.officer_fname, f.officer_lname )
select lic_no as "Licence No.", lic_fname ||' '|| lic_lname as "Driver Name", officer_id as "Officer ID", officer_fname ||' '|| officer_lname as "Officer Name"
from drivers_booked
where total > 1
order by lic_no asc;


/*
2(vii) Query 7
*/

with grouped as (select b.dem_code, r.lic_no, b.total1
    from
        (select dem_code, max(cnt) as total1
        from
            (select offence.dem_code, offence.lic_no, count(offence.lic_no) as cnt
            from offence
            group by offence.dem_code, offence.lic_no)
        group by dem_code ) b
    inner join
        (select dem_code, lic_no, max(cnt) as total1
        from
            (select offence.dem_code, offence.lic_no, count(offence.lic_no) as cnt
            from offence
            group by offence.dem_code, offence.lic_no)
        group by dem_code, lic_no) r
    on b.dem_code = r.dem_code and b.total1 = r. total1)
select grouped.dem_code as "Demerit Code", e.dem_description as "Demerit Description", grouped.lic_no as "Licence No.", d.lic_fname ||' '|| d.lic_lname as "Driver Fullname", total1 as "Total Times Booked"
from grouped
join driver d on d.lic_no = grouped.lic_no
join demerit e on grouped.dem_code = e.dem_code
order by grouped.dem_code asc, grouped.lic_no asc;

/*
2(viii) Query 8
*/
select coalesce(Region, 'Total') AS Region, count(*) as "Total Vehicles Manufactured", LPAD(concat(to_char(count(*) * 100 / sum(case when grouping_id(region) = 0 then count(*) end) over (), 'fm9999999999999999999990D00'), '%'), 30) as "Percentage of Vehicles Manufactured"
from(
    select
      case
          when substr(veh_vin,1,1) between 'A' and 'C' then 'Africa'
          when substr(veh_vin,1,1) between 'J' and 'R' then 'Asia'
          when substr(veh_vin,1,1) between 'S' and 'Z' then 'Europe'
          when substr(veh_vin,1,1) between '1' and '5' then 'North America'
          when substr(veh_vin,1,1) between '6' and '7' then 'Oceania'
          when substr(veh_vin,1,1) between '8' and '9' then 'South America'
          else 'Unknown'
      end as Region,
      veh_vin
  from vehicle
  )
group by ROLLUP(Region)
order by count(veh_vin), Region;
