--1. EMP2 ���̺��� ����⵵(1960,1970,1980,1990)���� 
--��տ����� ���϶�.
select trunc(to_char(BIRTHDAY,'YYYY'), -1), 
       round(avg(PAY))
  from emp2
 group by trunc(to_char(BIRTHDAY,'YYYY'), -1);
 
--2. emp2 ���̺�� p_grade ���̺��� ��ȸ�Ͽ� ������� 
--�̸��� ����, ��������, ���������� ����ϼ���. 
--���������� ���̷� ����ϸ� �Ҽ������ϴ� �����ϼ���.
select e.name, 
       e.position as ��������, 
       p.position as ��������,
       trunc((sysdate - e.birthday)/365) as ����1,
       2020 - to_char(e.birthday,'yyyy') as ����2
  from emp2 e, p_grade p
 where trunc((sysdate - e.birthday)/365) 
       between p.s_age and p.e_age;
  
--3. STUDENT ���̺�� PROFESSOR ���̺��� ����Ͽ�
--3,4�г� �л��� �������� ������ �Բ� ����Ͽ�
--�� ���������� �����л��� ��������� ���� ������
--�����̸�, ���ް� �Բ� ����Ͽ���.
select p.NAME AS �����̸�, p.POSITION, p.PAY, p.HIREDATE,
       count(s.name) AS �л���
  from STUDENT s, PROFESSOR p
 where s.PROFNO = p.PROFNO
   and s.GRADE in (3,4)
 group by p.PROFNO, p.NAME, p.POSITION, p.PAY, p.HIREDATE;

--4. ����Ʈ�� �ۼ��ϰ��� �Ѵ�.
--emp ���̺��� �̿��Ͽ� �� �μ��� �������� ����ϵ� ������ ���� �������� �ۼ��Ͽ���.
--
--����Ʈ��	       10_������	 20_������	  30_������
----------------------------------------------------------
--�����̸� ����Ʈ	        3	         5           6

select deptno, count(empno)
  from emp
 group by deptno;
 
select '������ ����Ʈ' AS ����Ʈ��, 
       sum(decode(deptno,10,1)) AS "10_������",
       count(decode(deptno,20,'�ִ�')) AS "20_������",
       count(decode(deptno,30,1)) AS "30_������"
  from emp;

---------- ��������� �����Դϴ�. ----------

-- 3�� �̻� ���̺� ���� ����
--����) STUDENT�� PROFESSOR, DEPARTMENT ���̺��� �����Ͽ�
--3,4�г� �л��� ���� �� �л��� �̸�, ��1������,
--�������� �̸��� �Բ� ���
-- d - s - p 
select s.NAME, s.GRADE, d.DNAME, p.NAME
  from STUDENT s, PROFESSOR p, DEPARTMENT d
 where s.DEPTNO1 = d.DEPTNO
   and s.PROFNO = p.PROFNO
   and s.GRADE in (3,4);
   

--��������) STUDENT, EXAM_01, HAKJUM ���̺��� ����Ͽ�
--�� �л��� �̸�, ��������, ������ ����Ͽ���
s(studno) - e(studno, total) - h(min_point,max_point);

select s.NAME, e.TOTAL, h.GRADE 
  from STUDENT s, EXAM_01 e, HAKJUM h
 where s.STUDNO = e.STUDNO
   and e.TOTAL between h.MIN_POINT and h.MAX_POINT;

--��������) �� �����͸� Ȱ���Ͽ� �� ������ �л��� ���
--��, ������ A,B,C,D�� ��� ���
select substr(h.GRADE,1,1) AS ����,
       count(s.STUDNO) AS �л���, 
       avg(e.TOTAL) AS �������
  from STUDENT s, EXAM_01 e, HAKJUM h
 where s.STUDNO = e.STUDNO
   and e.TOTAL between h.MIN_POINT and h.MAX_POINT
 group by substr(h.GRADE,1,1);


-- �Ȱ��� ���̺��� �ߺ� ���� ����
d(deptno) - s(deptno1, profno) - p(profno, deptno) - d(deptno)
;
select s.name, s.grade, s.DEPTNO1, d1.DNAME,
       p.name, p.DEPTNO, d2.DNAME
  from STUDENT s, PROFESSOR p, 
       DEPARTMENT d1, DEPARTMENT d2
 where s.PROFNO = p.PROFNO
   and s.DEPTNO1 = d1.DEPTNO
   and p.DEPTNO = d2.DEPTNO
   and s.GRADE in (3,4);


-- outer join
--- inner join�� �ݴ�
--- ���� ���ǿ� ���� �ʴ� �����͵� ��� ����
--- ������ �Ǵ� ���̺� ���⿡ ����
--  1) left outer join : ���� ���̺� ����
--  2) right outer join : ������ ���̺� ����
--  3) full outer join : ���� ���̺� ����

--����) �� �л��� �̸�, �������� �̸��� ����ϵ�,
--���������� ���� �л����� ���� ���
select s.name AS �л��̸�,
       p.name AS �����̸�
  from STUDENT s, PROFESSOR p
 where s.PROFNO = p.PROFNO(+);
  
