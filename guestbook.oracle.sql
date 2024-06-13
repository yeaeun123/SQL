
CREATE TABLE guestbook (
  no        NUMBER,
  name      VARCHAR2(80),
  password  VARCHAR2(20),
  content   VARCHAR2(2000),
  reg_date  DATE,
  PRIMARY KEY(no)
);

CREATE SEQUENCE seq_guestbook_no
INCREMENT BY 1 
START WITH 1 ;

SELECT * FROM guestbook;

DROP TABLE guestbook;
DROP SEQUENCE seq_guestbook_no;