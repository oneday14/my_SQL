--1. student ���̺��� 10���� �¾ �л���
--�̸�, �г�, ��������� ����ϵ�
--�¾ ���� ����������� �����Ͽ���.
select *
  from student
 where JUMIN like '__10%';
 
select *
  from student
 where substr(JUMIN,3,2) = '10'; 
 
-- 1975/10/23 00:00:00  => substr(BIRTHDAY,6,2)
-- 75/10/23             => substr(BIRTHDAY,4,2)
select name, birthday, substr(BIRTHDAY,4,2)
  from STUDENT 
 where substr(BIRTHDAY,4,2) = '10';
 
alter session set nls_date_format='YYYY/MM/DD';
select name, birthday, substr(BIRTHDAY,6,2) AS ��
  from STUDENT 
 where substr(BIRTHDAY,6,2) = '10'
 order by substr(BIRTHDAY,-2);
 
--2. student ���̺��� �� �л��� ���� ����
--051)426-1700  => 426
--02)6255-9875  => 6255
select NAME, 
       TEL,
       instr(TEL,')') AS ")�� ��ġ",
       instr(TEL,'-') AS "-�� ��ġ",
       substr(tel,
              instr(tel,')') + 1,
              instr(TEL,'-') - instr(TEL,')') - 1)
  from STUDENT;

--3. student ���̺��� ���� '��'�� �л��� 
--�й�, �̸�, �г��� ����Ͽ���
select *
  from student
 where NAME > '��'
   and name < '��';

--4. EMPLOYEES ���̺��� ��Ҹ� �������� �ʰ� 
--email�� last_name�� ���ԵǾ� ���� ���� 
--����� EMPLOYEE_ID, FIRST_NAME, EMAIL�� ����Ͽ���.
--(EMPLOYEES ���̺��� hr �������� ��ȸ ����)
select * 
  from employees
 where instr(EMAIL,upper(LAST_NAME)) = 0;

select *
  from EMPLOYEES
 where EMAIL not like '%'||upper(LAST_NAME)||'%';
 
--OConnell DOCONNEL (X)
--Grant DGRANT (O)
--Whalen JWHALEN (O)
--De Haan LDEHAAN (X)

---------- ��������� �����Դϴ�. ----------

-- length : ���ڿ��� ���� ���
select ename, length(ename)
  from emp;

select name, 
       length(name) AS "���ڼ�",
       lengthb(name) AS "Byte size"
  from STUDENT;

-- lpad, rpad : ���ڿ��� ����
-- lpad(���,�ѱ���[,���Թ���])
select 'abcd',
       lpad('abcd',5,'!'),
       rpad('abcd',5,'!'),
       length(rpad('abcd',5))
  from dual;
  
-- ltrim, rtrim, trim : ���ڿ��� ����
-- ltrim(���[,�����ҹ���])
-- trim(���)
select 'ababa',
       ltrim('ababa','a'),
       rtrim('ababa','a'),
       length(rtrim('ababa ')),
       length(trim('   ababa '))
  from dual;

-- [ �׽�Ʈ - ���ڿ��� ���ʿ��� ���� ���Խ� ��ȸ���� X ]
create table test1(col1 varchar2(5),
                   col2 char(5));

insert into test1 values('ab','ab');
commit;

select *
  from test1
 where COL1 = COL2;   -- ���� 'ab' 'ab   '�� ����Ǿ�
                      -- ��ġ���� �ʾ� ��ȸ���� ����

select *
  from test1
 where COL1 = trim(COL2);
 
select length(col1), length(col2)
  from test1;

-- replace : ġȯ�Լ�
-- replace(���,ã�����ڿ�,�ٲܹ��ڿ�)
select 'abcba',
       replace('abcba','ab','AB'),
       replace('abcba','c',''),
       replace('ab c ba',' ','')
  from dual;

-- translate : ġȯ�Լ�(����)
-- translate(���,ã�����ڿ�,�ٲܹ��ڿ�)
select 'abcba',
       replace('abcba','ab','AB'),
       translate('abcba','abc','ABC'),
       translate('abcba','!ab','!'),
       translate('abcba','ab','ABC')       
  from dual;

--��������) PROFESSOR���̺��� ���� ���̵𿡼� 
--          Ư������ ��� ���� �� ���
select id, 
       replace(replace(id,'-',''),'_',''),
       translate(id,'a-_','a')
  from PROFESSOR;

--��������) emp ���̺��� �޿��� ��� ������ �ڸ�����
--���
select sal, lpad(sal,4,0) 
  from emp;

--��������) STUDENT ���̺��� �̸��� �ι�° ���ڸ�
--#ó��
select name, replace(NAME,
                     substr(NAME,2,1),
                     '#')
  from STUDENT;


-- �����Լ�
-- round : �ݿø�
-- trunc : ����
select 1234.56,
       round(1234.56,1),  -- �Ҽ��� �ι�°���� �ݿø�
       round(1234.56),    -- �Ҽ��� ù��°���� �ݿø�
       trunc(1234.56,1),  -- �Ҽ��� �ι�°���� ����
       round(1234.56,-3)  -- ���� �ڸ����� �ݿø�
  from dual;
  
select ename, sal, trunc(sal * 1.15) AS "15%�λ�� SAL"
  from emp;
  
-- mod : ������
select 7/3,
       trunc(7/3) AS ��,
       mod(7,3) AS ������
  from dual;
  
