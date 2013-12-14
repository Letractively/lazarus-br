CREATE GENERATOR CUST_NO_GEN;
CREATE GENERATOR EMP_NO_GEN;

CREATE DOMAIN ADDRESSLINE
 AS Varchar(30)
 COLLATE NONE;
CREATE DOMAIN BUDGET
 AS Decimal(12,2)
 DEFAULT 50000
 CHECK (VALUE > 10000 AND VALUE <= 2000000)
;
CREATE DOMAIN COUNTRYNAME
 AS Varchar(15)
 COLLATE NONE;
CREATE DOMAIN CUSTNO
 AS Integer
 CHECK (VALUE > 1000)
;
CREATE DOMAIN DEPTNO
 AS Char(3)
 CHECK (VALUE = '000' OR (VALUE > '0' AND VALUE <= '999') OR VALUE IS NULL)
 COLLATE NONE;
CREATE DOMAIN EMPNO
 AS Smallint
;
CREATE DOMAIN FIRSTNAME
 AS Varchar(15)
 COLLATE NONE;
CREATE DOMAIN JOBCODE
 AS Varchar(5)
 CHECK (VALUE > '99999')
 COLLATE NONE;
CREATE DOMAIN JOBGRADE
 AS Smallint
 CHECK (VALUE BETWEEN 0 AND 6)
;
CREATE DOMAIN LASTNAME
 AS Varchar(20)
 COLLATE NONE;
CREATE DOMAIN PHONENUMBER
 AS Varchar(20)
 COLLATE NONE;
CREATE DOMAIN PONUMBER
 AS Char(8)
 CHECK (VALUE STARTING WITH 'V')
 COLLATE NONE;
CREATE DOMAIN PRODTYPE
 AS Varchar(12)
 DEFAULT 'software'
 NOT NULL
 CHECK (VALUE IN ('software', 'hardware', 'other', 'N/A'))
 COLLATE NONE;
CREATE DOMAIN PROJNO
 AS Char(5)
 CHECK (VALUE = UPPER (VALUE))
 COLLATE NONE;
CREATE DOMAIN SALARY
 AS Numeric(10,2)
 DEFAULT 0
 CHECK (VALUE > 0)
;

