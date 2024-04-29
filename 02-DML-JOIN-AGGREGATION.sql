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

---------------------
-- Theta Join (세타조인)
---------------------

-- Join 조건이 ( = )가 아닌 다른 조건들

-- 급여가 직군 평균 급여보다 낮은 직원들의 목록
SELECT  
    emp.employee_id,
    emp.first_name,
    emp.salary,
    emp.job_id,
    j.job_id,
    j.job_title
FROM
    employees emp
    JOIN jobs j
        ON emp.job_id = j.job_id
WHERE emp.salary <= (j.min_salary + j.max_salary ) / 2;



--------------------------
--OUTER JOIN
--------------------------
-- 조건을 만족하는 짝이 없는  튜플도 NULL을 포함하여 결과 출력 참여시키는 방법
-- 모든 결과를 표현한 테이블이 어느 쪽에 위치하는거에 따라 LEFT, RIGHT,FULL OUTER JOIN으로 구분
-- ORACLE SQL의 경우 NULL이 출력되는 쪽에 (+)를 붙인다.

-------------------
--LEFT OUTER JOIN
-------------------
-- LEFT 테이블의 모든 레코드가 출력 결과에 참여
-- Oracle SQL
SELECT emp.first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id(+); 
-- null이 포함된 테이블 쪽에 (+) 표기

SELECT * FROM employees WHERE department_id IS NULL;    
--Kimberly ->부서에 소속되지 않음


-- ANSI SQL :명시적으로 JOIN 방법을 정한다.
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp 
     LEFT OUTER JOIN departments dept
        ON emp.department_id = dept.department_id;

-------------------
-- RIGHT OUTER JOIN
-------------------
-- RIGHT 테이블의 모든 레코드가 출력 결과에 참여

--Oracle SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id; 
-- departments 테이블 레코드 전부를 출력에 참여시키기 / 총 122 레코드 출력

-- ANSI SQL(표준)
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp
    RIGHT OUTER JOIN departments dept
        ON emp.department_id = dept.department_id;
-- null값을 포함해서 총 122 레코드 출력

-------------------
-- FULL OUTER JOIN
-------------------
-- JOIN에 참여한 모든 테이블의 모든 레코드를 출력에 참여시킨다.
-- 짝이 없는 레코드들은 NULL을 포함해서 출력에 참여시킨다.
-- Oracle엔 없고 ANSI SQL로만 실행 가능하다.

-- ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp 
    FULL OUTER JOIN departments dept
        ON emp.department_id = dept.department_id;
-- null값을 포함해서 총 123 레코드 출력


-------------------
-- NATURAL JOIN
-------------------
-- 조인할 테이블에 같은 이름의 컬럼이 있을 경우, 해당 컬럼을 기준으로 JOIN
-- 실제 본인이 JOIN할 조건과 일치하는지 확인 ! 

SELECT * FROM employees emp NATURAL JOIN departments dept;

--아래 두 줄과 같이 실수 할 여지가 많음 /조심해야함 
--SELECT *  FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id;
--SELECT *  FROM employees emp JOIN departments dept ON emp.manager_id = dept.manager_id;

SELECT *  FROM employees emp 
    JOIN departments dept ON emp.manager_id = dept.manager_id 
    AND emp.department_id = dept.department_id;

-------------------
-- SELF JOIN
-------------------
-- 자기 자신과 JOIN
-- 자신을 두번 호출-> 별칭을 반드시 부여해야함!

SELECT * FROM employees; --107명

SELECT 
    emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp JOIN employees man 
    ON emp.manager_id = man.employee_id; --106
    
SELECT 
    emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id; --106

-- Steven(매니저 없는 사람) 까지 포함해서 출력
SELECT 
    emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp RIGHT OUTER JOIN employees man 
    ON emp.manager_id = man.employee_id;