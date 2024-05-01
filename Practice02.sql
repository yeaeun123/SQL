/*집계(통계) SQL 문제입니다.
문제1.
매니저가 있는 직원은 몇 명입니까? 아래의 결과가 나오도록 쿼리문을 작성하세요(106)*/
SELECT COUNT(manager_id) "haveMngCnt" FROM employees; 

-- COUNT(*) -> 전체레코드수 
-- COUNT(필드명) -> NULL이 아닌 레코드
SELECT COUNT(manager_id) "haveMngCnt" FROM employees
WHERE manager_id IS NOT NULL; -- 좀 더 명확하게 하기위함 /안해도됨



/*문제2.
직원중에 최고임금(salary)과 최저임금을 “최고임금, “최저임금”프로젝션 타이틀로 함께 출력
해 보세요. 두 임금의 차이는 얼마인가요? “최고임금 – 최저임금”이란 타이틀로 함께 출력
해 보세요.*/

SELECT 
    MAX(salary) 최고임금, 
    MIN(salary) 최저임금, 
    MAX(salary) - MIN(salary) "최고임금-최저임금" -- 특수문자 포함 " "로 쓰기
FROM employees;    


/*문제3.
마지막으로 신입사원이 들어온 날은 언제 입니까? 다음 형식으로 출력해주세요.
예) 2014년 07월 10일*/
SELECT
    TO_CHAR(MAX(hire_date), 'YYYY"년" MM"월" DD"일"') as "신입사원 입사일"
FROM employees;


/*문제4.
부서별로 평균임금, 최고임금, 최저임금을 부서아이디(department_id)와 함께 출력합니다.
정렬순서는 부서번호(department_id) 내림차순입니다.*/ --그룹과 집계

--SELECT에는 GROUP BY참여필드 + 집계함수만 올 수 있다.
SELECT department_id 부서번호, ROUND(AVG(salary), 2) 평균임금,
    MAX(salary) 최고임금, 
    MIN(salary) 최저임금
FROM employees
GROUP BY department_id
ORDER BY department_id DESC;

/*문제5
업무(job_id)별로 평균임금, 최고임금, 최저임금을 업무아이디(job_id)와 함께 출력하고 정렬
순서는 최저임금 내림차순, 평균임금(소수점 반올림), 오름차순 순입니다.
(정렬순서는 최소임금 2500 구간일때 확인해볼 것)*/
SELECT 
    job_id,
    ROUND(AVG(salary)) 평균임금, 
    MAX(salary) 최고임금, 
    MIN(salary) 최저임금
FROM employees
GROUP BY job_id     --job_id기준으로 그룹핑
ORDER BY MIN(salary) DESC, AVG(salary) ASC;
    
/*문제6.
가장 오래 근속한 직원의 입사일은 언제인가요? 다음 형식으로 출력해주세요.
예) 2001-01-13 토요일*/
SELECT TO_CHAR(MIN(hire_date), 'YYYY-MM-DD Day')
FROM employees;

/*문제7.
평균임금과 최저임금의 차이가 2000 미만인 부서(department_id), 평균임금, 최저임금 그리
고 (평균임금 – 최저임금)를 (평균임금 – 최저임금)의 내림차순으로 정렬해서 출력하세요.*/

-- 부서별 그룹핑 / having절 
    -- 집계함수 이후의 조건 점검은 반드시 HAVING절에서 해야함 !!!
SELECT
    department_id 부서, 
    ROUND(AVG(salary)) 평균임금, 
    MIN(salary) 최저임금,
    ROUND(AVG(salary)-MIN(salary)) as "평균임금-최저임금"
FROM employees
GROUP BY department_id
    HAVING AVG(salary) - MIN(salary)  < 2000
ORDER BY AVG(salary)-MIN(salary) DESC;

/*문제8.
업무(JOBS)별로 최고임금과 최저임금의 차이를 출력해보세요.
차이를 확인할 수 있도록 내림차순으로 정렬하세요?*/
--8-1 .jobs테이블로 풀이
SELECT job_title 업무,  max_salary - min_salary "최고임금-최저임금"
FROM jobs
ORDER BY max_salary-min_salary DESC;
----------------------------------------
-- 8-2. employees테이블 풀이(집계관련 풀이)
SELECT 
    job_id, 
    MAX(salary) - MIN(salary) diff
FROM employees
GROUP BY job_id
ORDER BY  diff DESC;


/*문제9
2015년 이후 입사자중 관리자별로 평균급여 최소급여 최대급여를 알아보려고 한다.
출력은 관리자별로 평균급여가 5000이상 중에 평균급여 최소급여 최대급여를 출력합니다.
평균급여의 내림차순으로 정렬하고 평균급여는 소수점 첫째짜리에서 반올림 하여 출력합니다.*/

SELECT manager_id 관리자, 
    ROUND(AVG(salary),1) 평균급여 , 
    MIN(salary) 최소급여, 
    MAX(salary) 최대급여
FROM employees
WHERE hire_date >= '15/01/01'   --집계 함수 실행 이전의 조건 처리(2015년 이후 입사자)
    GROUP BY manager_id
    HAVING AVG(salary) >= 5000  -- 집계 함수 실행 이후 조건 처리 (평균급여가 5000이상)
ORDER BY AVG(salary) DESC;

/*문제10
아래회사는 보너스 지급을 위해 직원을 입사일 기준으로 나눌려고 합니다.
입사일이 12/12/31일 이전이면 '창립맴버, 13년은 '13년입사’, 14년은 ‘14년입사’
이후입사자는 ‘상장이후입사’ optDate 컬럼의 데이터로 출력하세요.
정렬은 입사일로 오름차순으로 정렬합니다.*/
--풀이1
SELECT employee_id, salary, first_name, hire_date,
    CASE    --입사일 기준 구분
        WHEN hire_date <= TO_DATE('12/12/31', 'RR-MM-DD') THEN '창립멤버'
        WHEN hire_date <= TO_DATE('13/12/31', 'RR-MM-DD') THEN '13년입사'
        WHEN hire_date <= TO_DATE('14/12/31', 'RR-MM-DD') THEN '14년입사'
        ELSE '상장이후입사'
    END optDate
FROM employees
ORDER BY hire_date ASC;

--풀이2
SELECT employee_id, salary, 
    CASE WHEN hire_date <= '12/12/31' THEN '창립멤버'
        WHEN hire_date >= '13/01/01' AND hire_date <= '13/12/31' THEN '13년입사'
        WHEN hire_date >= '14/01/01' AND hire_date <= '14/12/31' THEN '14년입사'
        ELSE '상장이후입사'
        END optDate,
        hire_date
FROM employees
ORDER BY hire_date ASC;

