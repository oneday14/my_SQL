-- �������� ����
--\\192.168.0.115
--ID : kitcoop
--PW : ����(�׳� ����)

-- ���� ��Ű��(�Ʒ� ���̺���� ������)
--scott : emp, dept
--hr : employees

-- [ ����Ű ] 
-- ���Ͽ��� : ctrl + o
-- �빮�� ���� : ctrl + shift + u
-- �ҹ��� ���� : ctrl + u

-- between A and B : A�� B���� ��ȯ
-- A�� B�� ����, A�� �� ���� ���̾�� ��

select *
  from emp
 where sal between 1000 and 2000;

-- in : ���Կ�����, �������� ��ġ�ϴ� ���� ����
select * 
  from student
 where GRADE in (1,2);

select * 
  from student
 where NAME in ('������','������');

-- null ����
select *
  from emp
 where COMM is null;

select *
  from emp
 where COMM is not null;
 
-- like : ���� ������ 
-- % : �ڸ��� ���� ���� ���
-- _ : �� �ڸ��� ���

--����) emp���̺��� �̸��� S�� �����ϴ� ���� ���
select *
  from emp
 where ename like 'S%';
 
--����) student ���̺��� �̸��� �ι�° ���ڰ� '��'��
--      �л� ���� ���
select *
  from student
 where name like '%��%';

select *
  from student
 where name like '_��%';

-- ���� ������
select *
  from student
 where grade != 4;
 
-- ����) student ���̺��� 3,4�г��� �ƴ� �л�
select *
  from student
 where grade != 3
   and grade != 4;
 
select *
  from student
 where grade not in (3,4);
 
--����) student���� �����԰� 50 ~ 60�� �ƴ� �л� ���
select *
  from student
 where weight not between 50 and 60;

select ename, sal, sal * 1.1 AS "10% �λ�� ����"
  from emp;
  
--����) emp���� 10% �λ�� ������ 3000������ ���� ����  
select ename, sal, sal * 1.1 AS "10% �λ�� ����"
  from emp
 where sal * 1.1 <= 3000; 
 
--��������1) EMP ���̺��� �޿��� 1100 �̻��̰ų�, 
--�̸��� M���� �������� �ʴ� ��� ��� 
select *
  from emp
 where sal >= 1100
    or ename not like 'M%';
  
--��������2) EMP ���̺��� JOB�� Manager, Clerk, 
--Analyst�� �ƴ� ��� ���
select *
  from emp
 where initcap(JOB) not in ('Manager', 
                            'Clerk', 
                            'Analyst');
 
--��������3) EMP ���̺��� JOB�� PRESIDENT�̰� 
--�޿��� 1500 �̻��̰ų� ������ SALESMAN�� ��� ���
select *
  from emp
 where (job = 'PRESIDENT'
   and sal >= 1500)
    or job = 'SALESMAN';
 
select *
  from emp
 where job = 'PRESIDENT'
   and (sal >= 1500
    or job = 'SALESMAN');

select *
  from emp
 where job in ('PRESIDENT', 'SALESMAN')
   and sal >= 1500;
    
-- A and (B or C)
-- (A and B) or (A and C)

-- order by�� : ����
select *
  from emp
 order by DEPTNO asc;

select *
  from emp
 order by DEPTNO desc;

select *
  from emp
 order by DEPTNO, SAL desc;

-- select������ ���ǵ� �÷� ��Ī�� ����
select ename, deptno AS �μ���ȣ, sal * 1.1
  from emp
 where �μ���ȣ = 10;  -- �Ұ�

select ename, deptno AS �μ���ȣ, sal
  from emp
 order by �μ���ȣ;    -- ����
  
select ename, deptno AS �μ���ȣ, sal
  from emp
 order by 1,2;  -- select���� ������ �÷� ������ ����


-- ��¥ ����� ����
alter session set nls_date_format='RR/MM/DD';

