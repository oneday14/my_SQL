user_constraints  user_cons_columns  user_tab_columns
table_name      -    table_name        table_name  
constraint_name -  constraint_name     column_name
                     column_name
;

-- ���̺��, �÷���, �������� �̸�, ����,
-- �θ����̺��, reference_key ��ȸ
select c1.TABLE_NAME AS "���̺��(�ڽ����̺�)",
       c3.column_name AS �÷���,
       c1.constraint_name AS ���������̸�,
       c1.constraint_type AS ������������,
       c2.table_name AS �θ����̺��,
       c4.column_name AS "reference_key"
  from user_constraints c1, user_constraints c2,
       user_cons_columns c3, user_cons_columns c4
 where c1.r_constraint_name = c2.constraint_name(+)
   and c1.constraint_name = c3.constraint_name
   and c2.constraint_name = c4.constraint_name(+);

--c3 - c1 - c2(+) - c4(+);

select * from user_constraints;

---------- ��������� �����Դϴ�. ----------

-- foreign key ���� �ɼ�
--�ڽ����̺�    - �θ� ���̺�
--foreign key     reference key
--
--1. on delete cascade : �θ� ������ ���� �� �ڽ� ������
--                       �Բ� ����
--2. on delete set null : �θ� ������ ���� �� �ڽ� ������
--                        null�� ������Ʈ;

create table emp_t2 as select * from emp;
create table dept_t2 as select * from dept;

alter table dept_t2 add constraint deptt2_deptno_pk
                    primary key(deptno);
               
--case1) foreign key �ɼ� ���� ���� �� delete
alter table emp_t2 add constraint empt2_deptno_fk
      foreign key(deptno) references dept_t2(deptno);

delete from dept_t2 where deptno = 10; -- �Ұ�

--case2) on delete cascade �ɼ����� ���� �� delete
alter table emp_t2 drop constraint empt2_deptno_fk;

alter table emp_t2 add constraint empt2_deptno_fk
      foreign key(deptno) references dept_t2(deptno)
      on delete cascade;

delete from dept_t2 where deptno = 10;  -- ����
select * from emp_t2; -- 10�� �μ� ������ �Բ� ����
rollback;

--case3) on delete set null �ɼ����� ���� �� delete
alter table emp_t2 drop constraint empt2_deptno_fk;

alter table emp_t2 add constraint empt2_deptno_fk
      foreign key(deptno) references dept_t2(deptno)
      on delete set null;

delete from dept_t2 where deptno = 10;  -- ����
select * from emp_t2; -- 10�� �μ� ������ null�� ����


--[ ���� : ���̺� �� �÷� comment ��ȸ �� �ο��ϱ� ]
--1) ��ȸ
select * 
  from all_tab_comments;  -- ���̺� ����
  
select * 
  from all_col_comments;  -- �÷� ����

--2) comment �ο�
comment on table ���̺�� is ����;
comment on column ���̺��.�÷�1 is ����;

comment on table emp_t2 is 'emp test table';
comment on column emp_t2.empno is '�����ȣ';


-- [ DDL �������� : pdf ���� ]
drop table board purge;
drop table member2 purge;

create table member2(
userid varchar2(10) ,
username varchar2(10) ,
passwd varchar2(10) ,
idnum varchar2(13) ,
phone number(13) ,
address varchar2(20) ,
regdate date ,
interest varchar2(15) 
);

alter table member2 add primary key(userid);
alter table member2 add unique(idnum);
alter table member2 modify username not null;
alter table member2 modify passwd not null;

comment on column member2.userid is '����ھ��̵�';
comment on column member2.username  is 'ȸ���̸�';
comment on column member2.passwd  is '��й�ȣ';
comment on column member2.phone   is '��ȭ��ȣ';
comment on column member2.address  is '�ּ�';
comment on column member2.regdate  is '������';
comment on column member2.interest   is '���ɺо�';

create table board(
NO NUMBER(4),
SUBJECT VARCHAR2(50) ,
CONTENT VARCHAR2(100) ,
RDATE DATE ,
USERID VARCHAR2(10));

alter table board add primary key(no);
alter table board add foreign key (userid) references member2(userid);
alter table board modify subject not null;

comment on column board.NO  is '�Խù� ��ȣ';
comment on column board.SUBJECT   is '����';
comment on column board.CONTENT   is '����';
comment on column board.RDATE    is '�ۼ�����';
comment on column board.USERID   is '�۾���';


