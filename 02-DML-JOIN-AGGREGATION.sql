-------------------
-- JOIN
-------------------

--employees와 departments
DESC employees;
DESC departments;

SELECT * FROM employees; --107레코드
SELECT * FROM departments; --27레코드

SELECT * 
FROM employees, departments; --2000개 이상의 레코드 출력
-- 카티전 프로덕트 (이 방법은 안씀), Cross Join

SELECT *
FROM employees, departments
WHERE employees.department_id = departments.department_id; --106레코드
--INNER JOIN, EQUI-JOIN(=) : Join조건을 만족하는 튜플만 나타남
-- "Table1.속성명(PK)" = "Table2.속성명(FK)" 동등조인
-- 보통 FROM에서 테이블명 별칭 붙인다.

-------------------
-- Simple Join or Equi-Join
-------------------
-- alias를 이용한 원하는 필드의 projection

/*employees와 departments를 department_id를 기준으로 Join 하여
first_name, department_id, department_name을 출력해 봅시다*/
SELECT first_name, 
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id; 
--106개 department_id가  null인 직원은 JOIN에서 배제

SELECT * FROM employees
WHERE department_id IS NULL; 

SELECT emp.first_name,
    dept.department_name
FROM employees emp JOIN departments dept USING (department_id);

