--1. EMP ���̺��� ����̸�, �Ŵ�����ȣ(MGR)�� ����ϰ�, 
--�Ŵ�����ȣ�� null�̸� '����������'�� ǥ��, 
--�Ŵ�����ȣ�� ������ �Ŵ�����ȣ������� ǥ���Ͽ���
-- ex) mgr�� 7869�̸� 7869���
select empno, ename, mgr,
       nvl2(MGR, to_char(mgr)||'���','����������')
  from emp;
  
--2. Student ���̺��� jumin �÷��� �����Ͽ� �л����� 
--�̸��� �¾ ��, �׸��� �б⸦ ����϶�.
--�¾ ���� 01-03�� �� 1/4�б�, 04-06���� 2/4 �б�, 
--07-09 ���� 3/4 �б�, 10-12���� 4/4 �б�� ����϶�.
select name, jumin,
       substr(JUMIN,3,2),
case when to_number(substr(JUMIN,3,2)) between 1 and 3 
     then '1/4�б�'
     when to_number(substr(JUMIN,3,2)) between 4 and 6
     then '2/4�б�'
     when to_number(substr(JUMIN,3,2)) between 7 and 9
     then '3/4�б�'
     else '4/4�б�'
 end �б�1
  from STUDENT;

select name, jumin,
       to_char(to_date(substr(jumin,1,6),'RRMMDD'),
               'Q')||'/4�б�' AS �б�2
  from STUDENT;
  
--3. emp ���̺��� �λ�� ������ �������� 2000 �̸���
--'C', 2000�̻� 4000�̸��� 'B', 4000�̻��� 'A' ����� 
--�ο��Ͽ� �� ������ ���� ������ �Բ� ���
--**�λ�� ���� = ���� ���� 15% �λ� + ���ʽ�(comm)
select ENAME, SAL, comm, SAL*1.15, 
       SAL*1.15 + nvl(comm,0) AS new_sal,
       case when SAL*1.15 + nvl(comm,0) < 2000 then 'C'
            when SAL*1.15 + nvl(comm,0) < 4000 then 'B'
                                               else 'A'
        end AS ���
  from emp;

--4. EMP ���̺��� �̿��Ͽ� ����̸�, �Ի��� �� 
--�޿��������� ǥ���մϴ�. 
--�޿��������� ������ �ٹ��� �ش�Ǵ� ù��° ������ 
--��¥�� "Sunday the Seventh of September, 1981" 
--�������� ǥ��. �� �̸��� check�� �Ѵ�.
alter session set nls_date_language='american';

select ENAME, HIREDATE, 
       to_char(next_day(add_months(HIREDATE, 6),'mon'),
               'Day "of" ddspth "the" month, YYYY'),
       trim(to_char(next_day(add_months(HIREDATE, 6),'mon'),
               'Day'))||' the '||
       trim(to_char(next_day(add_months(HIREDATE, 6),'mon'),
               'ddspth'))||' of '||
       trim(to_char(next_day(add_months(HIREDATE, 6),'mon'),
               'month'))||
       to_char(next_day(add_months(HIREDATE, 6),'mon'),
               ',YYYY')        
  from emp;


--5. emp ���̺��� ����Ͽ� �������� ����� �Ʒ��� 
--���ؿ� �°� ǥ���ϼ���.
--2000�̸� 'C', 2000�̻� 3000���� 'B', 3000�ʰ� 'A'
--decode�� �ۼ�
select ename, sal, 
       sign(sal-2000), -- sal < 2000 => -1 
       sign(sal-3000),  -- sal > 3000 => 1
       decode(sign(sal-2000),-1,
              'C',decode(sign(sal-3000),1,'A','B')),
       decode(sign(sal-2000)+sign(sal-3000),-2,'C',
                                             2,'A','B')       
  from emp
 order by sal;

---------- ��������� �����Դϴ�. ----------

-- group by�� : �׷캰 �׷��Լ��� ����
-- "�и� - ���� - ����"�� ���� ����
-- �׷�� �� ���� �� ����
-- group by�� ��õ��� ���� �÷� select���� 
-- �ܵ� ���Ұ�, �׷��Լ��� �Բ� ��� �ʿ�
select deptno, max(sal)
  from emp
 group by deptno;

