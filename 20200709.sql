--��������) PROFESSOR ���̺��� �Ի�⵵��
--��� �������� ���� ������ �̸�, �Ҽ��а���, PAY,
--�����л� ���� �Բ� ���
select p.NAME, d.dname, p.PAY, 
       count(s.NAME) AS �����л���
  from PROFESSOR p, DEPARTMENT d, STUDENT s,
       (select to_char(HIREDATE,'YYYY') AS hyear,
               avg(pay) AS avg_pay
          from PROFESSOR
         group by to_char(HIREDATE,'YYYY')) i
 where to_char(p.HIREDATE,'YYYY') = hyear
   and p.PAY > avg_pay
   and p.DEPTNO = d.DEPTNO
   and p.PROFNO = s.PROFNO(+)
 group by p.PROFNO, p.NAME, d.dname, p.PAY;

---------- ��������� �����Դϴ�. ----------   

d - p - i
    |
    s(+);

-- ��������
--1. where�� ��������
-- 1)������ �������� : =, ��Һ� ����
-- 2)������ �������� : =, ��Һ� �Ұ� => in, any, all
-- 3)�����÷� �������� : �׷쳻 ����� ����,
--                       �׷쳻 ��Һ� �Ұ� => �ζ��κ�
-- 4)��ȣ���� �������� : �׷쳻 ��Һ� ����

--����) emp ���̺��� �� job�� �ּҿ����� �޴� ������
--�̸�, job, sal ���
select *
  from emp
 where job in (select job
                from emp
               group by job)   -- �׷�񱳷� ���� X
   and sal in (select min(sal) --    (������ ��)
                from emp
               group by job);  -- ���� �߻� X,
                               -- �׷쳻 �� �߻� X

select *
  from emp e1
 where e1.job = e2.job         -- ���� �߻�
   and sal in (select min(sal)
                from emp e2
               group by job);

select *
  from emp e1
 where sal in (select min(sal)
                 from emp e2
                where e1.job = e2.job -- ���������� �̵�
                group by job);
               
select *
  from emp 
 where (job,sal) in (select job, min(sal)
                       from emp
                      group by job);

empno job sal
1     a   3000   ***
2     a   4000
3     b   3000
4     b   2000   ***
;

-- ��ȣ���� ���������� �������
select *
  from emp e1
 where sal in (select min(sal)
                 from emp e2
                where e1.job = e2.job 
                group by job);

1) ù��° ���� SAL Ȯ�� : 800
2) �������� ���� �� e1.job �䱸 : CLERK
3) ���������� where���� 'CLERK' = e2.job ����
4) ������������ job�� 'CLERK'�� ���� min(sal) ���� : 800
5) ���������� �������� 800 = 800 �̹Ƿ� ù ��° �� ����
6) ������ �� ��� �ݺ�
;

--��������) PROFESSOR ���̺��� �Ҽ��а��� PAY�� 
--���� ū ������ ���� ���
--1) �����÷�
select *
  from PROFESSOR
 where (deptno, pay) in (select deptno, 
                                max(pay) AS max_pay
                           from PROFESSOR
                          group by deptno);
--2) �ζ��κ�
select *
  from PROFESSOR p, (select deptno, 
                            max(pay) AS max_pay
                       from PROFESSOR
                      group by deptno) i
 where p.deptno = i.deptno
   and p.PAY = i.max_pay;
   
--3) ��ȣ����
select *
  from PROFESSOR p1
 where pay = (select max(pay) AS max_pay
                from PROFESSOR p2
               where p1.DEPTNO = p2.DEPTNO);

--2. from�� ��������(�ζ��κ�)

--��������) emp2 ���̺��� ���Ÿ��(EMP_TYPE)��
--��� PAY���� ���� �޴� ������ ���;
--1) �ζ��κ�
select *
  from emp2 e, (select emp_type, 
                       avg(pay) AS avg_pay
                  from emp2
                 group by emp_type) i 
 where e.EMP_TYPE = i.emp_type
   and e.PAY > i.avg_pay;
   
--2) ��ȣ����
select *
  from emp2 e
 where 1=1
   and e.PAY > (select avg(pay) AS avg_pay
                  from emp2 i
                 where e.EMP_TYPE = i.emp_type);
   
--3. select�� ��������(��Į�� ��������)
-- select���� ���Ǵ� ��������

-- 1) �ϳ��� ����� ��ü�ϱ� ���� �뵵
--����) ALLEN�� �̸�, JOB, SAL, DEPTNO�� ����ϵ�
--ALLEN�� �μ��� SMITH�� �μ��� �����ϰ� ���
select ENAME, JOB, SAL, 20 AS deptno
  from emp
 where ENAME='ALLEN';

select ENAME, JOB, SAL, 
       (select deptno 
          from emp
         where ename = 'SMITH') AS deptno
  from emp
 where ENAME='ALLEN';

