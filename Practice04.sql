/*서브쿼리(SUBQUERY) SQL 문제입니다.
문제1.
평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하시요.
(56건)*/

SELECT COUNT(salary)
FROM employees 
WHERE salary < (SELECT AVG(salary) FROM employees);
---------------------------------
--답안
SELECT COUNT(*)
FROM employees 
WHERE salary < (SELECT AVG(salary) FROM employees);

/*문제2.
평균급여 이상, 최대급여 이하의 월급을 받는 사원의
직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를 급여의 오름차
순으로 정렬하여 출력하세요
(51건)*/

SELECT employee_id 직원번호, first_name 이름,
    salary 급여, (SELECT(ROUND(AVG(salary),2)) FROM employees) 평균급여,
    MAX(salary) OVER() 최대급여
FROM employees 
WHERE salary >= (SELECT AVG(salary) FROM employees) AND
        salary <= (SELECT MAX(salary) FROM employees)
ORDER BY salary ASC;
---------------------------------
--답안 (연관쿼리)
SELECT emp.employee_id, emp.first_name, emp.salary, 
    t.avgSalary, t.maxSalary
FROM employees emp 
    JOIN (SELECT ROUND(AVG(salary)) avgSalary, MAX(salary) maxSalary 
            FROM employees) t
    ON emp.salary  BETWEEN t.avgSalary AND t.maxSalary
    ORDER BY salary;

/*문제3.
직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 주소
를 알아보려고 한다.
도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city), 주
(state_province), 나라아이디(country_id) 를 출력하세요*/

SELECT location_id 도시아이디, street_address 거리명, postal_code 우편번호, city 도시명, 
    state_province 주, country_id 나라아이디
FROM locations loc
WHERE loc.location_id = (SELECT dept.location_id
                        FROM departments dept
                        JOIN employees emp ON dept.department_id = emp.department_id
                        WHERE emp.first_name = 'Steven' AND emp.last_name = 'King');
                        
---------------------------------
--답안1.(서브쿼리연습을 위해 서브쿼리로 풀기) 
SELECT location_id, street_address, postal_code, city, state_province, country_id
FROM locations
WHERE location_id = (SELECT location_id FROM departments 
                        WHERE department_id = (SELECT department_id FROM employees
                                                WHERE first_name = 'Steven' AND
                                                    last_name = 'King'));
---------------------------------
--답안2. NATURAL JOIN으로 풀어보기
SELECT location_id, street_address, postal_code, city, state_province, country_id
FROM locations
    NATURAL JOIN departments    -- location_id로 join
    JOIN employees ON employees.department_id = departments.department_id
WHERE first_name = 'Steven' AND last_name = 'King';

/*문제4.
job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로
출력하세요 -ANY연산자 사용
(74건)*/

SELECT employee_id 사번, first_name 이름, salary 급여
FROM employees
WHERE salary < ANY(SELECT salary FROM employees WHERE job_id = 'ST_MAN')
ORDER BY salary DESC;
---------------------------------
--답안 (ANY연산자 OR과 같음)
SELECT employee_id, first_name, salary
FROM employees
WHERE salary < ANY(SELECT salary FROM employees 
                    WHERE job_id = 'ST_MAN')
ORDER BY salary DESC;


/*문제5.
각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name)과 급여
(salary) 부서번호(department_id)를 조회하세요
단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다.
조건절비교, 테이블조인 2가지 방법으로 작성하세요
(11건)*/
-- 5-1 테이블조인
SELECT emp.employee_id 직원번호, emp.first_name 이름, emp.salary 급여, emp.department_id 부서번호
FROM employees emp 
                    JOIN (SELECT department_id, MAX(salary) salary
                        FROM employees
                        GROUP BY department_id) max_salary 
                        ON emp.department_id = max_salary.department_id 
                        AND emp.salary =  max_salary.salary
ORDER BY emp.salary DESC;

