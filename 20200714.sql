-- 1) student2 ���̺��� ����� 
-- ��1�� ������ȣ�� 301�� �л����� ����⵵�� ������ 
-- �л����� �����Ͽ���.
create table student2 as select * from STUDENT;

select to_char(BIRTHDAY, 'YYYY'),
       to_char(BIRTHDAY, 'RRRR')
  from student2
 where deptno1 = 301;
 
select to_date('90/01/01','YY/MM/DD'),
       to_date('90/01/01','RR/MM/DD')
  from dual;
  
delete from STUDENT2
 where to_char(BIRTHDAY, 
               'YYYY') in (select to_char(BIRTHDAY,
                                         'YYYY')
                             from student2
                            where deptno1 = 301);
commit;    

-- 2) student3 ���̺��� ����� �񸸿��θ� ��Ÿ���� �÷���
-- ���� �߰��ϰ�, �� �л����� �������� update �Ͽ���.
-- �񸸿��δ� ü���� ǥ��ü�ߺ��� ũ�� ��ü��, 
-- ������ ��ü��, ������ ǥ������ �з��Ͽ���.
-- *ǥ��ü�� = (Ű-100)*0.9
create table student3 as select * from STUDENT;
alter table student3 add biman varchar2(10);

select WEIGHT, (HEIGHT-100)*0.9 AS ǥ��ü��,
       case when WEIGHT > (HEIGHT-100)*0.9 then '��ü��'
            when WEIGHT < (HEIGHT-100)*0.9 then '��ü��'
                                           else 'ǥ��'
        end AS "�񸸿���"                                   
  from STUDENT3;

update STUDENT3 s1
   set biman = (select case when WEIGHT > (HEIGHT-100)*0.9 
                            then '��ü��'
                            when WEIGHT < (HEIGHT-100)*0.9 
                            then '��ü��'
                            else 'ǥ��'
                        end AS "�񸸿���"                                   
                  from STUDENT3 s2
                 where s1.STUDNO = s2.STUDNO);
rollback;

update STUDENT3 s1
   set biman = case when WEIGHT > (HEIGHT-100)*0.9 
                    then '��ü��'
                    when WEIGHT < (HEIGHT-100)*0.9 
                    then '��ü��'
                    else 'ǥ��'
                end;

commit;

-- 3) student3 ���̺��� �ֹι�ȣ�� �Ʒ��� ���� ����.
-- (���� �߻� �� ������ ��ġ�� ���� �� ����)
-- 751023-1111111
select JUMIN, 
       substr(JUMIN,1,6)||'-'||substr(JUMIN,7),
       substr(JUMIN,1,6)||'-'||substr(JUMIN,7,7),
       length(substr(JUMIN,7))
  from STUDENT3;

alter table STUDENT3 modify jumin char(14);

update STUDENT3
   set jumin = substr(JUMIN,1,6)||'-'
               ||substr(JUMIN,7,7) ;

desc STUDENT3;  --JUMIN  CHAR(13)

commit;

-- 4) emp_back2 ���̺��� ����� �� ������ ������ 
-- ������ �� ������ ������������ ������ ������� ����.
-- ��, ���������ڰ� ���� ���� ������ ������ 
-- 10% ��µ� ���� ���������� �������� ���
create table emp_back2 as select * from emp;

select e1.ename, e1.sal, e2.sal,
       (e1.sal + e2.sal)/2,
       (e1.sal + nvl(e2.sal,e1.sal*1.1))/2
  from emp_back2 e1, emp_back2 e2
 where e1.mgr = e2.EMPNO(+);

select e1.ename, e1.sal, 
       nvl((select (e1.sal + e2.sal)/2
              from emp_back2 e2
              where e1.mgr = e2.EMPNO),
           (e1.sal + e1.sal*1.1)/2)
  from emp_back2 e1;

select e1.ename, e1.sal, 
       nvl((select e2.SAL
         from emp e2 
        where e1.mgr = e2.empno),5000)
  from emp e1;


update emp_back2 e1
   set sal = (select (e1.sal + 
                     nvl(e2.sal,e1.sal*1.1))/2
                from emp_back2 e2
               where e1.mgr = e2.EMPNO(+));