-- ��Ÿ ������Ʈ
--1. ��
-- ���� ��������� ���� �ʰ� Ư�� ������ ����� ���
-- �並 ���̺�ó�� ��ȸ ����
-- �ܼ���(���̺� �Ѱ�)/���պ�(���� ���̺�)

--1) ����
create [or replace] view ���̸�
as
subquery;

-- system �������� �Ʒ� ����
grant dba to scott;

-- scott �������� �� ����(������ �ʿ�)
create view emp_view1
as
select empno, ename 
  from emp;

create or replace view emp_view1
as
select empno, ename, sal 
  from emp;

select *
  from emp_view1;

create view student_hakjum  
as
select s.studno, s.name, e.total, h.grade
  from student s, exam_01 e, hakjum h
 where s.studno = e.studno
   and e.total between h.min_point and h.max_point;

--2) �� ��ȸ
select * from user_views;

--3) �並 ���� ���� ���̺� ����
update emp_view1
   set ename = 'smith'
 where ename = 'SMITH';

select * from emp;

--4) ����
drop view emp_view1;

--2. ������ : �������� ��ȣ�� �ڵ� �ο�

--1) ����
create sequence ������ �̸�
increment by n   -- ������
start with n     -- ���۰�
maxvalue n       -- �ִ밪, ����� ����
minvalue n       -- �ּҰ�, ����� ����
cycle            -- ��ȯ����(��ȣ ���� ����)
cache n          -- ĳ�̻�����
;

--[ sequence�� ����� �ڵ� ��ȣ �ο� test ]
--1. sequence ����
--drop sequence test_seq1;
create sequence test_seq1
increment by 1
start with 100
maxvalue 110
;

create sequence test_seq2
increment by 1
start with 100
maxvalue 110
minvalue 100
cycle
cache 2
;

create sequence test_seq3
increment by 1
start with 100
maxvalue 110
minvalue 100
cycle
cache 2
;


--2. test table ����
create table jumun1(
no   number,
name varchar2(10),
qty  number);

create table jumun2(
no   number,
name varchar2(10),
qty  number);

--3. sequence�� ����� ������ �Է�
--1) nocycle�� ������ insert ������ �ݺ�
-- maxvalue�� �ʰ��ϴ� ���� ���� �߻�
-- �ش� sequence ��� �Ұ�
insert into jumun1 values(test_seq1.nextval, 'latte',2);
select * from jumun1;

--2) cycle�� ������ insert ������ �ݺ�
-- maxvalue�� �ʰ��ϴ� ���� minvalue�� ���
-- �ش� sequence ��� ��� ����
insert into jumun2 values(test_seq2.nextval, 'latte',2);
select * from jumun2;
rollback;

insert into jumun2 values(test_seq3.nextval, 'latte',2);
select * from jumun2;

--4. sequence ���� ��ȣ Ȯ��
select test_seq2.currval
  from dual;

select * 
  from user_sequences;


--3. �ó�� : �������ϰ� ��� ������ ���̺� ��Ī
--1) ����
create [or replace] [public] synonym ��Ī��
        for ���̺��;

create synonym emp_test for emp;
select * from emp_test;

--scott �������� ����)
select * from employees;

--system �������� ����) 
--scott���� hr�� employees ���̺� ��ȸ ���� �ο�
grant select on hr.EMPLOYEES to scott;

--scott �������� ����)
select * from hr.employees;

--system �������� ����) 
create synonym employees1 for hr.employees;
create public synonym employees for hr.employees;

--scott �������� ����)
select * from employees1;
select * from employees;

--2) ��ȸ
select *
  from all_synonyms
 where 1=1
   and table_owner in ('SCOTT','HR')
--   and table_name = 'EMPLOYEES'
 ;

--3) ����(system �������� ����)
drop synonym employees1;
drop public synonym employees;

--[ ���� ���� ]
--hr�������� scott �� ���̺� ��ȸ �����ϵ��� �ó�Ի��� 
--scott�������� hr �� ���̺� ��ȸ �����ϵ��� �ó�Ի���
--
--system �������� ����)
select 'create or replace public synonym '||
       table_name||' for '||owner||'.'||table_name||';'
  from dba_tables
 where owner in ('SCOTT','HR');

select * from hr.REGIONS;
select * from REGIONS;