--5-2 조건절비교
SELECT employee_id 직원번호, first_name 이름, salary 급여, department_id 부서번호
FROM employees emp 
WHERE (department_id, salary) 
        IN (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id)
ORDER BY salary DESC;

---------------------------------
--답안 5-1. 테이블조인
SELECT emp.employee_id, emp.first_name, emp.salary, emp.department_id
FROM employees emp
    JOIN 
        (SELECT department_id, MAX(salary) salary 
            FROM employees
            GROUP BY department_id) t
    ON emp.department_id = t.department_id
WHERE emp.salary = t.salary
ORDER BY emp.salary DESC;

---------------------------------
--답안 5-2. 조건절비교
SELECT emp.employee_id, emp.first_name, emp.salary, emp.department_id
FROM employees emp
WHERE (emp.department_id, emp.salary) IN (SELECT department_id, MAX(salary)
                                            FROM employees
                                            GROUP BY department_id)
ORDER BY salary DESC;

-- 부서별 최고급여 쿼리
--SELECT department_id, MAX(salary) FROM employees
--GROUP BY department_id;




/*문제6.
각 업무(job) 별로 급여(salary)의 총합을 구하고자 합니다.
연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
(19건)*/
--6-1 INNER JOIN
SELECT j.job_title 업무, SUM(emp.salary) 급여총합 
FROM jobs j
INNER JOIN employees emp ON j.job_id = emp.job_id
GROUP BY j.job_title
ORDER BY SUM(emp.salary) DESC;

--6-2 서브쿼리
SELECT job_title 업무, (SELECT SUM(salary)   
                    FROM employees
                    WHERE employees.job_id = jobs.job_id) 급여총합
FROM jobs
ORDER BY 급여총합 DESC;

---------------------------------
--답안 
SELECT j.job_title, t.sumSalary, j.job_id, t.job_id
FROM jobs j
    JOIN (SELECT job_id, SUM(salary) sumSalary
            FROM employees 
            GROUP BY job_id) t
    ON j.job_id = t.job_id
ORDER BY sumSalary DESC;


/*문제7.
자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 이름
(first_name)과 급여(salary)을 조회하세요
(38건)*/

SELECT employee_id 직원번호, first_name 이름, salary 급여
FROM employees outer
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = outer.department_id)
ORDER BY salary;

---------------------------------
--답안 (JOIN 써보기)
SELECT emp.employee_id, emp.first_name, emp.salary
FROM employees emp
    JOIN 
    (SELECT department_id, AVG(salary) salary
        FROM employees
        GROUP BY department_id) t
    ON emp.department_id = t.department_id
WHERE emp.salary > t.salary
ORDER BY salary;


/* 문제8.
직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력
하세요*/

SELECT *    --아래 from절에서 불러온 모든 데이터 표기 
FROM (SELECT row_number() OVER (ORDER BY hire_date) rnum,
        employee_id 사번, first_name 이름, salary 급여, hire_date 입사일
        FROM employees)
WHERE rnum BETWEEN 11 AND 15;
        
---------------------------------
--답안1.ROW_NUMBER함수 사용
SELECT  employee_id, first_name, salary, hire_date
FROM
    (SELECT rownum rn, employee_id, first_name, salary, hire_date
      FROM
      (SELECT employee_id, first_name, salary, hire_date 
        FROM employees
        ORDER BY hire_date)
        )
WHERE rn >= 11 AND rn <= 15;
---------------------------------
SELECT rnum, employee_id, first_name, salary, hire_date
FROM
    (SELECT employee_id, first_name, salary, hire_date,
            ROW_NUMBER() OVER (ORDER BY hire_date) AS rnum
    FROM employees)
WHERE rnum >= 11 AND rnum <= 15;
---------------------------------
--답안2.RANK 함수 사용
SELECT employee_id, first_name, salary, hire_date, rank
FROM (SELECT employee_id, first_name, salary, hire_date,
        RANK() OVER (ORDER BY hire_date ASC) AS rank
        FROM employees) 
WHERE rank BETWEEN 11 AND 15;







