/*
회원가입
 */

-- DEFAULT, NULL 제약조건은 -> 선택사항(입력 불필요), 필수적인 칼럼만 표시해서 INSERT
INSERT INTO USER (user_id, city_id, name, gender, birth_date, email, phone) VALUES
(null, null,'김신우','M','1998-01-12','rlatlsdn98@gmail.com','010-7611-7026');