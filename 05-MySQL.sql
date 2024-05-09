-- MYSQL은 사용자와 Database를 구분하는 DBMS
SHOW DATABASES;

-- 데이터베이스 사용 선언 ! 
USE sakila;

-- 데이터베이스 내에 어떤 테이블이 있는가?
SHOW TABLES;

-- 테이블 구조 확인
DESCRIBE actor;

-- 간단한 쿼리 실행
SELECT VERSION(), CURRENT_DATE;
SELECT VERSION(), CURRENT_DATE FROM dual; -- dual: 시스템 정보를 사용하는 가상테이블

-- 특정 테이블 데이터를 조회 alter
SELECT * FROM actor;

-- 데이터베이스 생성 
-- webdb 데이터베이스 생성
CREATE DATABASE webdb;
-- 시스템 설정에 좌우되는 경우가 많음
DROP DATABASE webdb;
-- 문자셋(CHARSET)과 정렬 방식(COLLATE)을 명시적으로 지정하는 것이 좋다.
CREATE DATABASE webdb CHARSET utf8mb4
	COLLATE utf8mb4_unicode_ci;
SHOW DATABASES;

-- 사용자 만들기
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
-- 사용자 비밀번호 변경
-- ALTER USER 'dev'@'localhost' IDENTIFIED BY 'new_password'; 
-- 사용자 삭제
-- DROP USER 'dev'@'localhost';

-- 권한 부여 
-- GRANT 권한 목록 ON 객체 TO '계정'@'접속호스트';
-- 권한 회수
-- REVOKE 권한 목록 ON 객체 FROM '계정'@'접속호스트';

-- 'dev'@'localhost'에게 webdb 데이터베이스의 모든 객체에 대한 모든 권한 허용 
-- (ALL PRIVILEGES-> SELECT,INSERT,UPDATE,DELETE)
-- GRANT ALL PRIVILEGES ON webdb.* TO 'dev'@'localhost';
-- REVOKE ALL PRIVILEGES ON webdb.* FROM 'dev'@'localhost';

-- 데이터베이스 확인
SHOW DATABASES;

USE webdb;

-- author 테이블 생성
CREATE TABLE author (
	author_id int PRIMARY KEY, 
    author_name VARCHAR(50) NOT NULL,
    author_desc VARCHAR(500) 
);
SHOW TABLES;
DESC author;

-- 테이블 생성 정보
SHOW CREATE TABLE author;

-- book 테이블 생성 
CREATE TABLE book (
	book_id int PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    pubs VARCHAR(100),
    pub_date DATETIME DEFAULT now(),
    author_id int,
    CONSTRAINT fk_book FOREIGN KEY (author_id)
    REFERENCES author(author_id)
);

SHOW TABLES;
DESC book;

-- INSERT : 새로운 레코드 삽입 
-- 묵시적 방법 : 컬럼 목록을 제공하지 않음 -> 선언된 컬럼의 순서대로 
INSERT INTO author VALUES (1, '박경리', '토지 작가');
-- 명시적 방법 : 컬럼 목록을 제공 -> 컬럼 목록의 숫자, 순서, 데이터타입이 
-- 값 목록의 숫자, 순서, 데이터타입과 일치해야 함
INSERT INTO author (author_id, author_name) 
VALUES (2, '김영하');

SELECT * FROM author;

-- MYSQL은 기본적으로 자동 커밋이 활성화 되어있다.
-- 만약 autocommit을 비활성화 하려면 ->autocommit 옵션을 0으로 설정
SET autocommit = 0;

-- MYSQL은 명시적 트랜잭션을 수행한다.
START transaction;
SELECT * FROM author;

-- UPDATE author 
-- SET author_desc = '알쓸신잡 출연';	-- WHERE절이 없으면 전체 레코드 변경됨! 

UPDATE author
SET author_desc = '알쓸신잡 출연'
WHERE author_id = 2;

SELECT * FROM author;
ROLLBACK;	-- 변경사항 반영 취소

COMMIT;		-- 변경사항 영구 반영

SELECT * FROM author;

-- AUTO_INCREMENT 속성 
-- 연속된 순차정보, 주로 PK 속성에 사용된다. 

-- author 테이블의 PK에 auto_increment 속성 부여
ALTER TABLE author MODIFY 
	author_id INT AUTO_INCREMENT PRIMARY KEY;	
		-- 오류! 연결된 book테이블의 FK먼저 지워야함
    
-- 1. 외래 키 정보 확인 
SELECT * 
FROM information_schema.KEY_COLUMN_USAGE;

SELECT constraint_name 
FROM information_schema.KEY_COLUMN_USAGE
WHERE table_name = 'book';

-- 2. 외래 키 삭제 : book 테이블의 FK(fk_book)
ALTER TABLE book DROP FOREIGN KEY fk_book;

-- 3. author의 PK에 AUTO_INCREMENT 속성 붙인다.
	-- 기존 PK 삭제 
ALTER TABLE author DROP PRIMARY KEY;

	-- AUTO_INCREMENT 속성이 부여된 새로운 PRIMARY KEY 생성
ALTER TABLE author MODIFY 
	author_id INT AUTO_INCREMENT PRIMARY KEY;
    
-- 4. book 의 author_id에 FOREIGN KEY 다시 연결하기
ALTER TABLE book 
ADD CONSTRAINT fk_book 
FOREIGN KEY (author_id) REFERENCES author(author_id);

-- autocommit 다시 켜줌 (자동으로 트랜잭션 됨)
SET autocommit = 1;

SELECT * FROM author; 	-- 레코드 확인 

-- 새로운 AUTO_INCREMENT 값을 부여하기 위해 PK의 최댓값을 구함
SELECT MAX(author_id) FROM author;

-- 새로 생성되는 AUTO_INCREMENT 시작 값을 변경
ALTER TABLE author AUTO_INCREMENT = 3; 	-- 3부터 시작함

-- 테이블 구조 확인 
DESCRIBE author;

INSERT INTO author (author_name) VALUES ('스티븐 킹');
INSERT INTO author (author_name, author_desc)
		VALUES ('류츠신','삼체 작가');


-- 테이블 생성 시 AUTO_INCREMENT 속성을 부여하는 방법
DROP TABLE book CASCADE; -- CASCADE 연결된 모든 레코드삭제 

CREATE TABLE book (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    pubs VARCHAR(100),
    pub_date DATETIME DEFAULT now(),
    author_id INT,
    CONSTRAINT book_fk FOREIGN KEY (author_id)
						REFERENCES author(author_id)
);

INSERT INTO book (title, pub_date, author_id) 
VALUES ('토지','1994-03-04', 1);

INSERT INTO book (title, author_id)
VALUES ('살인자의 기억법', 2);

INSERT INTO book (title, author_id)
VALUES ('쇼생크 탈출', 3);

INSERT INTO book (title, author_id)
VALUES ('삼체', 4);

SELECT * FROM book;

-- JOIN 
SELECT title 제목, 
	pub_date 출판일, 
	author_name 저자명, 
    author_desc '저자 상세'
FROM book b JOIN author a ON b.author_id = a.author_id;