-- �׷��Լ� 
-- 1. sum
select sum(sal), sum(comm)
  from emp;

-- 2. count
select count(*),     -- ��ü�÷��� null�� �� ����, ���� ��Ȯ�� ���� �� ����
       count(empno), -- not null�÷��� null�� �� ����, ���� ������ ��Ȯ�� ���
       count(comm)   -- count�� null�� ���� ����
  from emp;

-- 3. avg
select avg(comm),   -- null ���� �� ���(4���� ���)
       sum(comm)/count(comm), -- avg �������� ����
       sum(comm)/14,  -- 14��(��ü)�� ���
       avg(nvl(comm,0)) -- 14��(��ü)�� ���
  from emp;
  
-- 4. min/max
select min(comm), max(comm)
  from emp;
  
-- ��������) �л����̺��� �� �г⺰, ����
-- �л����� Ű�� �������� ����� ����ϼ���
select grade, 
       decode(substr(jumin,7,1),'1','��','��') AS ����,
       count(STUDNO) AS �л���,
       round(avg(height),1) AS ���Ű, 
       avg(weight) AS ��ո�����
  from STUDENT
 group by grade, substr(jumin,7,1);

-- having�� : ���� ���� ����, �׷� ���� ����� ���� ���
--����) �л����̺��� �� �г⺰ ���Ű�� ���ϰ�
--      ���Ű�� 170 �̻��� �г⸸ ���
select grade, avg(height)
  from STUDENT
 where avg(height) >= 170 -- �׷��Լ��� where�� ���Ұ�
 group by grade;
 
select grade, avg(height)
  from STUDENT 
 group by grade
having avg(height) >= 170; 

-- [ select���� 6���� �� ���� ���� ]
-- select     -- 5
--   from     -- 1
--  where     -- 2
--  group by  -- 3
-- having     -- 4
--  order by  -- 6
; 
--��������) emp���̺��� 10�� �μ��� �����ϰ� 
--�������� ���� �μ��� ��� ������ ���Ͽ���
select deptno, avg(sal)
  from emp
 where deptno != 10
 group by deptno;

select deptno, avg(sal)
  from emp
 group by deptno
having deptno != 10;

--=> �Ϲ������� where, having�� ��� ��� �����ϳ�
--where���� ����ϴ� ���� ���ɻ� ����

-- ��������) EMP ���̺��� �μ� �ο��� 4���� ���� 
-- �μ��� �μ���ȣ, �ο���, �޿��� ���� ����Ͽ���. 
select DEPTNO, count(EMPNO) AS �ο���,
       sum(sal) AS �޿���
  from emp
 group by DEPTNO
having count(EMPNO) > 4;
  
-- ��������) EMP ���̺��� ������ �޿��� ����� 
-- 3000 �̻��� ������ ���ؼ� ������, ��� �޿�, 
-- �޿��� ���� ���Ͽ���.  
select job, avg(sal), sum(sal)
  from emp
 group by job, deptno
having avg(sal) >= 3000;

--������ ���� �����Ϳ��� job�� sal�� �� �հ� �Բ�
--�μ���ȣ�� �Բ� ����Ͽ���
job   deptno sal
A     10     1000
A     10     2000 
B     20     3000

select job, sum(sal), deptno
  from a
 group by job, deptno;

A  10   3000
B  20   3000
;

-- ���� ������ : select ����� ���� ������ ���ϴ� ����
--1. union/union all : ������
--2. intersect : ������
--3. minus : ������

-- ���� ����
-- select���� ǥ���Ǵ� �÷��� ����, ����, 
-- ������ Ÿ�� ��ġ
select ename, deptno, sal*1.1, '500'
  from emp
 where deptno = 10
 union 
select ename, deptno, sal*1.2, to_char(comm)
  from emp
 where deptno = 20;
   
-- union / union all�� ����
-- union : �ߺ��� ���� �����ϱ� ���� ���� ���� ����
-- union all : �ߺ� �� ���� ���� ��� ���, ���� ����X
-- => union / union all�� ����� ���ٸ� union all ����

