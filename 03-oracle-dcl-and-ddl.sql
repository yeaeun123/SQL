-------------------------
-- DCL and DDL
-------------------------

-- 사용자 생성
-- CREATE USER 권한이 있어야 함
-- SYSTEM 계정으로 수행
--connect system/manager

--사용자 생성 : CREATE USER username IDENTIFIED BY password;
--비밀번호 변경 : ALTER USER username IDENTIFIED BY password;
--사용자 삭제 : DROP USER username [CASCADE];
         ---> CASCADE : 폭포수 -user객체,user스키마와 연결된 모든 db객체 삭제
-----------------------------    
--DCL – Data Control Language 데이터 제어 언어 GRANT(부여), REVOKE(반환)
-----------------------------
/*주의사항
사용자를 생성하려면 CREATE USER 권한 필요
생성된 사용자가 Login 하려면 CREATE SESSION 권한 필요
일반적으로 CONNECT, RESOURCE의 ROLE을 부여하면 일반사용자 역할을 수행할 수 있음*/

-- GRANT~ TO 권한부여 / REVOKE ~ FROM 권한회수 =>실행즉시 효력발휘
-- GRANT ~ TO ~ [WITH ADMIN OPTION] 
            --->WITH ADMIN OPTION은 조심! 모든 권한을 주는 것임-(권한부여포함)
---------------------------------------------------------------------------          
--시스템 권한            
-- GRANT 시스템권한목록 TO 사용자|역할|PUBLIC WITH ADMIN OPTION] -> 시스템 권한부여
-- REVOKE 회수할 권한 FROM 사용자|역할|PUBLIC 

--객체 관련 권한
-- GRANT 객체개별권한|ALL ON 객체명 TO 사용자|역할|PUBLIC [WITH ADMIN OPTION]
-- REVOKE 회수할 권한 ON 객체명 FROM 사용자|역할|PUBLIC


-- himedia라는 이름의 계정을 만들고 비밀번호 himedia로 설정
--CREATE USER himedia IDENTIFIED BY himedia;

-- Oracle 18버전부터 Container Datebase 개념 도입 
-- 계정 생성 방법1. 사용자 계정 c##
CREATE USER C##HIMEDIA IDENTIFIED BY himedia;

-- 비밀번호 변경 : ALTER USER
ALTER USER C##HIMEDIA IDENTIFIED BY new_password;

-- 계정 삭제: DROP USER
DROP USER C##HIMEDIA CASCADE;  --CASECADE :폭포수 or 연결된 것 의미

-- 계정 생성 방법 2. CD기능 무력화 
-- 연습 상태, 방법2를 사용해서 사용자 생성(추천하진 않음)
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER himedia IDENTIFIED BY himedia;
-- USER를 생성해도 권한(Privilege)를 주지 않으면 아무 일도 할 수 없음
-- Role(롤) : 권한을 쉽게 관리하기위해 종류별로 묶어놓은 그룹
-- 아직 접속 불가
-- 데이터베이스 접속, 테이블 생성 데이터베이스 객체 작업을 수행 -> CONNECT / RESOURCE
GRANT CONNECT, RESOURCE TO himedia;
-- cmd로 가서  sqlplus himedia/himedia ->접속됨
-- cmd-> CREATE TABLE test(a NUMBER);
-- cmd-> DESC test;   --테이블 test의 구조 보기

-- himedia 사용자로 진행
-- test table에 데이터 추가 
DESCRIBE test;
INSERT INTO test VALUES (2024);
-- USERS 테이블스페이스에 대한 접근 권한이 없다! 
-- Oracle 18이상에서 발생하는 문제
-- SYSTEM 계정으로 수행
ALTER USER himedia DEFAULT TABLESPACE USERS 
    QUOTA unlimited on USERS;   --tablespace 권한 부여
    --QUOTA = 용량 
    
-- himedia계정에서 진행
INSERT INTO test VALUES (2024);
SELECT * FROM test;

SELECT * FROM USER_USERS;   -- 현재 로그인한 사용자 정보(나)
SELECT * FROM ALL_USERS;    -- 모든 사용자 정보
-- DBA전용 (sysdba로 로그인해야 확인 가능)
-- cmd 에서: sqlplus sys/oracle as sysdba  -> sysdba로 접속 가능
-- cmd에서 : SELECT * FROM DBA_USERS;
-- system계정에서 진행
SELECT * FROM DBA_USERS;

--시나리오 : HR 스키마의 employees 테이블 조회 권한을 himedia에게 부여하고자 한다.
-- HR 스키마의 owner -> HR
-- HR로 접속
--권한부여
GRANT select ON employees TO himedia;

--himedia계정으로 확인
SELECT * FROM hr.employees; --hr.employees에 select 할 수 있는 권한만 부여
SELECT * FROM hr.departments; -- hr.departments 권한부여 받지 않아서 찾을 수 없음

