/*테이블간 조인(JOIN) SQL 문제입니다.
문제1.
직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세
요.
(106건)*/

SELECT emp.employee_id, emp.first_name, emp.last_name, dept.department_name
FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id
ORDER BY department_name ASC, employee_id DESC;


/*문제2.
employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현
재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.(106건)*/

SELECT emp.employee_id, emp.first_name, emp.salary, dept.department_name, job.job_title
FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id 
        JOIN jobs job ON emp.job_id = job.job_id
ORDER BY employee_id ASC;

/*문제2-1.
문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요
(107건)*/
SELECT emp.employee_id, emp.first_name, emp.salary, dept.department_name, job.job_title
FROM employees emp 
      LEFT OUTER JOIN departments dept ON emp.department_id = dept.department_id 
        JOIN jobs job ON emp.job_id = job.job_id
ORDER BY employee_id ASC;
    
/*문제3.
도시별로 위치한 부서들을 파악하려고 합니다.
도시아이디, 도시명, 부서명, 부서아이디를 도시아이디(오름차순)로 정렬하여 출력하세요
부서가 없는 도시는 표시하지 않습니다.
(27건)*/
SELECT loc.location_id, loc.city, dept.department_name, dept.department_id
FROM departments dept JOIN locations loc ON loc.location_id = dept.location_id
ORDER BY location_id ASC;

/*문제3-1.
문제3에서 부서가 없는 도시도 표시합니다.
(43건)*/
SELECT loc.location_id, loc.city, dept.department_name, dept.department_id
FROM departments dept 
    RIGHT OUTER JOIN locations loc ON loc.location_id = dept.location_id
ORDER BY location_id ASC;

/*문제4.
지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하
되 지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.
(25건)*/
SELECT reg.region_name, con.country_name
FROM regions reg JOIN countries con ON reg.region_id = con.region_id
ORDER BY region_name ASC, country_name DESC;

/*문제5.
자신의 매니저보다 채용일(hire_date)이 빠른 사원의
사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입
사일(hire_date)을 조회하세요.
(37건)*/
SELECT emp.employee_id, emp.first_name, emp.hire_date, man.first_name, man.hire_date
FROM employees emp JOIN employees man ON emp.manager_id = man.employee_id
WHERE emp.hire_date < man.hire_date;

/*문제6.
나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다.
나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 나라명(오름차순)로 정렬하여
출력하세요.
값이 없는 경우 표시하지 않습니다.
(27건)*/
SELECT con.country_name, con.country_id, loc.city, loc.location_id, dept.department_name, dept.department_id
FROM countries con JOIN locations loc ON con.country_id = loc.country_id 
    JOIN departments dept ON dept.location_id = loc.location_id
ORDER BY country_name;

/*문제7.
job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 사번, 이름(풀네임), 업무아이
디, 시작일, 종료일을 출력하세요.
이름은 first_name과 last_name을 합쳐 출력합니다.
(2건)*/
SELECT emp.employee_id, emp.first_name ||' '|| emp.last_name name, his.job_id,
    his.start_date, his.end_date
FROM employees emp JOIN job_history his ON emp.employee_id = his.employee_id
WHERE his.job_id = 'AC_ACCOUNT';

/*문제8.
각 부서(department)에 대해서 부서번호(department_id), 부서이름(department_name),
매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 나라(countries)의 이름
(countries_name) 그리고 지역구분(regions)의 이름(resion_name)까지 전부 출력해 보세요.
(11건)*/
SELECT dept.department_id, dept.department_name, man.first_name, 
    loc.city, con.country_name, reg.region_name
FROM employees man JOIN departments dept ON man.employee_id = dept.manager_id
    JOIN locations loc ON dept.location_id = loc.location_id
    JOIN countries con ON loc.country_id = con.country_id
    JOIN regions reg ON con.region_id = reg.region_id ;   


/*문제9.
각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
부서가 없는 직원(Kimberely)도 표시합니다.
(106명)*/
SELECT emp.employee_id, emp.first_name, dept.department_name, man.first_name
FROM employees man JOIN employees emp ON emp.employee_id = man.manager_id
    LEFT OUTER JOIN departments dept ON emp.employee_id = dept.manager_id;