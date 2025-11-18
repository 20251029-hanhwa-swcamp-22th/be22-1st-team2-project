-- DEFAULT, NULL 제약조건은 -> 선택사항(입력 불필요), 필수적인 칼럼만 표시해서 INSERT
/*INSERT INTO USER (user_id, city_id, name, gender, birth_date, email, phone) VALUES
(null, null,'김신우','M','1998-01-12','rlatlsdn98@gmail.com','010-7611-7026');*/
DELETE FROM USER
WHERE user_id = 4;
-- 회원가입
INSERT INTO USER (name, email, phone)
VALUES ('정병진', 'wjdqudwls100@gmail.com', '010-7350-0692');
INSERT INTO USER (name, email, phone) VALUES ('정병진', 'wjdqudwls100@gmail.com', '010-7350-0692');
delete from user where user_id = 5;



INSERT INTO USER (name, email, phone) VALUES ('김민수', 'minsu.kim01@example.com', '010-4821-9912');
INSERT INTO USER (name, email, phone) VALUES ('박서연', 'seoyeon.park02@example.com', '010-9182-3365');
INSERT INTO USER (name, email, phone) VALUES ('이준호', 'junho.lee03@example.com', '010-5719-8834');
INSERT INTO USER (name, email, phone) VALUES ('최하은', 'haeun.choi04@example.com', '010-3345-1288');
INSERT INTO USER (name, email, phone) VALUES ('홍길동', 'hong.gd05@example.com', '010-6677-4532');
INSERT INTO USER (name, email, phone) VALUES ('김지윤', 'jiyoon.kim06@example.com', '010-2893-7741');
INSERT INTO USER (name, email, phone) VALUES ('박현우', 'hyunwoo.park07@example.com', '010-6471-9022');
INSERT INTO USER (name, email, phone) VALUES ('이지연', 'jiyeon.lee08@example.com', '010-7931-2240');
INSERT INTO USER (name, email, phone) VALUES ('송지혁', 'jihyeok.song09@example.com', '010-5520-1189');
INSERT INTO USER (name, email, phone) VALUES ('강채린', 'chaerin.kang10@example.com', '010-9300-8877');

select * from user;

UPDATE USER
SET password_hash = SHA2('temp1234', 256) # 임시 비밀번호 temp1234
WHERE password_hash IS NULL;

--

SELECT *
FROM FLIGHT_INFO F
         JOIN AIRPORT A ON F.origin_airport_id = A.airport_id
         JOIN CITY C ON A.city_id = C.city_id
         JOIN COUNTRY CO ON C.country_id = CO.country_id
WHERE F.origin_airport_id = 'ICN' AND F.destination_airport_id = 'JFK';

/*
검색 시나리오 1
 */
-- 출발지 : 인천공항, 도착지 : 도쿄 -> CITY 테이블
-- 두명
-- 저가항공사 숨기기 -> AIRLINE, 좌석등급 "비즈니스" -> FLIGHT_INFO, -> 최저가 내림차순 정렬.

-- 1. 가는편
SELECT *
FROM FLIGHT_INFO F
         JOIN AIRPORT AP ON F.origin_airport_id = AP.airport_id
         JOIN CITY C ON AP.city_id = C.city_id
         JOIN PRICE_BY_AGE PBA ON F.flight_info_id = PBA.flight_info_id
         JOIN AIRLINE_AIRCRAFT AA ON F.airline_aircraft_id = AA.airline_aircraft_id
         JOIN AIRLINE AL ON AA.airline_id = AL.airline_id
WHERE F.origin_airport_id = 'ICN'
  AND F.destination_airport_id = 'NRT'
  AND AL.airline_category = 'FSC'
  AND F.seat_class = 'BUSINESS';
-- 오는편
SELECT *
FROM FLIGHT_INFO F
         JOIN AIRPORT AP ON F.origin_airport_id = AP.airport_id
         JOIN CITY C ON AP.city_id = C.city_id
         JOIN PRICE_BY_AGE PBA ON F.flight_info_id = PBA.flight_info_id
         JOIN AIRLINE_AIRCRAFT AA ON F.airline_aircraft_id = AA.airline_aircraft_id
         JOIN AIRLINE AL ON AA.airline_id = AL.airline_id
WHERE F.origin_airport_id = 'NRT'
  AND F.destination_airport_id = 'LAX'
  AND AL.airline_category = 'FSC'
  AND F.seat_class = 'BUSINESS';


-- 3. 가는편 + 오는편 -> 최저가 오름차순 정렬.

WITH go AS (
    SELECT
        F.flight_info_id          AS go_flight_info_id,
        F.origin_airport_id       AS go_origin_airport_id,
        F.destination_airport_id  AS go_destination_airport_id,
        F.seat_class              AS go_seat_class,
        AP.airport_name           AS go_airport_name,
        C.city_name               AS go_city_name,
        AL.airline_name           AS go_airline_name,
        AL.airline_category       AS go_airline_category,
        PBA.adult                 AS go_adult_price,
        PBA.child                 AS go_child_price,
        PBA.infant                AS go_infant_price
    FROM FLIGHT_INFO F
             JOIN AIRPORT AP           ON F.origin_airport_id = AP.airport_id
             JOIN CITY C               ON AP.city_id = C.city_id
             JOIN PRICE_BY_AGE PBA     ON F.flight_info_id = PBA.flight_info_id
             JOIN AIRLINE_AIRCRAFT AA  ON F.airline_aircraft_id = AA.airline_aircraft_id
             JOIN AIRLINE AL           ON AA.airline_id = AL.airline_id
    WHERE F.origin_airport_id = 'ICN'
      AND F.destination_airport_id = 'NRT'
      AND AL.airline_category = 'FSC'
      AND F.seat_class = 'BUSINESS'
),
     back AS (
         SELECT
             F.flight_info_id          AS back_flight_info_id,
             F.origin_airport_id       AS back_origin_airport_id,
             F.destination_airport_id  AS back_destination_airport_id,
             F.seat_class              AS back_seat_class,
             AP.airport_name           AS back_airport_name,
             C.city_name               AS back_city_name,
             AL.airline_name           AS back_airline_name,
             AL.airline_category       AS back_airline_category,
             PBA.adult                 AS back_adult_price,
             PBA.child                 AS back_child_price,
             PBA.infant                AS back_infant_price
         FROM FLIGHT_INFO F
                  JOIN AIRPORT AP           ON F.origin_airport_id = AP.airport_id
                  JOIN CITY C               ON AP.city_id = C.city_id
                  JOIN PRICE_BY_AGE PBA     ON F.flight_info_id = PBA.flight_info_id
                  JOIN AIRLINE_AIRCRAFT AA  ON F.airline_aircraft_id = AA.airline_aircraft_id
                  JOIN AIRLINE AL           ON AA.airline_id = AL.airline_id
         WHERE F.origin_airport_id = 'NRT'
           AND F.destination_airport_id = 'LAX'
           AND AL.airline_category = 'FSC'
           AND F.seat_class = 'BUSINESS'
     )
SELECT

    (go_adult_price  + back_adult_price) * 2 AS total_adult_price
FROM go
         CROSS JOIN back
ORDER BY total_adult_price ASC;

