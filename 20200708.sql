--1) student���̺��� �� �л��� �̸�, ��1�����а����� 
--����ϰ� ����������� �̸��� ���������� �Ҽ� �а��� 
--�Բ� ����Ͽ���. ��, ���������� ���� �л��� ��� ���.
d(+) - p(+) - s - d;

select s.name as �л��̸�, d1.dname as ��1������,
       p.name as ���������̸�, d2.dname as �����а�
  from student s, department d1,
       professor p, department d2
  where s.deptno1 = d1.deptno
    and s.profno = p.profno(+)
    and p.deptno = d2.deptno(+);
    
select s.name as �л��̸�, d1.dname as ��1������,
       p.name as ���������̸�, d2.dname as �����а�
  from department d1 join student s
    on s.deptno1 = d1.deptno
       left outer join professor p
    on s.profno = p.profno
       left outer join department d2
    on p.deptno = d2.deptno;


--2) student ���̺�� exam_01, department ���̺��� 
--�̿��Ͽ� �� �а��� ��� ������ �ְ� ����, ���� ������ 
--��Ÿ���� �а��̸�(��1����), �а���ȣ�� �Բ� ���.
d - s - e ;
select d.dname, d.deptno, 
       avg(e.total), min(e.total), max(e.total)
  from student s, exam_01 e, department d
 where s.studno = e.studno
   and s.deptno1 = d.deptno
 group by d.dname, d.deptno;
 
select d.dname, d.deptno, 
       avg(e.total), min(e.total), max(e.total)
  from student s join exam_01 e
    on s.studno = e.studno
       join department d
    on s.deptno1 = d.deptno
 group by d.dname, d.deptno; 

--3) emp2 ���̺��� �� ������ ���̰� �����鼭 
--��̰� ���� ������ ���� ������ �̸�, �μ��̸�, ���, 
--pay�� �Բ� ����Ͽ���.
d - e1 - e2(+);
select e1.name as �����̸�, e1.birthday, 
       e1.hobby, e1.pay, d.dname,
       count(e2.name) as ģ����
  from emp2 e1, emp2 e2, dept2 d
 where e1.hobby = e2.hobby(+)
   and to_char(e1.birthday, 'yyyy') = 
       to_char(e2.birthday(+), 'yyyy')
   and e1.empno != e2.empno(+)
   and e1.deptno = d.dcode
 group by e1.empno, e1.name, e1.birthday, 
          e1.hobby, e1.pay, d.dname
 order by e1.empno;

select e1.name as �����̸�, e1.birthday, 
       e1.hobby, e1.pay, d.dname,
       count(e2.name) as ģ����
  from emp2 e1 left outer join emp2 e2
    on (e1.hobby = e2.hobby
   and to_char(e1.birthday, 'yyyy') = 
       to_char(e2.birthday, 'yyyy')
   and e1.empno != e2.empno)
       join dept2 d
   on  e1.deptno = d.dcode
 group by e1.empno, e1.name, e1.birthday, 
          e1.hobby, e1.pay, d.dname
 order by e1.empno;         
          
--4) emp ���̺��� �̿��Ͽ� ���ΰ� ������������ 
--��տ������� ���� ������ �޴� ������
--�̸�, �μ���, ����, ���������ڸ��� ����Ͽ���.
select e1.ename as �����̸�, e1.sal, d.dname,
       e2.ename as �Ŵ����̸�, e2.sal,
       (e1.sal + nvl(e2.sal, e1.sal))/2 as ��տ���
  from emp e1, emp e2, dept d
 where e1.mgr = e2.empno(+)                         -- e1�� e2�� ������ �� ���Ǹ� �ƿ������� �ʿ�
   and e1.sal >= (e1.sal + nvl(e2.sal, e1.sal))/2   -- �� ������ �ƿ��� ���� �ʿ� ����
   and e1.deptno = d.deptno;

select e1.ename as �����̸�, e1.sal, d.dname,
       e2.ename as �Ŵ����̸�, e2.sal,
       (e1.sal + nvl(e2.sal, e1.sal))/2 as ��տ���
  from emp e1 join emp e2                            -- e1�� e2�� left outer join�� �ɸ� �� ������ ������ ���������ڿ��� ��� �������� ���� ���ǿ� �������� �ʾƵ� ��� ���
    on (e1.mgr = e2.empno
   and e1.sal >= (e1.sal + nvl(e2.sal, e1.sal))/2)
       join dept d
    on e1.deptno = d.deptno;

---------- ��������� �����Դϴ�. ----------

