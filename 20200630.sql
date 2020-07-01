-- [ orange ����Ű ]
-- sql ���� : ctrl + enter
-- �ּ�ó�� : ctrl + -
-- �ּ�ó�� ���� : ctrl + shift + -
-- sql�� ���ġ : ctrl + shift + f
-- ���� : ctrl + s
  
-- ���̺� : ��� ���� ������ ���� �������� ���� ����

-- 1. ���̺� ���̾ƿ� Ȯ��
desc emp;

--[ Ȯ�� ���� ���� ]
--1) �÷���/�÷�����
--2) null(���� ���ǵ��� ���� ����) ����
--3) ������ Ÿ��/ũ��
--  - NUMBER(4) : 4�ڸ� ����
--  - VARCHAR2(9) : 9 ����Ʈ ������ ����
--    'abcde'
--  - CHAR(9) : 9 ����Ʈ ������ ����
--    'abcde    '
--  - DATE : ��¥

-- ���� > ����
-- ���� �÷��� ���� ���� ����
-- ���� �÷��� ���� ���� �Ұ�

-- [ ��ȸ ��� : select�� ] 
select           -- ���̺� �� ����� ���ϴ� �÷�/ǥ����
  from ���̺��  -- ��ȸ�� �����Ͱ� ���Ե� ���̺�� 
 where
 group by
having
 order by
;

select *
  from emp; -- query
  
select empno, ename
  from emp;
  
select empno, ename, sal, sal + 1000, 10000
  from emp;  


-- distinct : �� �ߺ� ����
select distinct DEPTNO 
  from emp;

select distinct JOB, DEPTNO
  from emp;

select *
  from employees;   -- hr �������� ��ȸ����
  

select empno, 1000, 'a'
  from emp;
  
-- �÷� ��Ī
select empno AS "��� ��ȣ",  -- 
       ename "�����!",       --
       sal "Salary"           --
  from emp;
  
--Alias �������� 1 : 
--DEPT ���̺��� ����Ͽ� deptno �� �μ�#, dname �μ���, 
--loc �� ��ġ�� ������ �����Ͽ� ����ϼ���. 
select DEPTNO "�μ�#",
       dname �μ���,
       loc ��ġ
  from dept;
  
--Distinct �������� 1 : 
--EMP ���̺��� �μ���(deptno)�� ����ϴ� ����(job)�� 
--�ϳ��� ��µǵ��� �Ͽ���.
select distinct deptno, job
  from emp;


-- ���Ῥ����(||) : ���� �и��Ǿ��� �÷��� �ϳ��� ��ħ
select empno||'-'||ename
  from emp;
  
select concat(concat(empno,'-'), ename)
  from emp;

--����) ������ ���� �������� ���
--SMITH�� ������ 800�Դϴ�.

select ENAME||'�� ������ '||SAL||'�Դϴ�. '
  from emp;

-- ������(WHERE) : ���ǿ� �´� ���� ����(����)
-- * ������ ���� : ���(�÷�) ������ ���

--����) emp ���̺��� 10�� �μ������� ������ ���
select *
  from EMP
 where DEPTNO = 10;

--����) emp ���̺��� ALLEN�� �̸�, �μ���ȣ, ������
--      ���
select ENAME, DEPTNO, SAL 
  from emp
 where lower(ENAME) = 'allen';

select lower(ENAME), DEPTNO, SAL 
  from emp
 where upper(ENAME) = 'ALLEN';

--����) emp ���̺��� sal�� 2000�̻��� ������
--      �̸�, �μ���ȣ, sal, comm ���
select ENAME, DEPTNO, SAL, COMM
  from emp
 where SAL >= 2000;

--����) emp ���̺��� 10�� �μ��� ��
--      sal�� 2000�̻��� ������
--      �̸�, �μ���ȣ, sal, comm ���
select ENAME, DEPTNO, SAL, COMM
  from emp
 where SAL >= 2000
   and DEPTNO = 10;
   
   
   
   
 


