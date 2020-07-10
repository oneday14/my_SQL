--1. STUDENT���̺��� ������ ��ո����Ժ��� 
--���� �л��� �̸�, �г�, ������, ��ո����� ���
--1) �ζ��� ��
select s.NAME, s.GRADE, s.WEIGHT, i.avg_weight
  from STUDENT s, (select substr(JUMIN,7,1) as gender, 
                          avg(WEIGHT) as avg_weight
                     from STUDENT
                    group by substr(JUMIN,7,1)) i
 where substr(s.JUMIN,7,1) = i.gender
   and s.WEIGHT > i.avg_weight;

--2) ��ȣ����(��� �����Դ� �Բ� ��� �Ұ�, �߰� ��ĵ)
select s.NAME, s.GRADE, s.WEIGHT
  from STUDENT s 
 where 1=1
   and s.WEIGHT > (select avg(WEIGHT)
                     from STUDENT s2
                    where substr(s.JUMIN,7,1) = 
                          substr(s2.JUMIN,7,1));
  
--2. emp2 ���̺��� �� ������ ���̰� �����鼭 ��̰� 
--���� ������ ���� ������ �̸�, �μ��̸�, ���, 
--pay�� �Բ� ����Ͽ���.
select e1.NAME, e1.HOBBY, e1.PAY,
       d.DNAME AS �μ��̸�,
       count(e2.EMPNO) AS "��̰� ���� ģ�� ��"
  from emp2 e1, emp2 e2, DEPT2 d
 where to_char(e1.BIRTHDAY, 'YYYY') =
       to_char(e2.BIRTHDAY(+), 'YYYY')
   and e1.HOBBY = e2.HOBBY(+)
   and e1.EMPNO != e2.EMPNO(+)
   and e1.DEPTNO = d.DCODE
 group by e1.EMPNO, e1.NAME, e1.HOBBY, e1.PAY, d.DNAME;

--3. student, professor ���̺��� ��������, 
--���� ������ ģ���� ������� ���ϰ�, 
--�� �л��� ��� �����̸��� �Բ� ��µǵ��� �Ͽ���.
--��, ��������, ���� ������ ������ ���Ե� �� ����.
p(+) - s1 - s2(+) ;

select s1.studno, s1.name, s1.grade,
       count(s2.studno) as ģ����,
       p.name as �����̸�
  from student s1, student s2, professor p
 where substr(s1.jumin,7,1) = substr(s2.jumin(+),7,1)
   and substr(s1.tel,1,instr(s1.tel,')')-1) = 
       substr(s2.tel(+),1,instr(s2.tel(+),')')-1)
   and s1.studno != s2.studno(+)
   and s1.profno = p.profno(+)
 group by s1.studno, s1.name, s1.grade, p.name;

--4. ������ ���� ��ü �ڷḦ ������ ���� ���
--(��, ��� �����鿡 ���� ��µǵ��� �Ѵ�)
--�����̸�	�����л��� �����л�_�������	A_�����ڼ�	B_�����ڼ�	C_�����ڼ�	D_�����ڼ�
--�ɽ�      	2	        79	                    1	        0	        0	        1
--����	        2	        83	                    0	        1	        1	        0
--������	    1	        97	                    1	        0	        0	        0
p - s(+) - e(+) - h(+);

select p.NAME AS �����̸�,
       count(s.NAME) AS �����л���,
       round(avg(nvl(e.TOTAL,0))) AS ���輺�����,
       count(decode(substr(h.GRADE,1,1),'A',1)) AS A��,
       count(decode(substr(h.GRADE,1,1),'B',1)) AS B��,
       count(decode(substr(h.GRADE,1,1),'C',1)) AS C��,
       count(decode(substr(h.GRADE,1,1),'D',1)) AS D��
  from PROFESSOR p, STUDENT s, 
       EXAM_01 e, HAKJUM h
 where p.PROFNO = s.PROFNO(+)
   and s.STUDNO = e.STUDNO(+)
   and e.TOTAL between h.MIN_POINT(+) and h.MAX_POINT(+)
 group by p.PROFNO, p.NAME
 ;
  
--5. STUDENT ���̺�� EXAM_01 ���̺��� ����Ͽ� �� 
--�л����� ���� �г� ���� ���輺���� ���� ģ���� ����
--����ϵ�, �̸�, �г�, �а���ȣ, ���輺���� �Բ� ���.

s1(+) - s2(+) 
|         |        =>  (s1 - e1) - (s2 - e2)(+)
e1(+) - e2(+)
;

