/*혼합 SQL 문제입니다.

문제1.
담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의
이름, 매니저 아이디, 커미션 비율, 월급을 출력하세요.
(45건)*/
SELECT first_name, manager_id, commission_pct, salary
FROM employees 
WHERE manager_id IS NOT NULL AND commission_pct IS NULL AND salary > 3000
ORDER BY salary DESC;

/*문제2.
각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name), 급여
(salary), 입사일(hire_date), 전화번호(phone_number), 부서번호(department_id)를 조회하세
요
-조건절 비교 방법으로 작성하세요
-급여의 내림차순으로 정렬하세요
-입사일은 2001-01-13 토요일 형식으로 출력합니다.
-전화번호는 515-123-4567 형식으로 출력합니다.
(11건)*/
SELECT employee_id 직원번호, first_name 이름, salary 급여, 
        TO_CHAR(hire_date, 'YYYY-MM-DD Day') 입사일,
        SUBSTR(REPLACE(phone_number, '.','-'),3) 전화번호, 
        department_id 부서번호
FROM employees 
WHERE (department_id, salary) IN 
                        (SELECT department_id, MAX(salary) 
                            FROM employees GROUP BY department_id)
ORDER BY salary DESC;

/*문제3
매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-통계대상(직원)은 2015년 이후의 입사자 입니다.
-매니저별 평균급여가 5000이상만 출력합니다.
-매니저별 평균급여의 내림차순으로 출력합니다.
-매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
-출력내용은 매니저 아이디, 매니저이름(first_name), 매니저별 평균급여, 매니저별 최소급여,
매니저별 최대급여 입니다.
(9건)*/