--현재 사용자에게 부여된 Role을 조회
SELECT * FROM USER_ROLE_PRIVS;
-- CONNECT 와 RESOURCE 역할은 어떤 권한으로 구성되어 있는가?
--  sysdba로 진행
--cmd에서 sqlplus sys/oracle as sysdba
--cmd에서 DESC role_sys_privs;
--CONNECT ROLE에는 어떤 권한이 포함되어 있는가?
--cmd에서 SELECT privilege FROM role_sys_privs WHERE role='CONNECT';
-- RESOURCE ROLE에는 어떤 권한이 포함되어 있는가?
--cmd에서 SELECT privilege FROM role_sys_privs WHERE role='RESOURCE';

-------------------------
--DDL – Data Definition Language 
--데이터 정의 언어 CREATE(생성), ALTER(변경), DROP(삭제), TRUNCATE(초기화) 
-------------------------
/* 
 CREATE TABLE : 테이블 생성
 ALTER TABLE : 테이블 관련 변경
 DROP TABLE : 테이블 삭제 (복구불가)
 RENAME : 이름 변경 (복구불가)
 TRUNCATE : 테이블의 모든 데이터 삭제 (비우기/복구불가!!! ) ***중요
 COMMENT : 테이블에 설명 추가(복구불가)
 */
 
 -- 스키마 내의 모든 테이블을 확인 
 SELECT * FROM tabs; -- tabs : 테이블 정보 Dictionary
 
 -- 테이블 생성 : CREATE TABLE
 CREATE TABLE book (
            book_id NUMBER(5),
            title VARCHAR2(50),
            author VARCHAR2(10),
            pub_date DATE DEFAULT SYSDATE
            );
-- 만든 테이블 정보 확인
DESC book;
 
-- Subquery를 이용한 테이블 생성 
SELECT * FROM hr.employees;
--HR.employees 테이블에서 job_id가 IT 관련된 직원들의 목록으로 새 테이블을 생성해보자
SELECT * FROM hr.employees WHERE job_id LIKE 'IT_%';

CREATE TABLE emp_it AS (
    SELECT * FROM hr.employees WHERE job_id LIKE 'IT_%'
    ); -- Subquery를 이용한 테이블 생성 ->NOT NULL 제약 조건만 돌려받음
SELECT * FROM tabs; --테이블 목록 정보확인
DESC emp_it;

-- 테이블 삭제 : DROP TABLE 삭제할테이블
DROP TABLE emp_it;

SELECT * FROM tabs; --테이블 목록 정보확인
DESC book;


-- author 테이블 생성
-- PK->NOT NULL + UNIQUE
CREATE TABLE author (author_id NUMBER(10),
                    author_name VARCHAR2(100) NOT NULL,
                    author_desc VARCHAR2(500),
                    PRIMARY KEY (author_id)
                    );
DESC author;

--book 테이블의 author 컬럼 삭제
-- 나중에 author_id 컬럼 추가 -> author.author_id와 참조 연결할 예정
ALTER TABLE book DROP COLUMN author;
DESC book;

-- book 테이블에 author_id컬럼 추가
-- author.author_id를 참조하는 컬럼  author.author_id와 같은 형태여야함
ALTER TABLE book ADD (author_id NUMBER(10));
DESC book;
DESC author;

-- book 테이블에 book_id도 author 테이블의 PK와 같은 데이터타입(NUMBER(10))으로 변경
ALTER TABLE book MODIFY (book_id NUMBER(10));
DESC book;

-- book 테이블의 book_id 컬럼에 PRIMARY KEY 제약조건을 부여
ALTER TABLE book 
ADD CONSTRAINT pk_book_id PRIMARY KEY (book_id);
DESC book;

-- book 테이블의 author_id 컬럼과 author 테이블의 author_id를 FK로 연결

ALTER TABLE book
ADD CONSTRAINT fk_author_id
    FOREIGN KEY (author_id)
    REFERENCES author(author_id);

--Data Dictionary
--VIEW의 Prefix (USER:로그인한 사용자레벨, ALL:모든 사용자정보,DBA:관리자)
-- USER_ : 현재 로그인된 사용자에게 허용된 뷰
-- ALL_ : 모든 사용자 뷰
-- DBA_ : DBA에게 허용된 뷰
-- DICTIONARY의 테이블이나 컬럼 이름은 모두 대문자 사용! 

--모든 딕셔너리 확인
SELECT * FROM DICTIONARY; --1098

-- 사용자 스키마 객체 : USER_OBJECTS
SELECT * FROM USER_OBJECTS; 
-- 사용자 스키마의 이름과 타입 정보 출력
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS;

-- 제약조건 확인
SELECT * FROM USER_CONSTRAINTS;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, 
        SEARCH_CONDITION, TABLE_NAME
FROM USER_CONSTRAINTS;

-- book 테이블에 적용된 제약조건의 확인
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE,
        SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'BOOK';


--INSERT : 테이블에 새 레코드(튜플) 추가
-- 제공된 컬럼 목록의 순서와 타입, 값 목록의 순서와 타입이 일치해야한다.
-- 컬럼 목록을 제공하지 않으면 테이블 생성시 정의된 컬럼의 순서와 타입을 따른다.

--삽입 : INSERT INTO 테이블명 VALUES (값의 목록);
---> 값 목록의 순서 -> TABLE 설계대로 (전체)

