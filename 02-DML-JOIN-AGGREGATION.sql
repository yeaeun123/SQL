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
    

--------------------------
--Group Aggregation
--------------------------

-- 집계 : 여러 행으로부터 데이터를 수집, 하나의 행으로 반환

-- COUNT : 갯수 세기 함수
-- employees 테이블의 총 레코드 갯수?
SELECT COUNT (*) FROM employees; --107레코드(null포함)

-- * 로 카운트하면 모든 행의 수를 반환 (null포함)
-- 특정 컬럼 내에 null값이 포함되어 있는지의 여부는 중요하지 않음

-- commission을 받는 직원의 수 ? 
-- commission_pct가 null인 경우를 제외하ㅏ고 싶을 경우
SELECT COUNT(commission_pct) FROM employees;    --35
-- 컬럼 내에 포함된 null 데이터를 카운트하지 않음

-- 위 쿼리는 아래 쿼리와 같다.
SELECT COUNT(*) FROM employees
WHERE commission_pct IS NOT NULL;

-- SUM : 합계 함수
-- 모든 사원의 급여 합계?
SELECT SUM(salary) FROM employees;

-- AVG : 평균 함수
-- 사원들의 평균 급여?
SELECT AVG(salary) FROM employees;

-- 사원들이 받는 평균 커미션비율?
SELECT AVG(commission_pct) FROM employees;  --22%
-- AVG 함수는 NULL 값이 포함되어 있을 경우 그 값을 집계 수치에서 제외 ! 
-- NULL 값을 집계 결과에 포함시킬지의 여부는 정책으로 결정하고 수행해야 한다.
SELECT AVG(NVL(commission_pct, 0)) FROM employees;  --7%

-- MIN / MAX : 최소값/ 최대값
-- AVG / MEDIAN : 산술 평균 / 중앙 값 
SELECT 
    MIN(salary) 최소급여,
    MAX(salary) 최대급여,
    AVG(salary) 평균급여,
    MEDIAN(salary) 급여중앙값
FROM employees;


-- 흔히 범하는 오류
-- 부서별로 평균 급여를 구하고자 할 때? GROUP BY 이용~! 
SELECT department_id, AVG(salary)   --오류! 
FROM employees;

SELECT department_id FROM employees; -- 여러개의 레코드(행)
SELECT AVG(salary) FROM employees;  -- 단일 레코드(행)

SELECT department_id, salary
FROM employees
ORDER BY department_id;

-- GROUP BY
SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id      -- 집계를 위해 특정 컬럼을 기준으로 그룹핑
ORDER BY department_id;

-- 부서별 평균 급여에 부서명도 함께 출력?
SELECT emp.department_id, dept.department_name, ROUND(AVG(emp.salary), 2)
FROM employees emp 
    JOIN departments dept 
        ON emp.department_id = dept.department_id
GROUP BY emp.department_id, dept.department_name
ORDER BY emp.department_id;

-- GROUP BY절 이후에는 GROUP BY에 참여한 컬럼과 집계 함수만 남는다.

-- 평균 급여가 7000달러 이상인 부서만 출력?
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 7000       -- 아직 집계 함수 시행되지 않은 상태 -> 집계함수의 비교 불가
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수 이후의 조건 비교 HAVING 절을 이용
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
    HAVING AVG(salary) >= 7000  -- GROUP BY aggregation의 조건 필터링
ORDER BY department_id;

/*급여(salary) 합계가 20000 이상인 부서의 부서 번호와 인원 수, 급여 합계를 출력하기
위해 다음과 같은 쿼리를 작성했다.*/
SELECT department_id, COUNT(*), SUM(salary)
FROM employees
GROUP BY department_id
    HAVING SUM(salary) > 20000;
    
/* 단일 SQP작성법
1. 최종 출력될 정보에 따라 원하는 컬럼을 SELECT 절에 추가
2. 원하는 정보를 가진 테이블들을 FROM 절에 추가
3. WHERE 절에 알맞은 JOIN 조건 추가
4. WHERE 절에 알맞은 검색 조건 추가(SELECTION)
5. 필요에 따라 GROUP BY, HAVING 등을 통해 Grouping하고 Aggregate
6. 정렬 조건 ORDER BY에 추가*/


-- ROLLUP
-- GROUP BY 절과 함께 사용
-- 그룹지어진 결과에 대한 좀 더 상세한 요약을 제공하는 기능 수행
-- 일종의 Item Total
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

-- CUBE
-- GROUP BY 절과 함께 사용
-- CrossTab에 대한 Summary를 함께 추출하는 함수
-- ROLLUP 함수에 의해 출력되는 Item Total 값과 함께
-- Column Total 값을 함께 추출
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

-------------------------
-- SUBQUERY 
-------------------------
-- Single-Row Subquery
-- Subquery의 결과가 한 ROW인 경우
-- Single-Row Operator를 사용해야 함: =, >, >=, <, <=, <>

-- 모든 직원 급여의 중앙값보다 많은 급여를 받는 사원? 

-- 1) 직원 급여의 중앙값? 
-- 2) 1)번의 결과보다 많은 급여를 받는 직원의 목록?

-- 1) 직원 급여의 중앙값
SELECT MEDIAN(salary) FROM employees;   -- 6200
-- 2) 1)번의 결과(6200)보다 많은 급여를 받는 직원의 목록?
SELECT first_name, salary
FROM employees
WHERE salary >= 6200;

-- 1),2)쿼리 합치기
SELECT first_name, salary
FROM employees
WHERE salary >= (SELECT MEDIAN(salary) FROM employees)
ORDER BY salary DESC;

-- Susan보다 늦게 입사한 사원의 정보?
-- 1) Susan의 입사일
-- 2) 1)번의 결과보다 늦게 입사한 사원의 정보 추출

-- 1) Susan의 입사일
SELECT hire_date FROM employees
WHERE first_name = 'Susan';     --12/06/07

-- 2) 1)번의 결과보다 늦게 입사한 직원 목록
SELECT first_name, hire_date
FROM employees
WHERE hire_date > '12/06/07';

-- 1),2) 쿼리 합치기
SELECT first_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date FROM employees WHERE first_name = 'Susan')
ORDER BY hire_date;

-- 연습문제
-- 모든 직원 급여의 중앙 값보다 급여를 많이 받으면서 수잔보다 늦게 입사한 직원 목록?
-- 조건1. 모든 직원 급여의 중앙 값보다 급여를 많이 받는다.
-- 조건2. 수잔의 입사일보다 hire_date 늦게 입사한 직원
SELECT first_name, salary, hire_date
FROM employees
WHERE salary >= (SELECT MEDIAN(salary) FROM employees) AND  -- 조건1
    hire_date > (SELECT hire_date FROM employees WHERE first_name = 'Susan') --조건2
ORDER BY hire_date ASC, salary DESC;







    