select s.name AS �л��̸�,
       p.name AS �����̸�
  from STUDENT s left outer join PROFESSOR p
    on s.PROFNO = p.PROFNO;

select s.name AS �л��̸�,
       p.name AS �����̸�
  from PROFESSOR p right outer join STUDENT s
    on s.PROFNO = p.PROFNO;

--����) STUDENT�� PROFESSOR�� full outer join ����
select s.name AS �л��̸�, p.name AS �����̸�
  from STUDENT s full outer join PROFESSOR p
    on s.PROFNO = p.PROFNO;

select s.name AS �л��̸�, p.name AS �����̸�
  from STUDENT s, PROFESSOR p
 where s.PROFNO(+) = p.PROFNO(+); -- �����߻�
 
select s.name AS �л��̸�, p.name AS �����̸�
  from STUDENT s, PROFESSOR p
 where s.PROFNO(+) = p.PROFNO
 union 
select s.name AS �л��̸�, p.name AS �����̸�
  from STUDENT s, PROFESSOR p
 where s.PROFNO = p.PROFNO(+); 

--��������) STUDENT, DEPARTMENT���̺��� ����Ͽ�
--�� �л��� �̸�, ��2������, �г��� �Բ� ���
select s.NAME, s.GRADE, d.DNAME
  from STUDENT s, DEPARTMENT d
 where s.DEPTNO2 = d.DEPTNO(+);
 
select s.NAME, s.GRADE, d.DNAME
  from STUDENT s left outer join DEPARTMENT d
    on s.DEPTNO2 = d.DEPTNO;

-- ��ȯ ������ ���� ����� outer join
-- ����) �� �л��� �̸�, �г�, ���������̸���
--       ���������� �Ҽ� �а����� �Բ� ����ϼ���
s - p(+) - d(+) - p2(+);

s - p(+) - d(+)
|
d;

select s.NAME AS �л��̸�, s.grade, 
       p.name AS �����̸�, d.DNAME
  from STUDENT s, PROFESSOR p, DEPARTMENT d
 where s.PROFNO = p.PROFNO(+)
   and p.DEPTNO = d.DEPTNO(+);
  
-- self join : �ϳ��� ���̺��� ������ �����ϴ� ���
-- �ѹ��� ��ĵ���� ���� ��� �Ұ����� ������ 
-- ���� ���̺��� �ߺ� ��ĵ���� ��� ��� ������ ���

-- ����) emp ���̺��� ����Ͽ� �� ������ �̸�, sal,
-- ������������ �̸�, sal�� ���� ���
select e1.ENAME AS �����̸�,
       e2.ENAME AS �����������̸�
  from emp e1, emp e2
 where e1.MGR = e2.EMPNO(+);

--��������) DEPARTMENT ���̺��� ����Ͽ�
--�� �а���� �����а����� ���� ���,
--�� �����а��� ���� ��쵵 ���
select d1.DNAME AS �а���, 
       d2.DNAME AS �����а���
  from DEPARTMENT d1, DEPARTMENT d2
 where d1.PART = d2.DEPTNO(+);
 
--����) �� ������� �����а��� ���� ���
--�����а� �̸��� ���� �а� �̸��� ���
select d1.DNAME AS �а���, 
       nvl(d2.DNAME, d1.DNAME) AS �����а���
  from DEPARTMENT d1, DEPARTMENT d2
 where d1.PART = d2.DEPTNO(+);
 
--��������) professor ���̺��� ������ ��ȣ, �����̸�, 
--�Ի���, �ڽź��� �Ի��� ���� ��� �ο����� ���     
--��, �ڽź��� �Ի����� ���� ������� ������������ ���
select p1.PROFNO, p1.NAME, p1.HIREDATE,
       count(p2.PROFNO) AS ����� 
  from PROFESSOR p1, PROFESSOR p2
 where p1.HIREDATE > p2.HIREDATE(+)
 group by p1.PROFNO, p1.NAME, p1.HIREDATE
 order by p1.NAME;
 
--��������) STUDENT ���̺��� �� �л��� �̸�,�г�,
--Ű�� ���, ���� �г⳻�� �� �л����� Ű�� ū �л� ��
--�Բ� ���
select s1.NAME, s1.GRADE, s1.HEIGHT,
       count(s2.STUDNO) AS "Ű�� ū �л���"
  from STUDENT s1, STUDENT s2
 where s1.GRADE = s2.GRADE(+)
   and s1.HEIGHT < s2.HEIGHT(+)
 group by s1.STUDNO, s1.NAME, s1.GRADE, s1.HEIGHT
 order by s1.NAME;

-- ��������(sub-query) : ���� ���� ����
--  ** �� : ���̺�ó�� ��������� ���� ������ 
--          ���̺�ó�� ��ȸ�� ������(�̸�����) ��ü
--          
select col1, (select ...)        -- ��Į�� ��������
  from tab1, tab2, (select ...)  -- �ζ��� ��**
 where col1 = (select ...)       -- ��������
;

--����) emp ���̺��� ALLEN���� SAL�� ���� ��� ���
select *
  from emp
 where SAL < 1600;
 
select *
  from emp
 where SAL < (select SAL
                from emp
               where ENAME = 'ALLEN');  -- CTRL + l
