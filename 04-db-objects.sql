---------------------------------
-- DB OBJECTS
---------------------------------
--VIEW
-- SYSTEM계정으로 진행
-- VIEW 생성을 위한 SYSTEM 권한
GRANT create view TO himedia;

GRANT select ON HR.employees TO himedia;
GRANT select ON HR.departments TO himedia;

--himedia계정으로 진행
-- SIMPLE VIEW
-- 단일 테이블 혹은 단일 뷰를 베이스로 한 함수, 연산식을 포함하지 않은 뷰

--emp123 테이블확인 (10,20,30번부서)
DESC emp123;

-- emp123 테이블 기반으로 department_id = 10 부서 소속 사원만 조회하는 뷰
CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp123
        WHERE department_id = 10;

SELECT * FROM tabs; -- 테이블 목록확인
--일반 테이블처럼 활용 가능
DESC emp10; --view도 이름/널/유형 확인가능

SELECT * FROM emp10;
SELECT first_name||' '||last_name, salary FROM emp10;

-- SIMPLE VIEW 는 제약 사항에 걸리지 않는다면 INSERT, UPDATE, DELETE를 할 수 있다.
UPDATE emp10 SET salary= salary * 2;
SELECT * FROM emp10;
ROLLBACK;

-- 가급적 VIEW는 조회용으로만 활용하자 
-- WITH READ ONLY : 읽기 전용 뷰
CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp123
        WHERE department_id = 10
    WITH READ ONLY;

UPDATE emp10 SET salary = salary *2; -- 읽기전용 뷰에서는 DML작업 수행불가 

-- Complex View
-- 한 개 혹은 여러 개의 테이블 혹은 뷰에 JOIN, 함수, 연산식 등을 활용한 VIEW
-- 특별한 경우가 아니면 INSERT, UPDATE, DELETE 작업 수행 불가! 
CREATE OR REPLACE VIEW emp_detail (employee_id, employee_name, 
                                        manager_name, department_name)
    AS SELECT emp.employee_id, 
            emp.first_name ||' '|| emp.last_name, 
            man.first_name ||' '|| man.last_name,
            department_name
    FROM hr.employees emp 
        JOIN hr.employees man ON emp.manager_id = man.employee_id
        JOIN hr.departments dept ON emp.department_id = dept.department_id;

DESC emp_detail;

SELECT * FROM emp_detail;

-- VIEW 를 위한 딕셔너리 : VIEWS
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_OBJECTS;     -- 모든 DB객체들의 정보(뷰,TABLE, INDEX)

-- VIEW 삭제 : DROP VIEW
-- VIEW 삭제해도 기반 테이블의 데이터는 삭제되지 않음 
DROP VIEW emp_detail;

SELECT * FROM USER_VIEWS;

-------------------------
--INDEX
-- 데이터에 대한 조회 속도를 높이기 위해 만든다.