-- 삽입2: INSERT INTO 테이블명 (컬럼이름목록) VALUES (값목록);
---> (컬럼 이름목록) 순서대로-> VALUES 값을 제공 (특정 컬럼만)

-- 컬럼 목록이 제시되지 않았을 때
INSERT INTO author
VALUES (1, '박경리', '토지 작가');

SELECT * FROM author;

-- 컬럼 목록을 제시했을 때, 
-- 제시한 컬럼의 순서와 타입대로 값 목록을 제공해야 한다.
INSERT INTO author (author_id, author_name)
VALUES(2, '김영하');

SELECT * FROM author;

-- 컬럼 목록을 제공했을 때,
-- 테이블 생성시 정의된 컬럼의 순서와 상관없이 데이터 제공 가능
INSERT INTO author (author_name, author_id, author_desc)
VALUES ('류츠신', 3, '삼체 작가');

SELECT * FROM author;

--TRUNCATE TABLE 테이블명; ->전체 레코드 삭제 (속도빠름/완전삭제/복구불가)
TRUNCATE TABLE author;

ROLLBACK;   -- 반영 취소 (되돌리기)

SELECT * FROM author;

INSERT INTO author
VALUES(1, '박경리', '토지 작가');
INSERT INTO author (author_id, author_name)
VALUES(2, '김영하');
INSERT INTO author (author_name, author_id, author_desc)
VALUES ('류츠신', 3, '삼체 작가');

SELECT * FROM author;

--ALTER TABLE author RENAME COLUMN ANTHOR_NAME TO author_name;
COMMIT;     -- 변경사항 반영

SELECT * FROM author;

-- UPDATE
-- 특정 레코드의 컬럼 값을 변경한다.
-- WHERE 절이 없으면 모든 레코드가 변경!!! 
-- 가급적 WHRER절로 변경하고자 하는 레코드를 지정하도록 한다.

--변경1.: UPDATE 테이블명 SET 변경내용; -> 전체레코드 변경

--변경2: UPDATE 테이블명 SET 변경내용 WHERE 변경할 레코드 조건; 
        --->변경할 레코드 조건에 해당하는 레코드만 변경

UPDATE author 
SET author_desc = '알쓸신잡 출연';

SELECT * FROM author;

ROLLBACK;

SELECT * FROM author;

UPDATE author
SET author_desc = '알쓸신잡 출연'
WHERE author_name = '김영하';

SELECT * FROM author;

COMMIT;

--연습
-- hr.employees 테이블을 기반으로 department_id 10, 20, 30인 직원들만 새 테이블 emp123으로 생성
DROP TABLE emp123;
CREATE TABLE emp123 AS
    (SELECT * FROM hr.employees 
        WHERE department_id IN(10, 20, 30));
        
DESC emp123;
SELECT first_name, salary, department_id FROM emp123;

-- 부서가 30번인 직원들의 급여를 10 % 인상해보자
UPDATE emp123
SET salary = salary + salary * 0.1
WHERE department_id = 30;

SELECT * FROM emp123;


-- DELETE
-- 테이블로부터 특정 레코드를 삭제
-- WHERE 절이 없으면 모든 레코드 삭제 (주의!!)

--삭제: DELETE FROM 테이블명; ->전체 레코드 삭제(휴지통/복구가능)
--삭제2: DELETE FROM 테이블명 WHERE 삭제할 레코드 조건;
      --->삭제할 레코드 조건에 해당하는 레코드만 삭제
--TRUNCATE TABLE 테이블명; ->전체 레코드 삭제 (속도빠름/완전삭제/복구불가)

-- JOB_ID가 MK_로 시작하는 직원들 삭제
DELETE FROM emp123 
WHERE job_id LIKE 'MK_%';

SELECT * FROM emp123;

DELETE FROM emp123; -- WHERE 절이 생략된 DELETE문은 모든 레코드를 삭제 ->주의!
SELECT * FROM emp123;

ROLLBACK;

---------------------------
--TRANSACTION
---------------------------
-- 트랜젝션 테스트 테이블
CREATE TABLE t_test(
    log_text VARCHAR2(100)
    );

-- 첫 번쨰 DML이 수행된 시점에서 Transaction
INSERT INTO t_test VALUES('트랜잭션 시작');
SELECT * FROM t_test;
INSERT INTO t_test VALUES ('데이터 INSERT');
SELECT * FROM t_test;
 
SAVEPOINT sp1;  -- 세이브 포인트 설정

INSERT INTO t_test VALUES ('데이터 2 INSERT');
SELECT * FROM t_test;

SAVEPOINT sp2;  -- 세이브 포인트 설정

UPDATE t_test SET log_text = '업데이트'; -- 모든 레코드가 '업데이트'로 바뀜(WHERE없음)
SELECT * FROM t_test;

ROLLBACK TO sp1;   --sp1로 귀환
SELECT * FROM t_test;

INSERT INTO t_test VALUES('데이터 3 INSERT');
SELECT * FROM t_test;

--반영: COMMIT / 취소 : ROLLBACK
-- 명시적으로 Transaction 종료
COMMIT;     --영구반영(cmd에서 확인 가능)
SELECT * FROM t_test;