-- ����� ��¥ ���� : 'YYYY/MM/DD'
-- ��� ��¥ ����   : 'YYYY/MM/DD HH24:MI:SS'

select *
  from emp
 where HIREDATE = '1980/12/17';
 
-- 1980/12/17�� ������ �Ի��� ��� ���
select *
  from emp
 where HIREDATE < '1980/12/17';

select *
  from emp
 where to_char(HIREDATE, 'YYYY/MM/DD HH24:MI:SS')
       = '1981/02/20 00:00:00';

-- �Լ�
--�Լ��� : input value�� ���� output value�� �޶�����
--         input�� output�� ���踦 ������ ��ü
       

--������ �Լ� : 1���� input�� 1���� output return

--������ �Լ�(�׷��Լ�) : �������� input�� 
--                        1���� output return
select ename, lower(ename)
  from emp;
  
select sum(sal)
  from emp;

-- ���ġȯ�Լ� : initcap, upper, lower
select 'abc def', 
       initcap('abc def')
  from dual;

select 'abc def', 
       initcap('abc def', 'aaa')
  from dual;

-- substr : ���ڿ� ���� �Լ�
-- substr(���,������ġ[,���ⰳ��])
select 'abcde', 
       substr('abcde',1,2),
       substr('abcde',3,1),
       substr('abcde',3),
       substr('abcde',-2)
  from dual;

--����) emp���̺��� �ι�° �̸��� M�� ���� ����
select *
  from emp
 where ENAME like '_M%';

select *
  from emp
 where substr(ename,2,1) ='M';
 
-- ��������) student ���̺��� ���л��̸鼭
-- ��������� 1975�� 7�� 1�� ���Ŀ� �¾ �л� ����

select * 
  from student
 where BIRTHDAY > '1975/07/01'
   and JUMIN like '______2%';
   
select * 
  from student
 where BIRTHDAY > '1975/07/01'
   and substr(JUMIN,7,1) = '2';  
   
--��������) student ���̺��� 78�⿡ �¾ �л� ����
select *
  from student
 where substr(jumin,1,2) = '78' ;

alter session set nls_date_format='YY/MM/DD';

select name, BIRTHDAY, substr(BIRTHDAY,1,2)
  from student
 where substr(BIRTHDAY,1,2) = '78'; 

select name, BIRTHDAY, substr(BIRTHDAY,1,2)
  from student
 where BIRTHDAY like '78%';  
 
alter session set nls_date_format='YYYY/MM/DD'; 

select name, BIRTHDAY, substr(BIRTHDAY,1,2)
  from student
 where BIRTHDAY like '1978%';  
  
select name, BIRTHDAY
  from student
 where BIRTHDAY between '1978/01/01' and '1978/12/31';  

alter session set nls_date_format='RR/MM/DD';
-- '78/01/01' => '1978/01/01'

alter session set nls_date_format='YY/MM/DD';
-- '78/01/01' => '2078/01/01'

select name, BIRTHDAY
  from student
 where BIRTHDAY between '1978/01/01' and '1978/12/31';  

select name, BIRTHDAY
  from student
 where BIRTHDAY between '78/01/01' and '78/12/31';  


-- instr : �������ڿ����� Ư�����ڿ��� ��ġ�� ����
-- instr(�������ڿ�,Ư�����ڿ�[,��ġ][,�߰�Ƚ��])
select 'ababba',
       instr('ababba','a',1,3),
       instr('ababba','a',1),
       instr('ababba','a'),
       instr('ababba','A'),
       instr('ababba','a',-4,2)
  from dual;

select tel, substr(tel,1,3)
  from student;

-- ��������) student ���̺��� ������ȣ�� ����
-- 055)381-2158  => 055
-- 02)6255-9875  => 02

select tel,
       instr(tel,')'),
       substr(tel,
              1,
              instr(tel,')')-1)
  from student;


 
 
 
 
 