select s1.name, s1.grade, e1.TOTAL,
       count(s2.STUDNO) AS �л���
  from STUDENT s1, EXAM_01 e1,
       STUDENT s2, EXAM_01 e2
 where s1.STUDNO(+) = e1.STUDNO
   and s2.STUDNO = e2.STUDNO(+)
   and s1.GRADE = s2.GRADE(+)
   and e1.TOTAL(+) < e2.TOTAL
 group by s1.name, s1.grade, e1.TOTAL;


select i1.*, count(i2.studno) AS ģ����
  from (select s1.NAME, s1.GRADE, e1.TOTAL
          from STUDENT s1, EXAM_01 e1
         where s1.STUDNO = e1.STUDNO) i1,
       (select s2.studno, s2.NAME, s2.GRADE, e2.TOTAL
          from STUDENT s2, EXAM_01 e2
         where s2.STUDNO = e2.STUDNO) i2
  where i1.grade = i2.grade(+)
    and i1.total < i2.total(+)
  group by i1.name, i1.grade, i1.total;

---------- ��������� �����Դϴ�. ----------  

--1. DDL : auto commit(���� �� ��� �ݿ�, rollback �Ұ�)
--1) create : ���̺� ����
--2) alter : ������ ���̺� ����
--           (�÷��߰�, �÷� ����, �÷� ������ Ÿ�� ����,
--           �÷� not null ���� ����, �÷� default�� ����)

--2-1) �÷� �߰� : �� �ڿ� �÷� �߰�
alter table EMP_BAK2 add DEPTNO2 number(5);
alter table EMP_BAK2 add (DEPTNO3 number(5),
                          DEPTNO4 number(5));
alter table EMP_BAK2 add DEPTNO5 number(5) default 10;

-- 2-2) �÷� ���� : ������ ���� �Ұ�
alter table EMP_BAK2 drop column DEPTNO4;
select * from EMP_BAK2;           
desc EMP_BAK2;

--2-3) �÷� ������ Ÿ�� ����
alter table EMP_BAK2 modify ENAME VARCHAR2(15); 
--=> column size �ø��� ����

alter table EMP_BAK2 modify ENAME VARCHAR2(1); 
--=> column size�� ����� ������ ���̺꺸�� �۰� �Ұ�
  
alter table EMP_BAK2 modify ENAME VARCHAR2(6); 
--=> ������ ������� ū ������� ���̱� ����

alter table EMP_BAK2 modify ENAME number(10); 
--=> �÷��� ������� ������ ���� �ٸ� Ÿ������ ���� �Ұ�

alter table EMP_BAK2 modify deptno2 varchar2(10); 
--=> ���÷��� ������ Ÿ�� ���� ����

select max(lengthb(ename))
  from emp;
  
--2-4) �÷� �̸� ����  
alter table EMP_BAK2 rename column deptno2 to deptno22;

--2-5) ���̺� �� ����(��ü�� ����)
rename EMP_BAK2 to EMP_BAKUP2;

--2-6) default �� ���� �� ���� 
-- �÷� ���� �� default�� ����, ���� ������ �� �Ҵ�
-- default : ���� �������� ������ �ڵ����� �ο�
-- default ���� ���� �Էµ� �����Ϳ� ���� �ο�
alter table EMP_BAK3 add (col1 varchar2(10),
                          col2 varchar2(10) default 'a');

alter table EMP_BAK3 modify col1 default 'b';

insert into EMP_BAK3 values('HONG',10,3000,NULL,NULL);
insert into EMP_BAK3(EMP_NAME, DEPTNO, SAL)
            values('PARK',20,4000);
commit;


-- ���� : read only, read write
insert into EMP_BAK4 values(9000,'kim',30,5000);
commit;

alter table EMP_BAK4 read only;
insert into EMP_BAK4 values(9001,'park',20,5000);
-- ����(insert,update,delete) �Ұ�

alter table EMP_BAK4 add col1 number(4);
-- alter�� ���� ���� �Ұ�

drop table EMP_BAK4;
-- ���̺� ���� ����


-- 3. drop : ���̺� ����(��ü ����)
-- ������ ���̺��� �����뿡�� ���� ����
-- purge �ɼ����� ������ ���̺��� ���� �Ұ�

-- ���� : drop���� ������ ���̺��� ����
select * from user_recyclebin;  -- ������

select * from EMP_BAK4;  --��ȸX

flashback table "BIN$x7B+A/YbTNic/qmo07vtew==$0"
to before drop;

select * from EMP_BAK4; -- ��ȸO

--4. truncate : ���̺� ���� ����� ������ ��ü ����
alter table EMP_BAK4 read write;
truncate table EMP_BAK4;

select * from EMP_BAK4; -- ��ȸO, ������ ����




