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
SELECT DISTINCT  *
FROM(
SELECT m.manager_id, m.first_name, 
    ROUND(AVG(m.salary) OVER (ORDER BY m.salary)) 평균급여,
    MIN(m.salary) OVER (ORDER BY m.salary) 최소급여, 
    MAX(m.salary) OVER (ORDER BY m.salary) 최대급여
FROM employees emp JOIN employees m
            ON emp.manager_id = m.employee_id
        WHERE m.hire_date >= TO_DATE('15/01/01', 'YY-MM-DD')
        )
WHERE 평균급여 >= 5000
ORDER BY 평균급여 DESC;
/*
employees 테이블을 자기 자신과 조인합니다. 이를 통해 직원과 해당 직원의 매니저를 결합합니다.
조인된 결과를 기준으로 매니저별로 평균 급여를 계산합니다. 이를 위해 윈도우 함수인 AVG(m.salary) OVER (ORDER BY m.salary)를 사용하여 매니저별 평균 급여를 계산합니다. 이 때, ORDER BY m.salary를 사용하여 매니저별 평균 급여를 계산할 때 정렬 순서를 결정합니다.
각 매니저별로 최소 급여와 최대 급여를 계산합니다. 이를 위해 MIN(m.salary) OVER (ORDER BY m.salary)와 MAX(m.salary) OVER (ORDER BY m.salary)를 사용합니다. 마찬가지로 ORDER BY m.salary를 사용하여 정렬 순서를 결정합니다.
서브쿼리 결과를 기준으로 평균 급여가 5000 이상인 데이터만 선택합니다. 이를 위해 외부 쿼리에서 WHERE 평균급여 >= 5000 조건을 사용합니다.
최종적으로 선택된 데이터에는 매니저의 아이디(manager_id), 이름(first_name), 평균 급여(평균급여), 최소 급여(최소급여), 최대 급여(최대급여)가 포함됩니다.
DISTINCT 키워드를 사용하여 중복된 행을 제거합니다.
결과는 평균 급여를 내림차순으로 정렬하여 반환합니다.*/



/*문제4.
각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
부서가 없는 직원(Kimberely)도 표시합니다.
(106명)*/
SELECT emp.employee_id 사번, emp.first_name 이름, 
        dept.department_name 부서명, m.first_name 매니저이름
FROM employees emp 
    RIGHT OUTER JOIN employees m 
                        ON m.manager_id = emp.employee_id
        JOIN departments dept
                        ON m.department_id = dept.department_id;

/*문제5.
2015년 이후 입사한 직원 중에 입사일이 11번째에서 20번째의 직원의
사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요*/
SELECT *
FROM (SELECT row_number() OVER(ORDER BY hire_date) rnum,
        e.employee_id, e.first_name, 
        d.department_name, e.salary, e.hire_date 
        FROM employees e JOIN departments d 
                    ON e.department_id= d.department_id
        WHERE e.hire_date >= TO_DATE('15/01/01','YY-MM-DD')
        )
WHERE rnum BETWEEN 11 AND 20;

/*문제6.
가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름
(department_name)은?(2명)*/
SELECT e.first_name||' '||e.last_name 이름,
        e.salary*12 연봉,
        d.department_name 부서명
FROM employees e JOIN departments d 
                ON e.department_id = d.department_id
WHERE e.hire_date = (SELECT MAX(hire_date) FROM employees);

/*문제7.
평균급여(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name), 성
(last_name)과 업무(job_title), 급여(salary)을 조회하시오.*/

SELECT employee_id 직원번호, first_name 이름, last_name 성, job_title 업무,
        salary 급여, AVG(salary) OVER (ORDER BY department_id) 평균급여
FROM employees JOIN jobs USING (job_id)
WHERE department_id = (SELECT department_id 
                        FROM (SELECT department_id 
                                FROM employees
                                GROUP BY department_id 
                                ORDER BY AVG(salary)DESC)
                        WHERE ROWNUM = 1);