SET TERM ^ ;
CREATE PROCEDURE ADD_EMP_PROJ (
    EMP_NO Smallint,
    PROJ_ID Char(5) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE ALL_LANGS
RETURNS (
    CODE Varchar(5),
    GRADE Varchar(5),
    COUNTRY Varchar(15),
    LANG Varchar(15) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE DELETE_EMPLOYEE (
    EMP_NUM Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE DEPT_BUDGET (
    DNO Char(3) )
RETURNS (
    TOT Decimal(12,2) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE GET_EMP_PROJ (
    EMP_NO Smallint )
RETURNS (
    PROJ_ID Char(5) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE MAIL_LABEL (
    CUST_NO Integer )
RETURNS (
    LINE1 Char(40),
    LINE2 Char(40),
    LINE3 Char(40),
    LINE4 Char(40),
    LINE5 Char(40),
    LINE6 Char(40) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE ORG_CHART
RETURNS (
    HEAD_DEPT Char(25),
    DEPARTMENT Char(25),
    MNGR_NAME Char(20),
    TITLE Char(5),
    EMP_CNT Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE SHIP_ORDER (
    PO_NUM Char(8) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE SHOW_LANGS (
    CODE Varchar(5),
    GRADE Smallint,
    CTY Varchar(15) )
RETURNS (
    LANGUAGES Varchar(15) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE SUB_TOT_BUDGET (
    HEAD_DEPT Char(3) )
RETURNS (
    TOT_BUDGET Decimal(12,2),
    AVG_BUDGET Decimal(12,2),
    MIN_BUDGET Decimal(12,2),
    MAX_BUDGET Decimal(12,2) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

CREATE TABLE COUNTRY
(
  COUNTRY COUNTRYNAME NOT NULL,
  CURRENCY Varchar(10) NOT NULL,
  PRIMARY KEY (COUNTRY)
);
CREATE TABLE CUSTOMER
(
  CUST_NO CUSTNO NOT NULL,
  CUSTOMER Varchar(25) NOT NULL,
  CONTACT_FIRST FIRSTNAME,
  CONTACT_LAST LASTNAME,
  PHONE_NO PHONENUMBER,
  ADDRESS_LINE1 ADDRESSLINE,
  ADDRESS_LINE2 ADDRESSLINE,
  CITY Varchar(25),
  STATE_PROVINCE Varchar(15),
  COUNTRY COUNTRYNAME,
  POSTAL_CODE Varchar(12),
  ON_HOLD Char(1) DEFAULT NULL,
  PRIMARY KEY (CUST_NO)
);
CREATE TABLE DEPARTMENT
(
  DEPT_NO DEPTNO NOT NULL,
  DEPARTMENT Varchar(25) NOT NULL,
  HEAD_DEPT DEPTNO,
  MNGR_NO EMPNO,
  BUDGET BUDGET DEFAULT 50000,
  LOCATION Varchar(15),
  PHONE_NO PHONENUMBER DEFAULT '555-1234',
  PRIMARY KEY (DEPT_NO),
  UNIQUE (DEPARTMENT)
);
CREATE TABLE EMPLOYEE
(
  EMP_NO EMPNO NOT NULL,
  FIRST_NAME FIRSTNAME NOT NULL,
  LAST_NAME LASTNAME NOT NULL,
  PHONE_EXT Varchar(4),
  HIRE_DATE Timestamp DEFAULT 'NOW' NOT NULL,
  DEPT_NO DEPTNO NOT NULL,
  JOB_CODE JOBCODE NOT NULL,
  JOB_GRADE JOBGRADE NOT NULL,
  JOB_COUNTRY COUNTRYNAME NOT NULL,
  SALARY SALARY DEFAULT 0 NOT NULL,
  PRIMARY KEY (EMP_NO)
);
CREATE TABLE EMPLOYEE_PROJECT
(
  EMP_NO EMPNO NOT NULL,
  PROJ_ID PROJNO NOT NULL,
  PRIMARY KEY (EMP_NO,PROJ_ID)
);
CREATE TABLE JOB
(
  JOB_CODE JOBCODE NOT NULL,
  JOB_GRADE JOBGRADE NOT NULL,
  JOB_COUNTRY COUNTRYNAME NOT NULL,
  JOB_TITLE Varchar(25) NOT NULL,
  MIN_SALARY SALARY DEFAULT 0 NOT NULL,
  MAX_SALARY SALARY DEFAULT 0 NOT NULL,
  JOB_REQUIREMENT Blob sub_type 1,
  LANGUAGE_REQ Varchar(15),
  PRIMARY KEY (JOB_CODE,JOB_GRADE,JOB_COUNTRY)
);
CREATE TABLE PROJECT
(
  PROJ_ID PROJNO NOT NULL,
  PROJ_NAME Varchar(20) NOT NULL,
  PROJ_DESC Blob sub_type 1,
  TEAM_LEADER EMPNO,
  PRODUCT PRODTYPE DEFAULT 'software',
  PRIMARY KEY (PROJ_ID),
  UNIQUE (PROJ_NAME)
);
CREATE TABLE PROJ_DEPT_BUDGET
(
  FISCAL_YEAR Integer NOT NULL,
  PROJ_ID PROJNO NOT NULL,
  DEPT_NO DEPTNO NOT NULL,
  QUART_HEAD_CNT Integer,
  PROJECTED_BUDGET BUDGET DEFAULT 50000,
  PRIMARY KEY (FISCAL_YEAR,PROJ_ID,DEPT_NO)
);
CREATE TABLE SALARY_HISTORY
(
  EMP_NO EMPNO NOT NULL,
  CHANGE_DATE Timestamp DEFAULT 'NOW' NOT NULL,
  UPDATER_ID Varchar(20) NOT NULL,
  OLD_SALARY SALARY DEFAULT 0 NOT NULL,
  PERCENT_CHANGE Double precision DEFAULT 0 NOT NULL,
  PRIMARY KEY (EMP_NO,CHANGE_DATE,UPDATER_ID)
);
CREATE TABLE SALES
(
  PO_NUMBER PONUMBER NOT NULL,
  CUST_NO CUSTNO NOT NULL,
  SALES_REP EMPNO,
  ORDER_STATUS Varchar(7) DEFAULT 'new' NOT NULL,
  ORDER_DATE Timestamp DEFAULT 'NOW' NOT NULL,
  SHIP_DATE Timestamp,
  DATE_NEEDED Timestamp,
  PAID Char(1) DEFAULT 'n',
  QTY_ORDERED Integer DEFAULT 1 NOT NULL,
  TOTAL_VALUE Decimal(9,2) NOT NULL,
  DISCOUNT Float DEFAULT 0 NOT NULL,
  ITEM_TYPE PRODTYPE DEFAULT 'software',
  PRIMARY KEY (PO_NUMBER)
);

CREATE VIEW PHONE_LIST (EMP_NO, FIRST_NAME, LAST_NAME, PHONE_EXT, LOCATION, PHONE_NO)
AS  SELECT
    emp_no, first_name, last_name, phone_ext, location, phone_no
    FROM employee, department
    WHERE employee.dept_no = department.dept_no;

CREATE EXCEPTION CUSTOMER_CHECK
'Overdue balance -- can not ship.';
CREATE EXCEPTION CUSTOMER_ON_HOLD
'This customer is on hold.';
CREATE EXCEPTION ORDER_ALREADY_SHIPPED
'Order status is "shipped."';
CREATE EXCEPTION REASSIGN_SALES
'Reassign the sales records before deleting this employee.';
CREATE EXCEPTION UNKNOWN_EMP_ID
'Invalid employee number or project id.';

SET TERM ^ ;
CREATE TRIGGER POST_NEW_ORDER FOR SALES ACTIVE
AFTER INSERT POSITION 0
AS
BEGIN
    POST_EVENT 'new_order';
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER SAVE_SALARY_CHANGE FOR EMPLOYEE ACTIVE
AFTER UPDATE POSITION 0
AS
BEGIN
    IF (old.salary <> new.salary) THEN
        INSERT INTO salary_history
            (emp_no, change_date, updater_id, old_salary, percent_change)
        VALUES (
            old.emp_no,
            'NOW',
            user,
            old.salary,
            (new.salary - old.salary) * 100 / old.salary);
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER SET_CUST_NO FOR CUSTOMER ACTIVE
BEFORE INSERT POSITION 0
AS
BEGIN
    /* FIXED by helebor 19.01.2004 */
    if (new.cust_no is null) then
    new.cust_no = gen_id(cust_no_gen, 1);
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER SET_EMP_NO FOR EMPLOYEE ACTIVE
BEFORE INSERT POSITION 0
AS
BEGIN
    /* FIXED by helebor 19.01.2004 */
    if (new.emp_no is null) then
    new.emp_no = gen_id(emp_no_gen, 1);
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE ADD_EMP_PROJ (
    EMP_NO Smallint,
    PROJ_ID Char(5) )
AS
BEGIN
 BEGIN
 INSERT INTO employee_project (emp_no, proj_id) VALUES (:emp_no, :proj_id);
 WHEN SQLCODE -530 DO
  EXCEPTION unknown_emp_id;
 END
 SUSPEND;
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE ALL_LANGS
RETURNS (
    CODE Varchar(5),
    GRADE Varchar(5),
    COUNTRY Varchar(15),
    LANG Varchar(15) )
AS
BEGIN
 FOR SELECT job_code, job_grade, job_country FROM job 
  INTO :code, :grade, :country

 DO
 BEGIN
     FOR SELECT languages FROM show_langs 
       (:code, :grade, :country) INTO :lang DO
         SUSPEND;
     /* Put nice separators between rows */
     code = '=====';
     grade = '=====';
     country = '===============';
     lang = '==============';
     SUSPEND;
 END
    END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE DELETE_EMPLOYEE (
    EMP_NUM Integer )
AS
DECLARE VARIABLE any_sales INTEGER;
BEGIN
 any_sales = 0;

 /*
  * If there are any sales records referencing this employee,
  * can't delete the employee until the sales are re-assigned
  * to another employee or changed to NULL.
  */
 SELECT count(po_number)
 FROM sales
 WHERE sales_rep = :emp_num
 INTO :any_sales;

 IF (any_sales > 0) THEN
 BEGIN
  EXCEPTION reassign_sales;
  SUSPEND;
 END

 /*
  * If the employee is a manager, update the department.
  */
 UPDATE department
 SET mngr_no = NULL
 WHERE mngr_no = :emp_num;

 /*
  * If the employee is a project leader, update project.
  */
 UPDATE project
 SET team_leader = NULL
 WHERE team_leader = :emp_num;

 /*
  * Delete the employee from any projects.
  */
 DELETE FROM employee_project
 WHERE emp_no = :emp_num;

 /*
  * Delete old salary records.
  */
 DELETE FROM salary_history
 WHERE emp_no = :emp_num;

 /*
  * Delete the employee.
  */
 DELETE FROM employee
 WHERE emp_no = :emp_num;

 SUSPEND;
END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE DEPT_BUDGET (
    DNO Char(3) )
RETURNS (
    TOT Decimal(12,2) )
AS
DECLARE VARIABLE sumb DECIMAL(12, 2);
 DECLARE VARIABLE rdno CHAR(3);
 DECLARE VARIABLE cnt INTEGER;
BEGIN
 tot = 0;

 SELECT budget FROM department WHERE dept_no = :dno INTO :tot;

 SELECT count(budget) FROM department WHERE head_dept = :dno INTO :cnt;

 IF (cnt = 0) THEN
  SUSPEND;

 FOR SELECT dept_no
  FROM department
  WHERE head_dept = :dno
  INTO :rdno
 DO
  BEGIN
   EXECUTE PROCEDURE dept_budget :rdno RETURNING_VALUES :sumb;
   tot = tot + sumb;
  END

 SUSPEND;
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE GET_EMP_PROJ (
    EMP_NO Smallint )
RETURNS (
    PROJ_ID Char(5) )
AS
BEGIN
 FOR SELECT proj_id
  FROM employee_project
  WHERE emp_no = :emp_no
  INTO :proj_id
 DO
  SUSPEND;
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE MAIL_LABEL (
    CUST_NO Integer )
RETURNS (
    LINE1 Char(40),
    LINE2 Char(40),
    LINE3 Char(40),
    LINE4 Char(40),
    LINE5 Char(40),
    LINE6 Char(40) )
AS
DECLARE VARIABLE customer VARCHAR(25);
 DECLARE VARIABLE first_name  VARCHAR(15);
 DECLARE VARIABLE last_name  VARCHAR(20);
 DECLARE VARIABLE addr1  VARCHAR(30);
 DECLARE VARIABLE addr2  VARCHAR(30);
 DECLARE VARIABLE city  VARCHAR(25);
 DECLARE VARIABLE state  VARCHAR(15);
 DECLARE VARIABLE country VARCHAR(15);
 DECLARE VARIABLE postcode VARCHAR(12);
 DECLARE VARIABLE cnt  INTEGER;
BEGIN
 line1 = '';
 line2 = '';
 line3 = '';
 line4 = '';
 line5 = '';
 line6 = '';

 SELECT customer, contact_first, contact_last, address_line1,
  address_line2, city, state_province, country, postal_code
 FROM CUSTOMER
 WHERE cust_no = :cust_no
 INTO :customer, :first_name, :last_name, :addr1, :addr2,
  :city, :state, :country, :postcode;

 IF (customer IS NOT NULL) THEN
  line1 = customer;
 IF (first_name IS NOT NULL) THEN
  line2 = first_name || ' ' || last_name;
 ELSE
  line2 = last_name;
 IF (addr1 IS NOT NULL) THEN
  line3 = addr1;
 IF (addr2 IS NOT NULL) THEN
  line4 = addr2;

 IF (country = 'USA') THEN
 BEGIN
  IF (city IS NOT NULL) THEN
   line5 = city || ', ' || state || '  ' || postcode;
  ELSE
   line5 = state || '  ' || postcode;
 END
 ELSE
 BEGIN
  IF (city IS NOT NULL) THEN
   line5 = city || ', ' || state;
  ELSE
   line5 = state;
  line6 = country || '    ' || postcode;
 END

 SUSPEND;
END^
SET TERM ; ^

SET TERM ^ ;

ALTER PROCEDURE ORG_CHART

RETURNS (
    HEAD_DEPT Char(25),
    DEPARTMENT Char(25),
    MNGR_NAME Char(20),
    TITLE Char(5),
    EMP_CNT Integer )
AS
DECLARE VARIABLE mngr_no INTEGER;
 DECLARE VARIABLE dno CHAR(3);
BEGIN
 FOR SELECT h.department, d.department, d.mngr_no, d.dept_no
  FROM department d
  LEFT OUTER JOIN department h ON d.head_dept = h.dept_no
  ORDER BY d.dept_no
  INTO :head_dept, :department, :mngr_no, :dno
 DO
 BEGIN
  IF (:mngr_no IS NULL) THEN
  BEGIN
   mngr_name = '--TBH--';
   title = '';
  END

  ELSE
   SELECT full_name, job_code
   FROM employee
   WHERE emp_no = :mngr_no
   INTO :mngr_name, :title;

  SELECT COUNT(emp_no)
  FROM employee
  WHERE dept_no = :dno
  INTO :emp_cnt;

  SUSPEND;
 END
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE SHIP_ORDER (
    PO_NUM Char(8) )
AS
DECLARE VARIABLE ord_stat CHAR(7);
 DECLARE VARIABLE hold_stat CHAR(1);
 DECLARE VARIABLE cust_no INTEGER;
 DECLARE VARIABLE any_po CHAR(8);
BEGIN
 SELECT s.order_status, c.on_hold, c.cust_no
 FROM sales s, customer c
 WHERE po_number = :po_num
 AND s.cust_no = c.cust_no
 INTO :ord_stat, :hold_stat, :cust_no;

 /* This purchase order has been already shipped. */
 IF (ord_stat = 'shipped') THEN
 BEGIN
  EXCEPTION order_already_shipped;
  SUSPEND;
 END

 /* Customer is on hold. */
 ELSE IF (hold_stat = '*') THEN
 BEGIN
  EXCEPTION customer_on_hold;
  SUSPEND;
 END

 /*
  * If there is an unpaid balance on orders shipped over 2 months ago,
  * put the customer on hold.
  */
 FOR SELECT po_number
  FROM sales
  WHERE cust_no = :cust_no
  AND order_status = 'shipped'
  AND paid = 'n'
  AND ship_date < CAST('NOW' AS TIMESTAMP) - 60
  INTO :any_po
 DO
 BEGIN
  EXCEPTION customer_check;

  UPDATE customer
  SET on_hold = '*'
  WHERE cust_no = :cust_no;

  SUSPEND;
 END

 /*
  * Ship the order.
  */
 UPDATE sales
 SET order_status = 'shipped', ship_date = 'NOW'
 WHERE po_number = :po_num;

 SUSPEND;
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE SHOW_LANGS (
    CODE Varchar(5),
    GRADE Smallint,
    CTY Varchar(15) )
RETURNS (
    LANGUAGES Varchar(15) )
AS
DECLARE VARIABLE i INTEGER;
BEGIN
  i = 1;
  WHILE (i <= 5) DO
  BEGIN
    SELECT language_req[:i] FROM joB
    WHERE ((job_code = :code) AND (job_grade = :grade) AND (job_country = :cty)
           AND (language_req IS NOT NULL))
    INTO :languages;
    IF (languages = ' ') THEN  /* Prints 'NULL' instead of blanks */
       languages = 'NULL';         
    i = i +1;
    SUSPEND;
  END
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE SUB_TOT_BUDGET (
    HEAD_DEPT Char(3) )
RETURNS (
    TOT_BUDGET Decimal(12,2),
    AVG_BUDGET Decimal(12,2),
    MIN_BUDGET Decimal(12,2),
    MAX_BUDGET Decimal(12,2) )
AS
BEGIN
 SELECT SUM(budget), AVG(budget), MIN(budget), MAX(budget)
  FROM department
  WHERE head_dept = :head_dept
  INTO :tot_budget, :avg_budget, :min_budget, :max_budget;
 SUSPEND;
END^
SET TERM ; ^

ALTER TABLE CUSTOMER ADD
  FOREIGN KEY (COUNTRY) REFERENCES COUNTRY (COUNTRY);
ALTER TABLE CUSTOMER ADD 
  CHECK (on_hold IS NULL OR on_hold = '*');
CREATE INDEX CUSTNAMEX ON CUSTOMER (CUSTOMER);
CREATE INDEX CUSTREGION ON CUSTOMER (COUNTRY,CITY);
ALTER TABLE DEPARTMENT ADD
  FOREIGN KEY (HEAD_DEPT) REFERENCES DEPARTMENT (DEPT_NO);
ALTER TABLE DEPARTMENT ADD
  FOREIGN KEY (MNGR_NO) REFERENCES EMPLOYEE (EMP_NO);
CREATE DESCENDING INDEX BUDGETX ON DEPARTMENT (BUDGET);
ALTER TABLE EMPLOYEE ADD FULL_NAME COMPUTED BY (last_name || ', ' || first_name);
ALTER TABLE EMPLOYEE ADD
  FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT (DEPT_NO);
ALTER TABLE EMPLOYEE ADD
  FOREIGN KEY (JOB_CODE,JOB_GRADE,JOB_COUNTRY) REFERENCES JOB (JOB_CODE,JOB_GRADE,JOB_COUNTRY);
ALTER TABLE EMPLOYEE ADD 
  CHECK ( salary >= (SELECT min_salary FROM job WHERE
                        job.job_code = employee.job_code AND
                        job.job_grade = employee.job_grade AND
                        job.job_country = employee.job_country) AND
            salary <= (SELECT max_salary FROM job WHERE
                        job.job_code = employee.job_code AND
                        job.job_grade = employee.job_grade AND
                        job.job_country = employee.job_country));
CREATE INDEX NAMEX ON EMPLOYEE (LAST_NAME,FIRST_NAME);
ALTER TABLE EMPLOYEE_PROJECT ADD
  FOREIGN KEY (EMP_NO) REFERENCES EMPLOYEE (EMP_NO);
ALTER TABLE EMPLOYEE_PROJECT ADD
  FOREIGN KEY (PROJ_ID) REFERENCES PROJECT (PROJ_ID);
ALTER TABLE JOB ADD
  FOREIGN KEY (JOB_COUNTRY) REFERENCES COUNTRY (COUNTRY);
ALTER TABLE JOB ADD 
  CHECK (min_salary < max_salary);
CREATE DESCENDING INDEX MAXSALX ON JOB (JOB_COUNTRY,MAX_SALARY);
CREATE INDEX MINSALX ON JOB (JOB_COUNTRY,MIN_SALARY);
ALTER TABLE PROJECT ADD
  FOREIGN KEY (TEAM_LEADER) REFERENCES EMPLOYEE (EMP_NO);
CREATE UNIQUE INDEX PRODTYPEX ON PROJECT (PRODUCT,PROJ_NAME);
ALTER TABLE PROJ_DEPT_BUDGET ADD
  FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT (DEPT_NO);
ALTER TABLE PROJ_DEPT_BUDGET ADD
  FOREIGN KEY (PROJ_ID) REFERENCES PROJECT (PROJ_ID);
ALTER TABLE PROJ_DEPT_BUDGET ADD 
  CHECK (FISCAL_YEAR >= 1993);
ALTER TABLE SALARY_HISTORY ADD NEW_SALARY COMPUTED BY (old_salary + old_salary * percent_change / 100);
ALTER TABLE SALARY_HISTORY ADD
  FOREIGN KEY (EMP_NO) REFERENCES EMPLOYEE (EMP_NO);
ALTER TABLE SALARY_HISTORY ADD 
  CHECK (percent_change between -50 and 50);
CREATE DESCENDING INDEX CHANGEX ON SALARY_HISTORY (CHANGE_DATE);
CREATE INDEX UPDATERX ON SALARY_HISTORY (UPDATER_ID);
ALTER TABLE SALES ADD AGED COMPUTED BY (ship_date - order_date);
ALTER TABLE SALES ADD
  FOREIGN KEY (CUST_NO) REFERENCES CUSTOMER (CUST_NO);
ALTER TABLE SALES ADD
  FOREIGN KEY (SALES_REP) REFERENCES EMPLOYEE (EMP_NO);
ALTER TABLE SALES ADD 
  CHECK (order_status in
                            ('new', 'open', 'shipped', 'waiting'));
ALTER TABLE SALES ADD 
  CHECK (ship_date >= order_date OR ship_date IS NULL);
ALTER TABLE SALES ADD 
  CHECK (date_needed > order_date OR date_needed IS NULL);
ALTER TABLE SALES ADD 
  CHECK (paid in ('y', 'n'));
ALTER TABLE SALES ADD 
  CHECK (qty_ordered >= 1);
ALTER TABLE SALES ADD 
  CHECK (total_value >= 0);
ALTER TABLE SALES ADD 
  CHECK (discount >= 0 AND discount <= 1);
ALTER TABLE SALES ADD 
  CHECK (NOT (order_status = 'shipped' AND ship_date IS NULL));
ALTER TABLE SALES ADD 
  CHECK (NOT (order_status = 'shipped' AND
            EXISTS (SELECT on_hold FROM customer
                    WHERE customer.cust_no = sales.cust_no
                    AND customer.on_hold = '*')));
CREATE INDEX NEEDX ON SALES (DATE_NEEDED);
CREATE DESCENDING INDEX QTYX ON SALES (ITEM_TYPE,QTY_ORDERED);
CREATE INDEX SALESTATX ON SALES (ORDER_STATUS,PAID);