create or replace public synonym DEPT for SCOTT.DEPT;
create or replace public synonym EMP for SCOTT.EMP;
create or replace public synonym BONUS for SCOTT.BONUS;
create or replace public synonym SALGRADE for SCOTT.SALGRADE;
create or replace public synonym REGIONS for HR.REGIONS;
create or replace public synonym LOCATIONS for HR.LOCATIONS;
create or replace public synonym DEPARTMENTS for HR.DEPARTMENTS;
create or replace public synonym PROFESSOR for SCOTT.PROFESSOR;
create or replace public synonym DEPARTMENT for SCOTT.DEPARTMENT;
create or replace public synonym STUDENT for SCOTT.STUDENT;
create or replace public synonym EMP2 for SCOTT.EMP2;
create or replace public synonym DEPT2 for SCOTT.DEPT2;
create or replace public synonym CAL for SCOTT.CAL;
create or replace public synonym GIFT for SCOTT.GIFT;
create or replace public synonym GOGAK for SCOTT.GOGAK;
create or replace public synonym HAKJUM for SCOTT.HAKJUM;
create or replace public synonym EXAM_01 for SCOTT.EXAM_01;
create or replace public synonym P_GRADE for SCOTT.P_GRADE;
create or replace public synonym REG_TEST for SCOTT.REG_TEST;
create or replace public synonym P_01 for SCOTT.P_01;
create or replace public synonym P_02 for SCOTT.P_02;
create or replace public synonym PT_01 for SCOTT.PT_01;
create or replace public synonym PT_02 for SCOTT.PT_02;
create or replace public synonym P_TOTAL for SCOTT.P_TOTAL;
create or replace public synonym DML_ERR_TEST for SCOTT.DML_ERR_TEST;
create or replace public synonym TEST_NOVALIDATE for SCOTT.TEST_NOVALIDATE;
create or replace public synonym TEST_VALIDATE for SCOTT.TEST_VALIDATE;
create or replace public synonym TEST_ENABLE for SCOTT.TEST_ENABLE;
create or replace public synonym PRODUCT for SCOTT.PRODUCT;
create or replace public synonym PANMAE for SCOTT.PANMAE;
create or replace public synonym MEMBER for SCOTT.MEMBER;
create or replace public synonym REG_TEST2 for SCOTT.REG_TEST2;
create or replace public synonym TEST1 for SCOTT.TEST1;
create or replace public synonym PLAN_TABLE for SCOTT.PLAN_TABLE;
create or replace public synonym TEST2 for SCOTT.TEST2;
create or replace public synonym TEST2 for HR.TEST2;
create or replace public synonym EMP_BAK for SCOTT.EMP_BAK;
create or replace public synonym EMP_BAKUP2 for SCOTT.EMP_BAKUP2;
create or replace public synonym EMP_BAK5 for SCOTT.EMP_BAK5;
create or replace public synonym STUDENT_BAK for SCOTT.STUDENT_BAK;
create or replace public synonym BONUS_BACKUP for SCOTT.BONUS_BACKUP;
create or replace public synonym CAL_BACKUP for SCOTT.CAL_BACKUP;
create or replace public synonym DEPARTMENT_BACKUP for SCOTT.DEPARTMENT_BACKUP;
create or replace public synonym DEPT_BACKUP for SCOTT.DEPT_BACKUP;
create or replace public synonym DEPT2_BACKUP for SCOTT.DEPT2_BACKUP;
create or replace public synonym DML_ERR_TEST_BACKUP for SCOTT.DML_ERR_TEST_BACKUP;
create or replace public synonym EMP_BACKUP for SCOTT.EMP_BACKUP;
create or replace public synonym EMP2_BACKUP for SCOTT.EMP2_BACKUP;
create or replace public synonym EXAM_01_BACKUP for SCOTT.EXAM_01_BACKUP;
create or replace public synonym GIFT_BACKUP for SCOTT.GIFT_BACKUP;
create or replace public synonym GOGAK_BACKUP for SCOTT.GOGAK_BACKUP;
create or replace public synonym HAKJUM_BACKUP for SCOTT.HAKJUM_BACKUP;
create or replace public synonym MEMBER_BACKUP for SCOTT.MEMBER_BACKUP;
create or replace public synonym PANMAE_BACKUP for SCOTT.PANMAE_BACKUP;
create or replace public synonym PRODUCT_BACKUP for SCOTT.PRODUCT_BACKUP;
create or replace public synonym PROFESSOR_BACKUP for SCOTT.PROFESSOR_BACKUP;
create or replace public synonym PT_01_BACKUP for SCOTT.PT_01_BACKUP;
create or replace public synonym PT_02_BACKUP for SCOTT.PT_02_BACKUP;
create or replace public synonym P_01_BACKUP for SCOTT.P_01_BACKUP;
create or replace public synonym P_02_BACKUP for SCOTT.P_02_BACKUP;
create or replace public synonym P_GRADE_BACKUP for SCOTT.P_GRADE_BACKUP;
create or replace public synonym P_TOTAL_BACKUP for SCOTT.P_TOTAL_BACKUP;
create or replace public synonym REG_TEST_BACKUP for SCOTT.REG_TEST_BACKUP;
create or replace public synonym REG_TEST2_BACKUP for SCOTT.REG_TEST2_BACKUP;
create or replace public synonym SALGRADE_BACKUP for SCOTT.SALGRADE_BACKUP;
create or replace public synonym STUDENT_BACKUP for SCOTT.STUDENT_BACKUP;
create or replace public synonym TEST1_BACKUP for SCOTT.TEST1_BACKUP;
create or replace public synonym TEST2_BACKUP for SCOTT.TEST2_BACKUP;
create or replace public synonym TEST_ENABLE_BACKUP for SCOTT.TEST_ENABLE_BACKUP;
create or replace public synonym TEST_NOVALIDATE_BACKUP for SCOTT.TEST_NOVALIDATE_BACKUP;
create or replace public synonym TEST_VALIDATE_BACKUP for SCOTT.TEST_VALIDATE_BACKUP;
create or replace public synonym STUDENT2 for SCOTT.STUDENT2;
create or replace public synonym STUDENT3 for SCOTT.STUDENT3;
create or replace public synonym EMP_BACK2 for SCOTT.EMP_BACK2;
create or replace public synonym CAFE_PROD for SCOTT.CAFE_PROD;
create or replace public synonym JUMUN for SCOTT.JUMUN;
create or replace public synonym EMP_T1 for SCOTT.EMP_T1;
create or replace public synonym DEPT_T1 for SCOTT.DEPT_T1;
create or replace public synonym EMP_T2 for SCOTT.EMP_T2;
create or replace public synonym DEPT_T2 for SCOTT.DEPT_T2;
create or replace public synonym MEMBER2 for SCOTT.MEMBER2;
create or replace public synonym BOARD for SCOTT.BOARD;
create or replace public synonym COUNTRIES for HR.COUNTRIES;
create or replace public synonym EMPLOYEES for HR.EMPLOYEES;
create or replace public synonym EMP_BAK4 for SCOTT.EMP_BAK4;
create or replace public synonym EMP_BAK3 for SCOTT.EMP_BAK3;
create or replace public synonym JOB_HISTORY for HR.JOB_HISTORY;
create or replace public synonym JOBS for HR.JOBS;