-- floor : ������ ���� �ִ�����
-- ceil : ������ ū �ּ�����
select 2.33,
       floor(2.33) AS "������ ���� �ִ�����",
       ceil(2.33) AS "������ ū �ּ�����"
  from dual;

-- abs : ���밪
select -2.3,
       abs(-2.3)
  from dual;
  
-- sign : ��ȣ�Ǻ�
select sign(1.1),
       sign(-1.1),
       sign(0)
  from dual;
  
-- ��¥ �Լ�
-- sysdate : ���糯¥ �� �ð�
select sysdate
  from dual;

select sysdate + 100
  from dual;

select ename, 
       trunc(sysdate - hiredate) as �ٹ��ϼ�
  from emp;
  
--��������) emp ���̺��� �� ����� ���� ��¥ ����
--�������� ����Ͽ���
--������ = �⺻��(sal) / 12 * �ټӳ��
select ename, sal, hiredate,
       trunc(sysdate - hiredate) AS �ٹ��ϼ�,
       trunc(trunc(sysdate - hiredate)/365) AS �ټӳ��,
       trunc((sysdate - hiredate)/365) AS �ټӳ��,
       trunc(sal / 12 * trunc((sysdate - hiredate)/365))
       AS ������
  from emp;

-- months_between : �� ��¥ ���� ������ ����
select ename, hiredate,
       sysdate - hiredate AS �ٹ��ϼ�,
       months_between(sysdate,hiredate),
       trunc((sysdate - hiredate)/365) AS �ټӳ��,
       trunc(months_between(sysdate,hiredate) / 12)
       AS �ټӳ��2
  from emp;

select sysdate, 
       sysdate + 3*31,       -- ����Ȯ�� 3���� �� ��¥
       add_months(sysdate,3) -- ��Ȯ�� 3���� �� ��¥
  from dual;

--next_day : �ٷ� �ڿ� ���� Ư�� ������ ��¥ ����
-- 1 : �Ͽ���, 2 : ������, .....
select sysdate,
       next_day(sysdate,1),
       next_day(sysdate,'��')
  from dual;

alter session set nls_date_language='american';
select sysdate,
       next_day(sysdate,1),
       next_day(sysdate,'mon')
  from dual;
  
alter session set nls_date_format='MM/DD/YYYY';
select sysdate from dual;  --2020/07/02 14:21:38
  
-- last_day : �ش� ��¥�� ���� ���� ������ ��¥ ����
select sysdate,
       last_day(sysdate)
  from dual;
  
--����1) EMP ���̺��� ������� �ٹ��ϼ��� 
--�� ��, �� ���ΰ��� ����Ͽ���.
--��, �ٹ��ϼ��� ���� ��� ������ ����Ͽ���.   
select ename, 
       trunc(sysdate - hiredate) AS �ٹ��ϼ�,
       trunc((sysdate - hiredate)/7) AS �ٹ��ּ�,
       mod(trunc(sysdate - hiredate),7) AS �������ϼ� 
  from emp;

--����4) EMP ���̺��� 10�� �μ����� �Ի����ڷκ��� 
--���ƿ��� �ݿ����� ����Ͽ� ����Ͽ���. 
select ename, hiredate, next_day(hiredate,'fri')
  from emp
 where deptno = 10;
 
-- ��ȯ�Լ� : �������� Ÿ���� ��ȯ
--1. to_char : ���ڰ� �ƴ� ���� ���ڷ� ��ȯ
-- 1) ���� -> ����
--     - 1000 -> 1,000
--     - 1000 -> $1000
-- 2) ��¥ -> ����
--     - 1981/06/09 -> 06
--     - 1981/06/09 -> 81-06-09
select 1000,
       to_char(1000,'9,999'),
       to_char(1000,'999.99'),  -- #######
       to_char(1000,'9999.99'),
       to_char(1000,'99999'),   -- ' 1000'
       to_char(1000,'09999'),   -- '01000'
       to_char(1000,'$9,999'),
       to_char(1000,'9,999')||'\'
  from dual;
  
-- 2020/07/02 15:19:13  => 07/02/2020
select sysdate, 
       to_char(sysdate,'MM/DD/YYYY') 
  from dual;
  
select sysdate, 
       to_char(sysdate,'MM/DD/YYYY') + 1 -- ����Ұ�
  from dual;

--����) emp ���̺��� 1981�� 2�� 22�Ͽ� �Ի��� 
--��� ���
select * 
  from emp
 where to_char(HIREDATE,'MM/DD/YYYY') = '02/22/1981';

select * 
  from emp
 where HIREDATE = to_char('1981/02/22', 'RR/MM/DD');
--     => �����߻�, to_char�� ù��° �μ��� ���� �Ұ�
 
--2. to_number : ���ڰ� �ƴ�(���ڷ� ���� ������)����
--               ���ڷ� ����
               
--3. to_date : ��¥�� �ƴ� ���� ��¥�� ��ȯ(�Ľ�) 
select to_date('2020/06/30','YYYY/MM/DD') + 100
  from dual;

select to_date('09/07/2020','MM/DD/YYYY'),
       to_date('09/07/2020','DD/MM/YYYY')
  from dual;
 
select * 
  from emp
 where HIREDATE = to_date('1981/02/22','YYYY/MM/DD'); 
 
select *
  from student
 where to_char(BIRTHDAY,'MM') = '06';
  
 