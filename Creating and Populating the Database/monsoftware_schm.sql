-- CHUKWUDI ANYANWU



CREATE TABLE Team (
  Team_no        NUMERIC(3) NOT NULL,
  Emp_no         NUMERIC(5) NOT NULL
 );

CREATE TABLE Employee (
  amp_no            NUMERIC(5),
  emp_fname         VARCHAR(30),
  emp_lname         VARCHAR(30),
  emp_street        VARCHAR(50) NOT NULL,
  emp_town          VARCHAR(30) NOT NULL,
  emp_pcode         CHAR(4) NOT NULL,
  emp_dob           CHAR(4) NOT NULL,
  amp_taxno         VARCHAR(20),
  team_no           NUMERIC(3),
  mentor_no         NUMERIC(5)
  );

ALTER TABLE TEAM CONSTRAINT team_pk PRIMARY KEY (team_no);
ALTER TABLE EMPLOYEE CONSTRAINT employee_pk PRIMARY KEY (amp_no);

ALTER TABLE TEAM
    ADD CONSTRAINT fk_emp_no FOREIGN KEY (emp_no) REFERENCES Employee (emp_no)
    ON DELETE SET NULL ;

ALTER TABLE EMPLOYEE
    ADD CONSTRAINT fk_mentor_no FOREIGN KEY (mentor_no) REFERENCES Employee (mentor_no)
    ON DELETE SET NULL ;

ALTER TABLE EMPLOYEE
    ADD CONSTRAINT fk_team_em FOREIGN KEY(team_no) REFERENCES Team (team_no)
    ON DELETE SET NULL ;