--4. index
-- index : �������� ��ġ���� ����س��� ������Ʈ

select * 
  from emp
 where empno = 7369;

select rowid, empno
  from emp;

select hiredate, rowid
  from emp
 order by 1;

--1) ����
create index �ε����� on ���̺��(�÷���);

create index emp_hd_idx on emp(hiredate);
drop index emp_hd_idx;

-- FBI(Function Based Index)
--����) 1980�⿡ �Ի��� ����� ����ϴ� ���� �ۼ� ��
--�ε��� ��ĵ�� �����ϰ� �Ͽ���
-- index supressing
select *
  from EMP
 where to_char(hiredate,'YYYY') = 1980;

create index emp_hd_fbi 
       on emp(to_char(hiredate,'YYYY'));

select *
  from EMP
 where to_char(hiredate,'YYYY') = '1980';

       
--2) �ε����� ����
select *
  from emp
 where hiredate = '1981/06/09';  --ctrl + e

--��������) 1981�� 6�� 9�Ͽ� �Ի��� ��� ��� ��
--�� ������ �����ȹ Ȯ��(ctrl + e)
--��, �Ի����� 06/09/1981 ���·� ����

select *
  from emp
 where hiredate = '06/09/1981'; 

--1) hiredate �÷� ����
select *
  from emp
 where to_char(hiredate, 'MM/DD/YYYY') = '06/09/1981'; 
 
--2) '06/09/1981' ����
select *
  from emp
 where hiredate = to_date('06/09/1981', 'MM/DD/YYYY'); 
 

[����1]
substr    10
decode    11

[����2]
select    1
where     10
groupby   20
;


-- ����(��ü������ ������ �������� ����)
--1. �ο�
--1) ������Ʈ ����
grant ���� to ������;
grant select on scott.emp to hr;
grant select on scott.dept to hr;

--2) �ý��� ����
grant create view to hr;
grant create table to hr;
grant alter table to hr;
grant create index to hr;

--3) role(������ ����)�� ���� ���� �ο�
create role test_role;
grant select on hr.EMPLOYEES to test_role;
grant test_role to scott;
grant dba to hr;

--2. ȸ��
revoke ���Ѹ� from ������;

