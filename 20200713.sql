--2. DML(Data Manipulation Langauge) : 
-- �������� ����(���� ���� X)
--  commit or rollback���� ���� ���� ����
--1) insert
insert into ���̺�� values(��1,��2,....);
insert into ���̺��(col1, col2, ...)
       values(��1,��2,....);

insert into EMP_BAK3 values('hong',10,1500,'a','b');
insert into EMP_BAK3(emp_name, deptno)
            values('kim',20);
insert into EMP_BAK3 values('park',20,1500,null,null);

insert into EMP_BAK
select * from emp where deptno=10;

commit;

--[ ���� : ��� ���̺� ���� ]
create table emp_backup as select * from emp;

select 'create table '||TNAME||
       '_backup as select * from '||TNAME||';'
  from tab
 where TNAME not like '%BAK%';

select *
  from tab
 where tname like '%BACKUP';

--2) delete : �� ���� ����
delete from ���̺��
 where ���� ; --�������� ����

select * from EMP_BAK;

delete from EMP_BAK3;
delete from EMP_BAK where EMPNO = 7369;
commit;

--����) student_bakup ���̺��� �������� �г��� ����
--�л� ������ ��� ����(������ ����)

select * 
  from student_bakup;

delete from student_backup
 where grade = (select grade
                  from student_backup
                 where NAME = '������');

rollback;

--��������) STUDENT_backup ���̺��� �� �г⺰
--Ű�� ���� ū �л� �����͸� ���� �� ����
delete from student_backup
 where (grade, height) in (select grade, max(height)
                             from student_backup
                            group by grade);
commit;

--��������) emp_backup ���̺��� �� �μ��� ��տ�������
--���� ������ �޴� ���� �����͸� ���� �� ����
select *
  from emp_backup e1
 where sal < (select avg(sal)
                from emp_backup e2
               where e1.deptno = e2.deptno
               group by deptno);

delete from emp_backup e1
 where sal < (select avg(sal)
                from emp_backup e2
               where e1.deptno = e2.deptno
               group by deptno);

commit;

-- dml ���� ���
--���� emp_backup ���̺��� ������ ������ Ȯ��,
--�ٽ� ������� ����
--sol1) ������ �����͸� ã�Ƽ� �Է�
insert into emp_backup
select *
  from emp_backup as of timestamp 
       to_date('2020/07/13 11:00','YYYY/MM/DD HH24:MI')
 minus
select *
  from emp_backup; 
  
commit; 

--sol2) ����� ��ü �ٽ� �Է�
delete from emp_backup;
insert into emp_backup 
select *
  from emp_backup as of timestamp 
       to_date('2020/07/13 11:00',
               'YYYY/MM/DD HH24:MI');

--3) update : ����, Ư�� �÷��� ��
update ���̺��
   set �÷��� = ������(������������)
 where ����(������������);
 
--����) STUDENT_backup ���̺��� �̹̰� �л��� Ű��
--160���� ����;
select * from student_backup;

update student_backup
   set height = 160
 where name = '�̹̰�';
 
select *
  from student_backup;

--����) student_backup�� ���̵� ���� 4�ڷ� ��� ����
update student_backup
   set ID = substr(ID,1,4);
   
--��������) student_backup���̺��� avg_height�÷��߰�
--�� �г��� Ű�� ��հ����� ����
alter table student_backup add avg_height number(8);
select * from student_backup;

update student_backup s1
   set AVG_HEIGHT = (select avg(HEIGHT)
                       from student_backup s2
                      where s1.GRADE = s2.GRADE
                      group by GRADE);
                      
commit;

--��������) student_backup ���̺� ���� �÷��� �߰�,
--�� �л��� ������ ��,���� update
alter table student_backup add gender varchar2(4);

update student_backup
   set gender = decode(substr(jumin,7,1),
                       '1','��','��');
rollback;   

update student_backup s1
   set gender = (select decode(substr(jumin,7,1),
                               '1','��','��')
                   from student_backup s1
                  where s1.STUDNO = s2.STUDNO);

select *
  from student_backup;
  
--��������) professor_backup ���̺��� �� �а��� 
--��տ������� ���� ������ �޴� ������ ������ 
--�� �а��� ��տ������� ����
select *
  from professor_backup;

update professor_backup p1
   set pay = (select avg(pay)
                from professor_backup p2
               where p1.DEPTNO = p2.DEPTNO)
 where pay < (select avg(pay)
                from professor_backup p3
               where p1.DEPTNO = p3.DEPTNO);
commit;

--4) merge 
-- �� ���̺��� ����
-- insert, update, delete�� ���� ����
merge into �������̺��
using �������̺��
   on ����
 when matched then
 update
 when not matched then
 insert/delete;
 