--����) ALLEN�� �̸�, JOB, SAL, DEPTNO�� ����ϵ�
--ALLEN�� �μ��� M���� �����ϴ� ������ �μ������� ���
select ENAME, JOB, SAL, 
       (select deptno 
          from emp
         where ename like 'M%') AS deptno -- �����߻�
  from emp
 where ENAME='ALLEN';

-- 2) ������ ��ü ����(Ư�� �÷��� ǥ��)
-- �������ǿ� ���� �ʴ� �����͵� ���(�ƿ������� ��ü)

--��������) emp, dept ���̺��� �� ������ �̸�, 
--sal, �μ����� �Բ� ���(��Į�� ��������)
select e.ENAME, d.DNAME
  from emp e, dept d
 where e.DEPTNO = d.DEPTNO;

select e.ENAME, (select d.DNAME
                   from dept d
                  where e.DEPTNO = d.DEPTNO)
  from emp e;

--��������) emp ���̺��� ����Ͽ� �� ������ �̸�,
--���������� �̸��� ���� ���(��Į�� ��������)
select e1.ename AS ������, 
       e2.ENAME AS �����ڸ�
  from emp e1, emp e2
 where e1.MGR = e2.EMPNO(+);
 
select e1.ename AS ������, 
       (select e2.ENAME 
          from emp e2
         where e1.MGR = e2.EMPNO) 
  from emp e1;
 
--��������) STUDENT, PROFESSOR ���̺��� ���,
--�л��̸�, ���������̸� ���
--��, �������� �̸��� ���� ��� 'ȫ�浿' ���
select s.name AS �л��̸�,
       nvl(p.name,'ȫ�浿') AS �����̸�
  from STUDENT s, PROFESSOR p
 where s.PROFNO = p.PROFNO(+);

select s.name AS �л��̸�,
       nvl((select p.name
              from PROFESSOR p
             where s.PROFNO = p.PROFNO), 
           'ȫ�浿') AS �����̸�
  from STUDENT s;

--��������) STUDENT, EXAM_01, HAKJUM ���̺��� ����Ͽ�
--�� �л��� �̸�, ���輺��, ������ ����ϵ�
--��Į�� ���������� 2�� ���
select s.NAME,
       e.TOTAL,
       h.GRADE
  from STUDENT s, EXAM_01 e, HAKJUM h
 where s.STUDNO = e.STUDNO
   and e.TOTAL between h.MIN_POINT and h.MAX_POINT;

select (select s.NAME 
          from STUDENT s 
         where s.STUDNO = e.STUDNO) AS �л��̸�,
       e.TOTAL,
       (select h.GRADE
          f
          rom HAKJUM h
         where e.TOTAL between h.MIN_POINT and 
                               h.MAX_POINT) AS ����
  from EXAM_01 e;
 

select s.NAME, e.TOTAL,
       (select h.GRADE
          from HAKJUM h
         where e.TOTAL between h.MIN_POINT 
                           and h.MAX_POINT) AS ����
  from STUDENT s, EXAM_01 e
 where s.STUDNO = e.STUDNO;

-- ���� : ��ȯ ������ ���� ����� �ƿ��� ���� ����
--        => �������� ���
a - b(+)
|   |
d - c

a(+) - b(+)
|       |      : ��ȯ���� ���� �߻�
d(+) - c(+)

(a - d) - (b - c)(+)   ;


-- ���� ��� �з� 
--1. DDL : ��ü�� ���� ���
--         ��ü ����(create), ����(alter), ����(drop),
--         ��ü ����(truncate)
--         
--2. DML : ������ ���� ���
--         ������ �Է�(insert), 
--         ����(update), 
--         ����(delete)
--         
--3. DCL : Ʈ����� ��Ʈ�� ���
--         ����(commit), ���(rollback)


-- 1. DDL(Data Definition Language)
-- 1) create : ���̺� �� ��ü ����
create table test2(
col1    varchar2(10) not null,
col2    number(10)
);

--** ���̺���� �ٸ� ��ü �̸��� �ߺ��� �� ������
--������ �ٸ��� �ߺ��� ���̺���� ����� �� ����
scott.emp
hr.emp
;

-- ���̺� �����ϱ�
-- (CTAS : Create Table As Select)
create table emp_bak
as
select *
  from emp;

select * from emp_bak;

create table emp_bak2
as
select *
  from emp
 where DEPTNO = 10;

create table emp_bak3
as
select ename AS emp_name, deptno, sal
  from emp;

select * from emp_bak3;

create table emp_bak4
as
select to_char(empno) AS empno, ename AS emp_name, 
       deptno, sal
  from emp;
  
desc emp_bak4;

-- �� ���̺� �����ϱ�(������ ����)
create table emp_bak5
as
select * 
  from emp
 where 1=2;  -- �׻� �������� ����, no date selected

select * from emp_bak5;

desc emp_bak5;

create table STUDENT_bak
as
select * from STUDENT;
desc STUDENT;

���� �� CTAS�� �������� �ʴ� �����? 5
1. �÷��̸�
2. �÷�����
3. �÷�Ÿ��
4. �ο���
5. ��������
;