update emp_back2 e1
   set sal = nvl((select (e1.sal + e2.sal)/2
                    from emp_back2 e2
                   where e1.mgr = e2.EMPNO),
                 (e1.sal + e1.sal*1.1)/2);

commit;
select * from emp_back2;

---------- ��������� �����Դϴ�. ----------

-- ��������
-- foreign key(�ܷ�Ű) : 

�ڽ����̺�(emp)        �θ����̺�(dept) 
         deptno    ->  deptno 
     (foreign key)   (reference key)
insert, update ����    delete ����       
                       PK �Ǵ� UK ���� �ʿ�
;

1. ����
1) ���̺� ���� ��
create table ���̺��(
�÷�1  ������Ÿ�� primary key,
�÷�2  ������Ÿ�� references �θ����̺�(�÷�3));

2) �̹� ������ ���̺� �߰�
alter table ���̺�� add foreign key(�÷�1) 
                     references �θ����̺�(�÷�2)); 

--����) jumun���̺�� cafe_prod ���̺��� ����� 
--jumun ���̺��� product_no �÷��� cafe_prod ���̺���
--��ǰ��ȣ(no)�� �����ϵ��� ���̺��� �����Ͽ���
--cafe_prod : no, name, price
--jumun : jumun_no, qty, product_no
drop table cafe_prod;

create table cafe_prod(
no      number primary key,  -- reference key ��������
name    varchar2(10),
price   number);

create table jumun(
jumun_no    number,
qty         number,
product_no  number references cafe_prod(no));

--��������) emp�κ��� emp_t1, dept�κ��� dept_t1 ����,
--emp_t1(deptno)  ->  dept_t1(deptno) �� ���谡 �ǵ���
--������ ���������� �����ϼ���
create table emp_t1 as select * from emp;
create table dept_t1 as select * from dept;

alter table dept_t1 add constraint deptt1_deptno_pk
      primary key(deptno);
      
alter table emp_t1 add constraint empt1_deptno_fk
      foreign key(deptno) references dept_t1(deptno);
      
-- foreign key <-> reference key �� �÷� ����
-- reference key�� �����Ϸ���(�÷�����)
-- 1) foreign key �÷��� ���� ���� �� ����
-- 2) cascade constraints �ɼ��� ����� ����
alter table dept_t1 drop column deptno; -- �Ұ�
alter table dept_t1 
      drop column deptno cascade constraints; -- ����


-- �������� ��ȸ ��
-- 1) user_constraints(�������� �÷� ���� ����)
select constraint_name,  -- �������� �̸�
       constraint_type,  -- c:(check/nn), p:pk, u:uk, r:fk
       search_condition, -- check or nn ����
       table_name,       -- ���̺��
       r_constraint_name -- ���� �������� �̸�
  from user_constraints
 where constraint_name = 'SYS_C0011049';

insert into dept2 values(1001,'abc',1000,'ab');
���Ἲ �������� SYS_C0011049�� ����˴ϴ�
=> PK�� �ִٴ� ���� Ȯ��, � �÷������� �� �� ����
;

-- 2) user_cons_columns(�������� �÷� ���� ����)
select *
  from user_cons_columns
 where CONSTRAINT_NAME = 'SYS_C0011049' ;

=> PK�� dcode �÷��� �ɷ��ִ��� �� �� ����
;

insert into dept2 values(2001,'abc',1000,'ab');
rollback;

--��������) user_constraints, user_cons_columns �並
--�����Ͽ� ���̺��, �÷��̸�, ���������̸�, 
--�������� ������ ����ϵ� �������� ������ ������ ����
--ǥ��(PK, UK, CHECK, NN, FK)
select c1.table_name,
       c2.column_name,
       c1.constraint_name,
       c1.constraint_type,
       decode(c1.constraint_type,
              'P','PK',
              'U','UK',
              'R','FK',
              'C',decode(nullable,'N','NN','CHECK'))
       AS ������������,
       .... AS reference_table,
       .... AS reference_key
  from user_constraints c1, 
       user_cons_columns c2,
       user_tab_columns c3
 where c1.constraint_name = c2.constraint_name
   and c2.column_name = c3.column_name
   and c2.table_name = c3.table_name;

user_constraints  user_cons_columns  user_tab_columns
table_name      -    table_name        table_name  
constraint_name -  constraint_name     column_name
                     column_name
