-- guestbook 테이블
CREATE TABLE guestbook (
	no number primary key,
    name varchar(20) NOT NULL,
    password varchar(20) NOT NULL,
    content varchar(255) NOT NULL,
    regdate date DEFAULT sysdate
);

CREATE SEQUENCE seq_guestbook_no 
    START WITH 1 INCREMENT BY 1 NOCACHE;

insert into guestbook (no, name, password, content)
values (seq_guestbook_no.NEXTVAL, '방문자', 'test', '테스트 방명록입니다.');

SELECT no, name, password, content FROM guestbook ORDER BY regdate DESC;
commit;


DROP TABLE users;
DROP SEQUENCE seq_board_pk;

--users 테이블
CREATE TABLE users (
	no number PRIMARY KEY,
    name varchar(20) NOT NULL,
    email varchar(128) NOT NULL,
    password varchar(20) NOT NULL,
    gender char(1) DEFAULT 'M' check (gender in ('M', 'F')),
    joindate date DEFAULT sysdate
);

CREATE SEQUENCE seq_users_pk
    START WITH 1 INCREMENT BY 1 NOCACHE;

DESCRIBE users;
SELECT * FROM users;
commit;

--board 테이블]

DROP TABLE board;
DROP SEQUENCE seq_board_pk;

CREATE TABLE board (
	no number PRIMARY KEY,
    title varchar2(128) NOT NULL,
    content varchar2(255) NOT NULL,
    hit number DEFAULT 0,
    reg_date date DEFAULT sysdate,
    user_no number NOT NULL
);

CREATE SEQUENCE seq_board_pk
    START WITH 1
    INCREMENT BY 1;

    
SELECT * FROM board;

--사용자확인
SELECT * FROM users;

INSERT INTO board(no, title, content, user_no) 
VALUES(seq_board_pk.nextval, '첫번째 게시물입니다.', '첫번째 게시물입니다. 잘 되나요?',
13);

		SELECT b.no, 
				b.title,
				b.content,
				b.hit,
				b.reg_date as regDate,
				b.user_no as userNo,
				u.name as userName 
		FROM board b, users u 
		WHERE b.user_no = u.no;
        
commit;