-- ��������
--1. where���� ���Ǵ� ��������
--1) ������ �������� : ���������� ����� ������(�� �÷�)
select *
  from emp
 where sal > (select sal
                from emp
               where ename = 'ALLEN');

--����) ALLEN�� �μ��� ���� �μ��� ���� ���� ���� ���
select deptno
  from emp
 where ename = 'ALLEN';

select *
  from emp
 where deptno = 30;

select *
  from emp
 where deptno = (select deptno
                   from emp
                  where ename = 'ALLEN');
                  
--2) ������ �������� : ���������� ����� ������(�� �÷�)
-- where���� ���Ǵ� �����ڿ� =, ��Һ� ��� �Ұ�

--��������) �̸��� M���� �����ϴ� ������ ���� �μ���
--�ִ� ������ ��� ���(�̸��� M���� �����ϴ� ��������)
select deptno 
  from emp
 where ENAME like 'M%';

select *
  from emp
 where deptno in (select deptno 
                    from emp
                   where ENAME like 'M%');
                   
--����) �̸��� M���� �����ϴ� ������ �������� ���� 
--���� ���
select *
  from emp
 where sal > (select avg(sal)          -- min, max 
                from emp
               where ENAME like 'M%'); --1250,1300

-- ������ ������(>)�� �°� �������� ����(1�� �� ����)
select *
  from emp
 where sal > (select max(sal)          --1300    
                from emp
               where ENAME like 'M%');

-- ������ ���������� �°� ������ ����(ALL)
select *
  from emp
 where sal > all(select sal             --1300    
                   from emp
                  where ENAME like 'M%');
  
 > all(1250,1300)  <=>   > 1300  : �ִ밪 ����
 < all(1250,1300)  <=>   < 1250  : �ּҰ� ����
 
 > any(1250,1300)  <=>   > 1250  : �ּҰ� ����
 < any(1250,1300)  <=>   < 1300  : �ִ밪 ���� 
;

--��������) �л����̺��� 4�г� �л� �� Ű�� ���� ����
--�л����� ���� �л��� ����ϼ���
select HEIGHT
  from STUDENT
 where grade = 4;
 
select *
  from STUDENT
 where height < (select min(HEIGHT)
                   from STUDENT
                  where grade = 4);

select *
  from STUDENT
 where height < all(select HEIGHT
                      from STUDENT
                     where grade = 4);
                     
--3) �����÷� �������� : �������� ��� ����� ���� �÷�
-- �׷쳻 ��� �� �Ұ� => ��ȣ����, �ζ��κ� ��ü

--����) emp ���̺��� �� �μ��� �ִ� ������ �Բ�
--      �� �μ��� �ִ� ������ ���� ���� �̸� ���
select deptno, max(sal)
  from emp
 group by deptno;

select *
  from emp
 where (deptno, sal) in (select deptno, max(sal)
                           from emp
                          group by deptno);

--��������) PROFESSOR ���̺��� �� position��
--���� ���� �Ի��� ����� �̸�, �Ի���, position,
--pay ���
select POSITION, min(HIREDATE)
  from PROFESSOR
 group by POSITION;
 
 select NAME, HIREDATE, POSITION, PAY 
   from PROFESSOR
  where (POSITION, HIREDATE) in (select POSITION, 
                                        min(HIREDATE)
                                   from PROFESSOR
                                   group by POSITION);
 
--����) emp ���̺��� �� �μ��� ��տ������� ����
--������ �޴� ������ ���� ���
select *
  from EMP
 where (deptno, sal) > (select deptno, avg(sal)
                          from emp
                         group by deptno); 
                     -- ����, �����÷� ��Һ� �Ұ�

select *
  from EMP
 where deptno in (select deptno
                   from emp
                  group by deptno)
   and sal > (select avg(sal)
                from emp
               group by deptno);

--4) ��ȣ���� �������� : ���������� ���������� ���� ����

--2. from���� ���Ǵ� ��������(�ζ��κ�)
select * 
  from emp e, (select deptno, avg(sal) AS avg_sal
                 from emp
                group by deptno) i
 where e.DEPTNO = i.DEPTNO
   and e.SAL > i.avg_sal;

--��������) STUDENT ���̺��� ���� ��������
--��ո����Ժ��� ���� �л��� �̸�, ����, �г�, ������
--���
select NAME, 
       decode(substr(s.JUMIN,7,1),'1','��','��') AS ����,
       GRADE, WEIGHT
  from STUDENT s, (select substr(JUMIN,7,1) AS gender, 
                          avg(weight) AS avg_weight
                     from STUDENT
                    group by substr(JUMIN,7,1)) i
 where substr(s.JUMIN,7,1) = i.gender
   and s.WEIGHT < i.avg_weight;