--����) PT_01 ���̺��� PT_02�� �����Ͽ� ����,
--PT_02���� �ִ� �����ʹ� �Է�,
--���ʿ� �ִ� �����ʹ� PT_02 �������� ����
insert into PT_02 values(12010103,1003,1,400);

merge into PT_01 p1
using PT_02 p2
   on (p1.�ǸŹ�ȣ = p2.�ǸŹ�ȣ)
 when matched then
update 
   set p1.�ݾ� = p2.�ݾ�
 when not matched then
 insert values(p2.�ǸŹ�ȣ, p2.��ǰ��ȣ, 
               p2.����, p2.�ݾ�);

select * from PT_01;
commit;

--[ commit / rollback ���� ]
update 1
delete 2
commit 3
insert 4
savepoint A
update 5
savepoint B
delete 6
1. rollback --3�� ���� �������� 
2. rollback to savepoint B --B ���ķ�, delete �� ���
;


-- ������ ��ųʸ�
-- DBMS�� �ڵ����� �����ϴ� ���̺� �� ��
-- �ַ� ��ü�� ���� ���� ���� �� 
-- ����, ���Ȱ� ���õ� ������ ���

--1. static dictionary view : ��ü ����
--1) dba_XXX
--   DBA ������ ���� ���� ��ȸ ����, ��� ��ü���� ���
--2) all_XXX
--   ��ȸ ���� ���� Ȥ�� ������ �ִ� ��ü ���� ���
--3) user_XXX
--   ��ȸ ���� ������ ��ü ������ ���

select * from user_tables;  -- scott ����
select * from all_tables;   -- scott ���� 
                            -- scott�� ������ �ο���
select * from dba_tables;   -- system �������� ��ȸ����

-- [ ������ ��ųʸ� �� ]
select * from user_indexes;      -- �ε��� ����
select * from user_ind_columns;  -- �ε��� �÷�����
select * from user_constraints;  -- �������� ����
select * from user_cons_columns; -- �������� �÷�����
select * from user_tab_columns;  -- ���̺��� �÷�����
select * from user_views;        -- �� ����
select * from user_users;        -- user ����

--2. dynamic performance view : ���� ����
-- v$XXX
-- dba���� Ȥ�� �� ���� ��ȸ ������ �־�� ��
select * from v$session;
select * from v$sql;

-- ��������(constraint) 
-- �������� ���Ἲ�� ���� �����ϴ� ������Ʈ
-- �� �÷����� ���������� ������ �� ����
--1. unique : �ߺ��� ��� X, NULL �Է� ����
--2. not null : null�� ��� X
--3. primary key(�⺻Ű) : �� ���� ������ �ĺ���
--   unique + not null ���������� ����
--4. check : ������ Ư�� ������ �Է� ����
--5. foreign key : Ư�� ���̺��� �÷��� ����

-- �������� ����
--1) ���̺� ������
create table cons_test1(
    no   number primary key,
    name varchar2(10) not null
);

insert into cons_test1 values(1,'��浿');
insert into cons_test1 values(1,'ȫ�浿');

create table cons_test2(
    no   number constraint test2_no_pk primary key,
    name varchar2(10) not null
);

insert into cons_test2 values(1,'��浿');
insert into cons_test2 values(1,'ȫ�浿');

--2) �̹� ������� ���̺� �������� �߰�
alter table emp_backup 
      add constraint emp_empno_pk primary key(empno);

alter table emp_backup 
      add unique(ename);
      
alter table emp_backup 
      add constraint emp_job_nn not null(job);  --�Ұ�
      
alter table emp_backup 
      modify job not null;
      
insert into emp_backup(empno, ename, job)
       values(7000, null, 'CLERK');

-- �ϳ��� ���̺��� �ϳ��� PK�� ���� ����
alter table emp_backup 
      add constraint emp_empno_pk primary key(ename);

alter table emp_backup 
      add constraint emp_empno_pk 
          primary key(empno,ename);

--[ ���� : ���� �÷��� �����Ͽ� �ϳ��� PK�� ����� ���]
����      â��
20200710   a
20200710   b
20200711   a;


-- foreign key 
-- �θ�, �ڽİ��� ���踦 ���� �ڽ� ���̺� ����
-- �������(�θ�)�� �÷��� reference key��� ��

--����) emp���̺� 50�� �μ��� ���ϴ� ȫ�浿 �� �߰�
insert into emp(empno,ename,deptno)
       values(1000,'ȫ�浿',50); -- ����(�θ�Ű�� ����)

--����) emp���̺� SMITH �μ���ȣ�� 50���� ����
update emp
   set deptno = 50
 where ename='SMITH'; --����(�θ�Ű�� ����)

--����) dept ���̺� 10�� �μ����� ����
delete from dept
 where deptno = 10;  --����(�ڽķ��ڵ� �߰�)

rollback;       