/*
employees 테이블과 jobs 테이블을 조인합니다. 
이를 통해 직원의 정보와 직무(업무) 정보를 결합합니다.
AVG(salary) OVER (ORDER BY department_id)를 사용하여 각 부서별 평균 급여를 계산합니다.
이는 윈도우 함수인 OVER를 사용하여 전체 결과 집합을 부서별로 정렬한 후에 각 부서별로 평균 급여를 계산합니다.
WHERE department_id = (SELECT department_id 
FROM 
(SELECT department_id
FROM employees 
GROUP BY department_id 
ORDER BY AVG(salary) DESC)
WHERE ROWNUM = 1) 조건을 사용하여 부서별 평균 급여가 가장 높은 부서의 직원만 선택합니다.
먼저, 서브쿼리 (SELECT department_id 
FROM employees GROUP BY department_id ORDER BY AVG(salary) DESC)를 사용하여 
각 부서별로 평균 급여를 계산하고 내림차순으로 정렬합니다.
그 다음 WHERE ROWNUM = 1을 사용하여 가장 높은 평균 급여를 가진 첫 번째 부서의 department_id를 선택합니다.
최종적으로 외부 쿼리에서는 선택된 부서에 속한 직원들의 정보를 가져옵니다.
선택된 부서에 속한 직원들의 직원번호(employee_id), 이름(first_name), 성(last_name),
업무(job_title), 급여(salary), 그리고 부서별 평균 급여(평균급여)를 반환합니다.
이러한 쿼리를 실행하면 부서별 평균 급여가 가장 높은 부서에 속한 직원들의 정보를 조회할 수 있습니다.

*/


/*문제8.
평균 급여(salary)가 가장 높은 부서는?*/

SELECT  department_name
FROM(
    SELECT department_id, avg_sal,
         row_number() OVER (ORDER BY avg_sal DESC) max_sal
    FROM
      (SELECT department_id, AVG(salary) avg_sal
         FROM employees 
        GROUP BY department_id)
        ) JOIN departments USING(department_id)
WHERE max_sal = 1;
/*먼저, employees 테이블에서 각 부서별 평균 급여를 계산합니다. 
이를 위해 AVG(salary) 함수를 사용하고 department_id로 그룹화합니다.
그런 다음, 이 내부 쿼리의 결과를 사용하여 각 부서의 평균 급여를 평균 급여의 내림차순으로 순위를 매깁니다. 
이는 row_number() OVER (ORDER BY avg_sal DESC)를 사용하여 수행됩니다.
row_number() 함수는 순위를 부여하는 데 사용되며, 여기서는 평균 급여를 기준으로 내림차순으로 정렬됩니다.
그런 다음, 이러한 결과를 다시 departments 테이블과 조인하여 각 부서의 이름을 가져옵니다. 
이 때 JOIN ... USING을 사용하여 department_id 열을 기준으로 조인합니다.
마지막으로, 부서별 평균 급여를 기준으로 가장 높은 순위에 있는 부서를 찾기 위해
max_sal = 1 조건을 사용하여 결과를 필터링합니다.*/

/*문제9.
평균 급여(salary)가 가장 높은 지역은?*/
SELECT region_name
FROM (SELECT region_name, avg_sal,
         row_number() OVER (ORDER BY avg_sal DESC) max_sal
    FROM
      (SELECT region_name, AVG(salary) avg_sal
         FROM employees JOIN departments USING(department_id) 
                        JOIN locations USING(location_id)
                        JOIN countries USING(country_id) 
                        JOIN regions USING(region_id)
        GROUP BY region_name)
        )
WHERE max_sal = 1;

/*문제10.
평균 급여(salary)가 가장 높은 업무는?*/
SELECT job_title
FROM (SELECT job_title, avg_sal,
            row_number() OVER (ORDER BY avg_sal DESC) max_sal
      FROM
            (SELECT job_title, AVG(salary) avg_sal
                FROM employees JOIN jobs USING(job_id) 
                GROUP BY job_title)
                )
WHERE max_sal = 1;



