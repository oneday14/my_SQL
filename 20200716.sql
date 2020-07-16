--[ �Ʒ� ���� �� �ǽ� - system �������� ���� ]
create user kic identified by oracle;
grant create session to kic;

select *
  from dba_users
 where username='KIC';
 
--1. ������ ���ʴ�� ����
--1) menu_t1 ���̺� ����(no, name, price)
create table menu_t1(
no    number(4),
name  varchar2(20),
price number);

--2) jumun_t1 ���̺� ����(no, product_no, qty, jdate)
create table jumun_t1(
no          number(4),
product_no  number(4),
qty         number,
jdate       date);

--3) jumun_t1 ���̺��� product_no�� menu_t1 ���̺���
--   no�� �����ϵ��� ����
alter table menu_t1 add constraint menu_no_pk
      primary key(no);
      
alter table jumun_t1 add constraint jumun_pno_fk
      foreign key(product_no) references menu_t1(no);
      
--4) kic �������� �� ���̺��� ��ȸ�� ���� �ο�
grant select on scott.menu_t1 to kic;
grant insert on scott.menu_t1 to kic;
grant select on scott.jumun_t1 to kic;
grant select, insert, delete, update 
      on scott.jumun_t1 to kic;

--5) kic ������ ���̺������ ��ȸ�ϵ��� �ó�� ����
create public synonym jumun_t1 for scott.jumun_t1;
create public synonym menu_t1 for scott.menu_t1;

--6) 1000������ �����ؼ� 9999�� ���� ���� �������� ����,
--   menu_t1�� ������ �Է�
create sequence seq_menu
start with 1000
increment by 1
maxvalue 9999;

insert into menu_t1 values(seq_menu.nextval, 'tv',150);
select * from menu_t1;
commit;

--7) 1�� ���� �����ؼ� 100�� ���� ���� ������ ����,
--   jumun_t1�� ������ �Է�
create sequence seq_jumun
start with 100
increment by 1
;

insert into jumun_t1 values(seq_jumun.nextval, 
                            1001,
                            2,
                            '2020/06/06');

alter session set nls_date_format='MM/DD/YYYY';
insert into jumun_t1 values(seq_jumun.nextval, 
                            1001,
                            3,
                            to_date('2020/06/07',
                                    'YYYY/MM/DD'));
commit;                                    
select * from jumun_t1;                                    
--8) �� ���̺� �����Ͽ� �ֹ�����, ��ǰ��, �ֹ�����, 
--   ��ǰ������ ���� ����ϴ� �� ����

create view jumun_menu
as
select j.JDATE, m.NAME, j.QTY, m.PRICE
  from menu_t1 m, jumun_t1 j
 where m.NO = j.PRODUCT_NO;
 
--2. ������ �����Ͽ���.
drop table emp_test1;
create table emp_test1 as select * from emp;
insert into emp_test1 
select * from emp where deptno = 10;
commit;

--emp_test1 ���̺��� empno�� pk�� ����,
--�ߺ��� ���� ã�� ���� �� ����
alter table emp_test1 add constraint emp_test_empno_pk
      primary key(empno);
      
select empno, count(empno), max(ROWID)
  from emp_test1
 group by empno
having count(empno) >= 2;      

select rowid, e.* 
  from emp_test1 e
 order by deptno, empno;

delete from emp_test1
 where ROWID in (select max(ROWID)
                   from emp_test1
                  group by empno
                 having count(empno) >= 2);  
commit;

select * from emp_test1;