select ename, deptno
  from emp
 where deptno in (10,20)
 union
select ename, deptno
  from emp
 where deptno = 10;   
   
select ename, deptno
  from emp
 where deptno in (10,20)
 union all
select ename, deptno
  from emp
 where deptno = 10;

-- intersect
select ename, deptno
  from emp
 where deptno in (10,20)
 intersect
select ename, deptno
  from emp
 where deptno = 10;

-- minus
select ename, deptno
  from emp
 where deptno in (10,20)
 minus
select ename, deptno
  from emp
 where deptno = 10;

-- ����  

--1. cross join : īƼ�þ� �� �߻�
--  (�߻������� ��� ����� ��)
--   �ַ� �������� ���� Ȥ�� �������� �������� ���޽�
--1) ����Ŭ ǥ��
select * 
  from emp, dept
 order by 1;

--2) ANSI ǥ��
select * 
  from emp cross join dept
 order by 1;
 
-- 2. inner join : �������ǿ� �´� �ุ �����ؼ� ���
-- 2-1) equi join(� ����) : ���� ������ '='
--1) ����Ŭ ǥ��
select emp.*, DNAME 
  from emp, dept
 where emp.DEPTNO = dept.DEPTNO
 order by 1;

--2) ANSI ǥ��
select e.*, DNAME 
  from emp e join dept d
    on e.DEPTNO = d.DEPTNO
 order by 1;
 
--[ ���� : ���̺� ��Ī ��� ]
--���̺� ��Ī�� ����ϴ� ��� �ݵ�� 
--�÷����� ��ó ���޽� ���̺� �̸��� �ƴ� ��Ī ���
select e.*, DNAME 
  from emp e, dept d
 where e.DEPTNO = d.DEPTNO
 order by 1;

SQL : ������ ǥ�� => ANSI ǥ��
      ORACLE ǥ��
;

--��������) student ���̺�� EXAM_01 ���̺��� ����Ͽ�
--�� �л��� �й�, �̸�, �г�, ���輺���� �Բ� ���
select s.STUDNO, s.NAME, s.GRADE, e.TOTAL
  from STUDENT s, EXAM_01 e
 where s.STUDNO = e.STUDNO;

select s.STUDNO, s.NAME, s.GRADE, e.TOTAL
  from STUDENT s join EXAM_01 e
    on s.STUDNO = e.STUDNO;

--��������) �� ����� ����Ͽ� �г⺰ ���輺����
--����� ����ϼ���
select s.GRADE, avg(e.TOTAL)
  from STUDENT s, EXAM_01 e
 where s.STUDNO = e.STUDNO
 group by s.GRADE;

select s.GRADE, avg(e.TOTAL)
  from STUDENT s join EXAM_01 e
    on s.STUDNO = e.STUDNO
 group by s.GRADE;

-- 2-2) non equi join(�� ����) 
--    : ���� ������ '='�� �ƴ� ���
select g1.GNAME AS ���̸�,
       g2.GNAME AS ��ǰ��
  from GOGAK g1, GIFT g2
 where g1.POINT between g2.G_START and g2.G_END; 
  
--��������) �� ���̺��� ����Ͽ� �� ���� ������ �� 
--�ִ� ��� ��ǰ ����� ���
select g1.GNAME AS ���̸�, 
       g2.GNAME AS ��ǰ��
  from GOGAK g1, GIFT g2
 where g1.POINT >= g2.G_START
 order by 1;
 
--��������) �� �������� �غ��� ��ǰ�� �ִ� ������
--��ǰ�̸��� �Բ� ����ϵ�,
--�� ��ǰ�� �ּ� ����Ʈ ���ǰ� �ִ� ����Ʈ ������
--�Բ� ����ϼ���.
select g2.GNAME AS ��ǰ��,
       count(g1.gno) AS ����,
       g2.G_START,
       g2.G_END
  from GOGAK g1, GIFT g2
 where g1.POINT >= g2.G_START
 group by g2.GNAME, g2.G_START, g2.G_END;

  
  
  
  