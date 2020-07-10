-- �����ͺ��̽� ���� ����
-- 1. DESC EMP�ǰ�����״������Ҽ��ֵ������������ۼ��ϼ���.
--    ��, ������ USER_TAB_COLUMNS ���̺���

 select COLUMN_NAME as "Column",
        decode(NULLABLE,'N','NOT NULL','') as "Nullable",
        DATA_TYPE ||
        case when COLUMN_NAME in ('SAL', 'COMM')  then '(' || DATA_PRECISION || ',' || DATA_SCALE || ')'
             when DATA_TYPE = 'VARCHAR2' then '(' || DATA_LENGTH || ')'
             when DATA_TYPE = 'NUMBER' then '(' || DATA_PRECISION || ')'
         end as "Type"
   from USER_TAB_COLUMNS
  where table_name = 'EMP';          -- ��� �ǹٸ�
  
-- SQL Ȱ�� ���� 
-- 1. student.csv, exam_01.csv ������ ���� Ŭ������� �о�鿩 ��������
--  1) �� �����͸� �����Ͽ� �л��� �̸�, ���輺�� ���

 select s.name, e.TOTAL
   from STUDENT s, EXAM_01 e
  where s.STUDNO = e.STUDNO;          -- ��� �ǹٸ�
  
--  2) ���￡ �����ϴ� ���л��� ������ ���

 select s.*, substr(tel, 1, instr(tel, ')') -1) as ������ȣ
   from STUDENT s
  where substr(tel, 1, instr(tel, ')') -1) = '02'
    and substr(jumin, 7,1) = '2';          -- ��� �ǹٸ�
    
--  3) ID�÷��� ���ڸ� �����ϴ� �л��� ���� ���

 select *
   from STUDENT
  where translate(ID,'1abcdefghijklmnopqrstuvwxyz','1') is not null;          -- ��� �ǹٸ�

--  4) �г⺰ ���� ���輺���� ����� ������ ���� ���·� ���
--          1  2  3  4
--       ��
--       ��

select decode(substr(jumin, 7,1),1,'��','��') as ����,
       avg(decode(s.grade, 1, e.total, '')) as "1",
       nvl(to_char(avg(decode(s.grade, 2, e.total, ''))),'NA') as "2",
       nvl(to_char(avg(decode(s.grade, 3, e.total, ''))),'NA') as "3",
       avg(decode(s.grade, 4, e.total, '')) as "4"
  from STUDENT s, EXAM_01 e
 where s.STUDNO = e.STUDNO
 group by substr(jumin, 7,1),1,'��','��';          -- ��� �ǹٸ