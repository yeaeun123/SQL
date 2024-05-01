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







