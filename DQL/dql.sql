-- DDL (Data Definition Language)
-- 테이블 생성 및 제약 조건 설정
/*drop database tripdb;
 create database tripdb;*/
-- COUNTRY 테이블: ISO 국가 코드를 저장합니다.
DROP TABLE IF EXISTS `COUNTRY`;
CREATE TABLE `COUNTRY` (
                           `country_id`   CHAR(2)         NOT NULL    COMMENT 'ISO국가코드 (KR,JP,US)',
                           `country_name` VARCHAR(100)    NOT NULL    COMMENT '국가 이름',
                           PRIMARY KEY (`country_id`)
);

-- CITY 테이블: 도시 정보를 저장하며, COUNTRY 테이블을 참조합니다.
DROP TABLE IF EXISTS `CITY`;
CREATE TABLE `CITY` (
                        `city_id`      CHAR(3)         NOT NULL    COMMENT 'IATA 도시 CODE(SEL, TYO)',
                        `country_id`   CHAR(2)         NOT NULL    COMMENT '국가코드 (FK)',
                        `city_name`    VARCHAR(100)    NOT NULL    COMMENT '도시명(서울,도쿄,뉴욕 등)',
                        PRIMARY KEY (`city_id`),
                        CONSTRAINT `FK_COUNTRY_TO_CITY_1` FOREIGN KEY (`country_id`) REFERENCES `COUNTRY` (`country_id`)
);

-- AIRPORT 테이블: 공항 정보를 저장하며, CITY 테이블을 참조합니다.
DROP TABLE IF EXISTS `AIRPORT`;
CREATE TABLE `AIRPORT` (
                           `airport_id`   CHAR(3)         NOT NULL    COMMENT 'IATA 공항 CODE(ICN,GMP,NRT 등)',
                           `city_id`      CHAR(3)         NOT NULL    COMMENT 'city_id 참조 (FK)',
                           `airport_name` VARCHAR(100)    NOT NULL    COMMENT '공항명 ( 인천국제공항, 김포공항 등)',
                           PRIMARY KEY (`airport_id`),
                           CONSTRAINT `FK_CITY_TO_AIRPORT_1` FOREIGN KEY (`city_id`) REFERENCES `CITY` (`city_id`)
);

-- AIRLINE 테이블: 항공사 정보를 저장합니다.
DROP TABLE IF EXISTS `AIRLINE`;
CREATE TABLE `AIRLINE` (
                           `airline_id`       CHAR(2)         NOT NULL    COMMENT 'IATA 항공사 코드(KE, OZ 등)',
                           `airline_name`     VARCHAR(100)    NOT NULL    COMMENT '항공사명 (대한항공, 아시아나 등)',
                           `airline_category` VARCHAR(3)      NOT NULL    COMMENT 'FSC, LCC',
                           PRIMARY KEY (`airline_id`)
);
ALTER TABLE `AIRLINE` ADD CONSTRAINT `CHK_AIRLINE_CATEGORY` CHECK (`airline_category` IN ('FSC', 'LCC'));

-- AIRCRAFT 테이블: 항공기 기종 정보를 저장합니다.
DROP TABLE IF EXISTS `AIRCRAFT`;
CREATE TABLE `AIRCRAFT` (
                            `aircraft_id`   VARCHAR(10)     NOT NULL    COMMENT '기종코드 (예: B777)',
                            `aircraft_name` VARCHAR(100)    NOT NULL    COMMENT '기종이름 (BOEING 777-000등)',
                            `aircraft_type` VARCHAR(30)     NULL        COMMENT '기체유형(대형, 중형, 소형)',
                            PRIMARY KEY (`aircraft_id`)
);

-- AIRLINE_AIRCRAFT 테이블: 항공사와 항공기 매핑 정보를 저장합니다.
DROP TABLE IF EXISTS `AIRLINE_AIRCRAFT`;
CREATE TABLE `AIRLINE_AIRCRAFT` (
                                    `airline_aircraft_id` BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '항공사 기종 매핑 ID',
                                    `aircraft_id`         VARCHAR(10)     NOT NULL    COMMENT '기종 (FK)',
                                    `airline_id`          CHAR(2)         NOT NULL    COMMENT '항공사 (FK)',
                                    PRIMARY KEY (`airline_aircraft_id`),
                                    CONSTRAINT `FK_AIRCRAFT_TO_AIRLINE_AIRCRAFT_1` FOREIGN KEY (`aircraft_id`) REFERENCES `AIRCRAFT` (`aircraft_id`),
                                    CONSTRAINT `FK_AIRLINE_TO_AIRLINE_AIRCRAFT_1` FOREIGN KEY (`airline_id`) REFERENCES `AIRLINE` (`airline_id`)
);

-- FLIGHT_INFO 테이블: 항공편 운항 정보를 저장합니다.
DROP TABLE IF EXISTS `FLIGHT_INFO`;
CREATE TABLE `FLIGHT_INFO` (
                               `flight_info_id`         BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '운항정보 식별자',
                               `origin_airport_id`      CHAR(3)         NOT NULL    COMMENT '출발 공항 코드 (AIRPORT FK)',
                               `destination_airport_id` CHAR(3)         NOT NULL    COMMENT '도착 공항 코드 (AIRPORT FK)',
                               `airline_aircraft_id`    BIGINT          NOT NULL    COMMENT '항공사+항공기 매핑 테이블 (FK)',
                               `departure_time`         DATETIME        NOT NULL    COMMENT '출발 일시',
                               `arrival_time`           DATETIME        NOT NULL    COMMENT '도착 일시',
                               `flight_time`            INT             NOT NULL    DEFAULT 0 COMMENT '비행 시간 (분)',
                               `seat_class`             VARCHAR(20)     NOT NULL    COMMENT '좌석 등급',
                               `seat_counts`            INT             NOT NULL    DEFAULT 0 COMMENT '총 좌석 수',
                               `seat_stock`             INT             NOT NULL    DEFAULT 0 COMMENT '판매 가능 좌석 수',
                               `fuel_surcharge`         DECIMAL(10,2)   NULL        DEFAULT NULL COMMENT '유류할증료',
                               PRIMARY KEY (`flight_info_id`),
                               CONSTRAINT `FK_AIRPORT_TO_FLIGHT_INFO_1` FOREIGN KEY (`origin_airport_id`) REFERENCES `AIRPORT` (`airport_id`),
                               CONSTRAINT `FK_AIRPORT_TO_FLIGHT_INFO_2` FOREIGN KEY (`destination_airport_id`) REFERENCES `AIRPORT` (`airport_id`),
                               CONSTRAINT `FK_AIRLINE_AIRCRAFT_TO_FLIGHT_INFO_1` FOREIGN KEY (`airline_aircraft_id`) REFERENCES `AIRLINE_AIRCRAFT` (`airline_aircraft_id`)
);
ALTER TABLE `FLIGHT_INFO` ADD CONSTRAINT `CHK_FLIGHT_INFO_SEAT_CLASS` CHECK (`seat_class` IN ('ECONOMY', 'BUSINESS', 'FIRST'));

-- PRICE_BY_AGE 테이블: 연령대별 항공 요금을 저장합니다.
DROP TABLE IF EXISTS `PRICE_BY_AGE`;
CREATE TABLE `PRICE_BY_AGE` (
                                `flight_info_id` BIGINT          NOT NULL    COMMENT '운항정보 식별자 (FK)',
                                `adult`          DECIMAL(10,2)   NOT NULL    COMMENT '성인요금',
                                `child`          DECIMAL(10,2)   NOT NULL    COMMENT '소아요금',
                                `infant`         DECIMAL(10,2)   NOT NULL    COMMENT '유아요금',
                                PRIMARY KEY (`flight_info_id`),
                                CONSTRAINT `FK_FLIGHT_INFO_TO_PRICE_BY_AGE_1` FOREIGN KEY (`flight_info_id`) REFERENCES `FLIGHT_INFO` (`flight_info_id`)
);

-- USER 테이블: 회원 정보를 저장합니다.
DROP TABLE IF EXISTS `USER`;
CREATE TABLE `USER` (
                        `user_id`              BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '회원아이디',
                        `name`                 VARCHAR(50)     NOT NULL    COMMENT '회원 실명',
                        `gender`               CHAR(1)         NULL        DEFAULT NULL COMMENT 'M/W',
                        `birth_date`           DATE            NULL        DEFAULT NULL COMMENT 'YYYY-MM-DD',
                        `email`                VARCHAR(100)    NOT NULL    COMMENT '회원 이메일(로그인 ID)',
                        `password_hash`        VARCHAR(255)    NULL        COMMENT '비밀번호 (해시 값)',
                        `phone`                VARCHAR(20)     NOT NULL    COMMENT '휴대폰 번호',
                        `address`              VARCHAR(255)    NULL        DEFAULT NULL COMMENT '기본거주주소',
                        `residence_country`    CHAR(2)         NULL        DEFAULT 'KR' COMMENT 'ISO 국가코드(KR, US등)',
                        `preferred_language`   VARCHAR(10)     NULL        DEFAULT 'ko' COMMENT 'UI로 표시되는 언어',
                        `preferred_currency`   VARCHAR(10)     NULL        DEFAULT 'KRW' COMMENT 'KRW, USD, JPY 등',
                        `preferred_airline`    VARCHAR(10)     NULL        DEFAULT NULL COMMENT '선호하는 항공사 코드(KE, OZ 등)',
                        `preferred_seat_class` VARCHAR(10)     NULL        DEFAULT 'ECONOMY' COMMENT 'ECONOMY / BUSINESS / FIRST',
                        `preferred_city_id`    CHAR(3)         NULL        COMMENT '선호 도시 (CITY FK)',
                        `nickname`             VARCHAR(30)     NULL        DEFAULT NULL COMMENT '서비스 표시용 별명',
                        `profile_image`        VARCHAR(255)    NULL        DEFAULT NULL COMMENT '이미지 URL',
                        `account_status`       VARCHAR(20)     NOT NULL    DEFAULT 'ACTIVE' COMMENT 'ACTIVE / SUSPENDED / WITHDRAWN',
                        `withdrawal_reason`    VARCHAR(255)    NULL        DEFAULT NULL COMMENT '회원 탈퇴 시 입력값',
                        PRIMARY KEY (`user_id`),
                        CONSTRAINT `FK_CITY_TO_USER_1` FOREIGN KEY (`preferred_city_id`) REFERENCES `CITY` (`city_id`)
);
ALTER TABLE `USER` ADD CONSTRAINT `CHK_USER_GENDER` CHECK (`gender` IN ('M', 'W'));
ALTER TABLE `USER` ADD CONSTRAINT `CHK_PREFERRED_SEAT_CLASS` CHECK (`preferred_seat_class` IN ('ECONOMY', 'BUSINESS', 'FIRST'));
ALTER TABLE `USER` ADD CONSTRAINT `CHK_ACCOUNT_STATUS` CHECK (`account_status` IN ('ACTIVE', 'SUSPENDED', 'WITHDRAWN'));

-- PASSENGER 테이블: 탑승객 정보를 저장하며, USER 테이블에 연결될 수 있습니다.
DROP TABLE IF EXISTS `PASSENGER`;
CREATE TABLE `PASSENGER` (
                             `passenger_id`    BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '탑승자 고유 식별자 (PK)',
                             `user_id`         BIGINT          NULL        COMMENT '회원ID (FK, 비회원일 경우 NULL)',
                             `english_name`    VARCHAR(100)    NOT NULL    COMMENT '여권 영문명',
                             `passport_number` VARCHAR(20)     NULL        DEFAULT NULL COMMENT '여권 번호',
                             `nationality`     CHAR(2)         NULL        DEFAULT NULL COMMENT '국적 (국가 FK)',
                             `birth_date`      DATE            NOT NULL    COMMENT '탑승자 생년월일',
                             `gender`          CHAR(1)         NOT NULL    COMMENT '성별 (M/F/U)',
                             PRIMARY KEY (`passenger_id`),
                             CONSTRAINT `FK_USER_TO_PASSENGER_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`),
                             CONSTRAINT `FK_COUNTRY_TO_PASSENGER_1` FOREIGN KEY (`nationality`) REFERENCES `COUNTRY` (`country_id`)
);
ALTER TABLE `PASSENGER` ADD CONSTRAINT `CHK_PASSENGER_GENDER` CHECK (`gender` IN ('M', 'F', 'U'));

-- RESERVATION 테이블: 예약 정보를 저장합니다.
DROP TABLE IF EXISTS `RESERVATION`;
CREATE TABLE `RESERVATION` (
                               `reservation_id`     BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '예약 고유 식별자',
                               `user_id`            BIGINT          NULL        COMMENT '회원ID (FK, 비회원 예약 가능)',
                               `flight_info_id`     BIGINT          NOT NULL    COMMENT '운항정보(FK)',
                               `booker_info`        VARCHAR(255)    NOT NULL    COMMENT '예약 당시 예약자 스냅샷 데이터 (JSON)',
                               `fare_amount`        DECIMAL(12,2)   NULL        DEFAULT 0.00 COMMENT '기본 운임 금액',
                               `taxes`              DECIMAL(12,2)   NULL        DEFAULT 0.00 COMMENT '공항세/유류할증료/발권수수료 총합',
                               `reservation_status` VARCHAR(20)     NOT NULL    DEFAULT 'BOOKED' COMMENT 'BOOKED / TICKETED / CANCELED',
                               `created_at`         DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '예약 생성 시간',
                               `pnr`                VARCHAR(20)     NOT NULL    COMMENT '항공사 예약번호',
                               `trip_type`          VARCHAR(10)     NOT NULL    DEFAULT 'ONE_WAY' COMMENT 'ONE_WAY / ROUND / MULTI',
                               `refundable`         BOOLEAN         NOT NULL    COMMENT '환불 가능 여부 (0,1)',
                               PRIMARY KEY (`reservation_id`),
                               CONSTRAINT `FK_USER_TO_RESERVATION_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`),
                               CONSTRAINT `FK_FLIGHT_INFO_TO_RESERVATION_1` FOREIGN KEY (`flight_info_id`) REFERENCES `FLIGHT_INFO` (`flight_info_id`)
);
ALTER TABLE `RESERVATION` ADD CONSTRAINT `CHK_RESERVATION_STATUS` CHECK (`reservation_status` IN ('BOOKED', 'TICKETED', 'CANCELED'));
ALTER TABLE `RESERVATION` ADD CONSTRAINT `CHK_TRIP_TYPE` CHECK (`trip_type` IN ('ONE_WAY', 'ROUND', 'MULTI'));

-- RESERVATION_PASSENGER 테이블: 예약과 탑승객의 다대다 관계를 저장합니다.
DROP TABLE IF EXISTS `RESERVATION_PASSENGER`;
CREATE TABLE `RESERVATION_PASSENGER` (
                                         `reservation_id` BIGINT NOT NULL COMMENT '예약 고유 식별자 (FK)',
                                         `passenger_id`   BIGINT NOT NULL COMMENT '탑승자 고유 식별자 (FK)',
                                         PRIMARY KEY (`reservation_id`, `passenger_id`),
                                         CONSTRAINT `FK_RESERVATION_TO_RESERVATION_PASSENGER_1` FOREIGN KEY (`reservation_id`) REFERENCES `RESERVATION` (`reservation_id`),
                                         CONSTRAINT `FK_PASSENGER_TO_RESERVATION_PASSENGER_1` FOREIGN KEY (`passenger_id`) REFERENCES `PASSENGER` (`passenger_id`)
);

-- TICKET 테이블: 발권된 티켓 정보를 저장합니다.
DROP TABLE IF EXISTS `TICKET`;
CREATE TABLE `TICKET` (
                          `ticket_number`  VARCHAR(20) NOT NULL COMMENT '전자티켓 번호(806-0000001067)',
                          `reservation_id` BIGINT      NOT NULL COMMENT '예약 고유 식별자 (FK)',
                          `passenger_id`   BIGINT      NOT NULL COMMENT '탑승객 (FK)',
                          `issued_at`      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '발권 일시',
                          `ticket_status`  VARCHAR(20) NOT NULL DEFAULT 'ISSUED' COMMENT 'ISSUED / CANCELLED 등',
                          PRIMARY KEY (`ticket_number`),
                          CONSTRAINT `FK_RESERVATION_TO_TICKET_1` FOREIGN KEY (`reservation_id`) REFERENCES `RESERVATION` (`reservation_id`),
                          CONSTRAINT `FK_PASSENGER_TO_TICKET_1` FOREIGN KEY (`passenger_id`) REFERENCES `PASSENGER` (`passenger_id`)
);
ALTER TABLE `TICKET` ADD CONSTRAINT `CHK_TICKET_STATUS` CHECK (`ticket_status` IN ('ISSUED', 'CANCELLED'));

-- CANCEL_LOG 테이블: 예약 취소 기록을 저장합니다.
DROP TABLE IF EXISTS `CANCEL_LOG`;
CREATE TABLE `CANCEL_LOG` (
                              `cancel_log_id`  BIGINT   NOT NULL AUTO_INCREMENT COMMENT '취소 로그 ID (PK)',
                              `reservation_id` BIGINT   NOT NULL COMMENT '예약 고유 식별자 (FK)',
                              `cancelled_at`   DATETIME NOT NULL COMMENT '취소 일시',
                              `refund_amount`  INT      NOT NULL COMMENT '환불 금액',
                              PRIMARY KEY (`cancel_log_id`),
                              CONSTRAINT `FK_RESERVATION_TO_CANCEL_LOG_1` FOREIGN KEY (`reservation_id`) REFERENCES `RESERVATION` (`reservation_id`)
);

-- CATEGORY 테이블: 고객 지원 문의 유형을 저장합니다.
DROP TABLE IF EXISTS `CATEGORY`;
CREATE TABLE `CATEGORY` (
                            `category_id`    INT         NOT NULL    AUTO_INCREMENT COMMENT '문의 유형 고유 ID',
                            `category_title` VARCHAR(50) NOT NULL    COMMENT '문의 카테고리명 (예: 결제, 예약변경, 환불 등)',
                            PRIMARY KEY (`category_id`)
);

-- ADMIN 테이블: 관리자 계정 정보를 저장합니다.
DROP TABLE IF EXISTS `ADMIN`;
CREATE TABLE `ADMIN` (
                         `admin_id`       BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '관리자 고유 식별자',
                         `admin_login_id` VARCHAR(50)     NOT NULL    COMMENT '관리자 계정 ID',
                         `admin_password` VARCHAR(255)    NOT NULL    COMMENT '해시된 비밀번호 (암호화 저장)',
                         PRIMARY KEY (`admin_id`)
);

-- CUSTOMER_SUPPORT 테이블: 고객 문의 내용을 저장합니다.
DROP TABLE IF EXISTS `CUSTOMER_SUPPORT`;
CREATE TABLE `CUSTOMER_SUPPORT` (
                                    `support_id`       BIGINT       NOT NULL    AUTO_INCREMENT COMMENT '문의 고유 식별자',
                                    `user_id`          BIGINT       NOT NULL    COMMENT '회원ID (FK)',
                                    `category_id`      INT          NOT NULL    COMMENT '문의 종류 코드 (FK)',
                                    `question_content` TEXT         NOT NULL    COMMENT '회원이 작성한 문의 상세 내용',
                                    `question_status`  VARCHAR(20)  NOT NULL    DEFAULT 'PENDING' COMMENT '문의 처리 상태 (PENDING / IN_PROGRESS / COMPLETED)',
                                    `created_at`       TIMESTAMP    NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '문의 접수 일시',
                                    `updated_at`       TIMESTAMP    NULL        DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '문의/답변 수정 일시',
                                    PRIMARY KEY (`support_id`),
                                    CONSTRAINT `FK_USER_TO_CUSTOMER_SUPPORT_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`),
                                    CONSTRAINT `FK_CATEGORY_TO_CUSTOMER_SUPPORT_1` FOREIGN KEY (`category_id`) REFERENCES `CATEGORY` (`category_id`)
);
ALTER TABLE `CUSTOMER_SUPPORT` ADD CONSTRAINT `CHK_QUESTION_STATUS` CHECK (`question_status` IN ('PENDING', 'IN_PROGRESS', 'COMPLETED'));

-- REPLY 테이블: 고객 문의에 대한 관리자의 답변을 저장합니다.
DROP TABLE IF EXISTS `REPLY`;
CREATE TABLE `REPLY` (
                         `reply_id`      BIGINT    NOT NULL    AUTO_INCREMENT COMMENT '답변 고유 식별자',
                         `support_id`    BIGINT    NOT NULL    COMMENT 'CUSTOMER_SUPPORT.support_id FK',
                         `admin_id`      BIGINT    NOT NULL    COMMENT '답변 작성한 관리자 ID (ADMIN 테이블 FK)',
                         `reply_content` TEXT      NOT NULL    COMMENT '상담원이 작성한 답변 텍스트',
                         `replied_at`    TIMESTAMP NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '답변 작성 시간',
                         `updated_at`    TIMESTAMP NULL        DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '답변이 수정된 시간',
                         PRIMARY KEY (`reply_id`),
                         CONSTRAINT `FK_CUSTOMER_SUPPORT_TO_REPLY_1` FOREIGN KEY (`support_id`) REFERENCES `CUSTOMER_SUPPORT` (`support_id`),
                         CONSTRAINT `FK_ADMIN_TO_REPLY_1` FOREIGN KEY (`admin_id`) REFERENCES `ADMIN` (`admin_id`)
);

-- FAVORITE 테이블: 사용자가 즐겨찾기한 공항 정보를 저장합니다.
DROP TABLE IF EXISTS `FAVORITE`;
CREATE TABLE `FAVORITE` (
                            `airport_id` CHAR(3) NOT NULL COMMENT '공항 IATA 코드 (FK → AIRPORT.airport_id)',
                            `user_id`    BIGINT  NOT NULL COMMENT '회원 고유 ID (FK → USER.user_id)',
                            PRIMARY KEY (`airport_id`, `user_id`),
                            CONSTRAINT `FK_AIRPORT_TO_FAVORITE_1` FOREIGN KEY (`airport_id`) REFERENCES `AIRPORT` (`airport_id`),
                            CONSTRAINT `FK_USER_TO_FAVORITE_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`)
);

-- AIR_ALLIANCE 테이블: 항공 동맹 정보를 저장합니다.
DROP TABLE IF EXISTS `AIR_ALLIANCE`;
CREATE TABLE `AIR_ALLIANCE` (
                                `alliance_id`   VARCHAR(10) NOT NULL COMMENT 'STAR / SKYTEAM / ONEWORLD 등의 코드',
                                `airline_id`    CHAR(2)     NOT NULL COMMENT '항공사 코드 (FK → AIRLINE.airline_id)',
                                `alliance_name` VARCHAR(50) NULL     COMMENT '동맹 이름 (예: Star Alliance)',
                                PRIMARY KEY (`alliance_id`, `airline_id`),
                                CONSTRAINT `FK_AIRLINE_TO_AIR_ALLIANCE_1` FOREIGN KEY (`airline_id`) REFERENCES `AIRLINE` (`airline_id`)
);

-- PROVIDER_INFO 테이블: 서비스 공급사 정보를 저장합니다.
DROP TABLE IF EXISTS `PROVIDER_INFO`;
CREATE TABLE `PROVIDER_INFO` (
                                 `business_number`    CHAR(10)        NOT NULL    COMMENT '숫자 10자리 사업자 등록번호',
                                 `provider_name`      VARCHAR(100)    NOT NULL    COMMENT '회사 또는 공급사 이름',
                                 `provider_info`      VARCHAR(255)    NULL        DEFAULT NULL COMMENT '상세 설명 또는 간단한 소개',
                                 `settlement_account` VARCHAR(30)     NULL        DEFAULT NULL COMMENT '정산 입금 계좌번호',
                                 `contact`            VARCHAR(20)     NULL        DEFAULT NULL COMMENT '대표 연락처(전화번호)',
                                 `service_type`       VARCHAR(30)     NULL        DEFAULT NULL COMMENT '항공, 호텔, 투어, 보험 등 제공 서비스 종류',
                                 PRIMARY KEY (`business_number`)
);


-- DML (Data Manipulation Language)
-- 샘플 데이터 삽입

-- COUNTRY
INSERT INTO `COUNTRY` (`country_id`, `country_name`) VALUES
                                                         ('KR', '대한민국'), ('US', '미국'), ('JP', '일본'), ('CN', '중국');

-- CITY
INSERT INTO `CITY` (`city_id`, `country_id`, `city_name`) VALUES
                                                              ('SEL', 'KR', '서울'), ('PUS', 'KR', '부산'), ('TYO', 'JP', '도쿄'),
                                                              ('NYC', 'US', '뉴욕'), ('LAX', 'US', '로스앤젤레스'), ('BJS', 'CN', '베이징');

-- AIRPORT
INSERT INTO `AIRPORT` (`airport_id`, `city_id`, `airport_name`) VALUES
                                                                    ('ICN', 'SEL', '인천국제공항'), ('GMP', 'SEL', '김포국제공항'), ('NRT', 'TYO', '나리타국제공항'),
                                                                    ('HND', 'TYO', '하네다국제공항'), ('JFK', 'NYC', '존 F. 케네디 국제공항'), ('LAX', 'LAX', '로스앤젤레스 국제공항');

-- AIRLINE
INSERT INTO `AIRLINE` (`airline_id`, `airline_name`, `airline_category`) VALUES
                                                                             ('KE', '대한항공', 'FSC'), ('OZ', '아시아나항공', 'FSC'), ('JL', '일본항공', 'FSC'), ('NH', '전일본공수', 'FSC'), ('7C', '제주항공', 'LCC');

-- AIRCRAFT
INSERT INTO `AIRCRAFT` (`aircraft_id`, `aircraft_name`, `aircraft_type`) VALUES
                                                                             ('B747', 'BOEING 747-400', '대형'), ('B777', 'BOEING 777-300ER', '대형'),
                                                                             ('A380', 'AIRBUS A380-800', '초대형'), ('A320', 'AIRBUS A320-200', '중형');

-- AIRLINE_AIRCRAFT
INSERT INTO `AIRLINE_AIRCRAFT` (`aircraft_id`, `airline_id`) VALUES
                                                                 ('B747', 'KE'), ('B777', 'KE'), ('A380', 'OZ'), ('A320', 'OZ'), ('B777', 'JL'), ('A320', 'NH');

-- USER
INSERT INTO `USER` (`name`, `gender`, `birth_date`, `email`, `password_hash`, `phone`, `address`, `residence_country`, `nickname`, `account_status`) VALUES
                                                                                                                                                         ('김철수', 'M', '1990-05-15', 'kim.cs@example.com', 'hashed_password_1', '010-1234-5678', '서울시 강남구', 'KR', '철수', 'ACTIVE'),
                                                                                                                                                         ('이영희', 'W', '1988-11-22', 'lee.yh@example.com', 'hashed_password_2', '010-9876-5432', '부산시 해운대구', 'KR', '영희', 'ACTIVE'),
                                                                                                                                                         ('John Doe', 'M', '1985-03-10', 'john.doe@example.com', 'hashed_password_3', '001-123-4567', '123 Main St, New York', 'US', 'JD', 'ACTIVE');

-- PASSENGER
INSERT INTO `PASSENGER` (`user_id`, `english_name`, `nationality`, `birth_date`, `gender`) VALUES
                                                                                               (1, 'KIM CHEOLSU', 'KR', '1990-05-15', 'M'),
                                                                                               (2, 'LEE YOUNGHEE', 'KR', '1988-11-22', 'F'),
                                                                                               (3, 'JOHN DOE', 'US', '1985-03-10', 'M'),
                                                                                               (3, 'JANE DOE', 'US', '1987-07-01', 'F'); -- 동반 탑승객

-- FLIGHT_INFO & PRICE_BY_AGE
-- 1. ICN -> NRT
INSERT INTO `FLIGHT_INFO` (`origin_airport_id`, `destination_airport_id`, `airline_aircraft_id`, `departure_time`, `arrival_time`, `flight_time`, `seat_class`, `seat_counts`, `seat_stock`, `fuel_surcharge`) VALUES
    ('ICN', 'NRT', 1, '2025-12-01 09:00:00', '2025-12-01 11:30:00', 150, 'ECONOMY', 300, 250, 20.00);
SET @flight_info_1 = LAST_INSERT_ID();
INSERT INTO `PRICE_BY_AGE` (`flight_info_id`, `adult`, `child`, `infant`) VALUES
    (@flight_info_1, 150000.00, 120000.00, 15000.00);

-- 2. NRT -> ICN
INSERT INTO `FLIGHT_INFO` (`origin_airport_id`, `destination_airport_id`, `airline_aircraft_id`, `departure_time`, `arrival_time`, `flight_time`, `seat_class`, `seat_counts`, `seat_stock`, `fuel_surcharge`) VALUES
    ('NRT', 'ICN', 1, '2025-12-05 14:00:00', '2025-12-05 16:30:00', 150, 'ECONOMY', 300, 280, 20.00);
SET @flight_info_2 = LAST_INSERT_ID();
INSERT INTO `PRICE_BY_AGE` (`flight_info_id`, `adult`, `child`, `infant`) VALUES
    (@flight_info_2, 140000.00, 110000.00, 14000.00);

-- 3. ICN -> JFK
INSERT INTO `FLIGHT_INFO` (`origin_airport_id`, `destination_airport_id`, `airline_aircraft_id`, `departure_time`, `arrival_time`, `flight_time`, `seat_class`, `seat_counts`, `seat_stock`, `fuel_surcharge`) VALUES
    ('ICN', 'JFK', 3, '2025-12-10 10:00:00', '2025-12-10 10:00:00', 840, 'BUSINESS', 100, 80, 100.00);
SET @flight_info_3 = LAST_INSERT_ID();
INSERT INTO `PRICE_BY_AGE` (`flight_info_id`, `adult`, `child`, `infant`) VALUES
    (@flight_info_3, 2000000.00, 1600000.00, 200000.00);

-- RESERVATION
INSERT INTO `RESERVATION` (`user_id`, `flight_info_id`, `booker_info`, `fare_amount`, `taxes`, `pnr`, `trip_type`, `refundable`) VALUES
    (1, @flight_info_1, '{"name": "김철수", "email": "kim.cs@example.com"}', 150000.00, 30000.00, 'ABCDEF1234567890', 'ONE_WAY', 1);
SET @reservation_1 = LAST_INSERT_ID();

INSERT INTO `RESERVATION` (`user_id`, `flight_info_id`, `booker_info`, `fare_amount`, `taxes`, `pnr`, `trip_type`, `refundable`) VALUES
    (3, @flight_info_3, '{"name": "John Doe", "email": "john.doe@example.com"}', 3600000.00, 150000.00, 'GHIJKL9876543210', 'ONE_WAY', 1);
SET @reservation_2 = LAST_INSERT_ID();

-- RESERVATION_PASSENGER
INSERT INTO `RESERVATION_PASSENGER` (`reservation_id`, `passenger_id`) VALUES
                                                                           (@reservation_1, 1),
                                                                           (@reservation_2, 3),
                                                                           (@reservation_2, 4);

-- CATEGORY
INSERT INTO `CATEGORY` (`category_title`) VALUES ('결제'), ('예약 변경'), ('환불'), ('기타 문의');

-- ADMIN
INSERT INTO `ADMIN` (`admin_login_id`, `admin_password`) VALUES ('admin01', 'hashed_password_admin01'), ('admin02', 'hashed_password_admin02');

-- CUSTOMER_SUPPORT & REPLY
INSERT INTO `CUSTOMER_SUPPORT` (`user_id`, `category_id`, `question_content`, `question_status`) VALUES
    (1, 1, '결제가 완료되지 않았습니다. 확인 부탁드립니다.', 'PENDING');
SET @support_1 = LAST_INSERT_ID();
INSERT INTO `REPLY` (`support_id`, `admin_id`, `reply_content`) VALUES
    (@support_1, 1, '결제 시스템 오류로 확인되었습니다. 재결제 시도 부탁드립니다.');

-- AIR_ALLIANCE
INSERT INTO `AIR_ALLIANCE` (`alliance_id`, `airline_id`, `alliance_name`) VALUES
                                                                              ('STAR', 'OZ', 'Star Alliance'), ('SKYTEAM', 'KE', 'SkyTeam');


-- INDEX, PROCEDURE, TRIGGER

-- INDEX Recommendations
CREATE INDEX `IDX_USER_EMAIL` ON `USER` (`email`);
CREATE INDEX `IDX_RESERVATION_PNR` ON `RESERVATION` (`pnr`);
CREATE INDEX `IDX_CUSTOMER_SUPPORT_USER_ID` ON `CUSTOMER_SUPPORT` (`user_id`);
CREATE INDEX `IDX_CUSTOMER_SUPPORT_CATEGORY_ID` ON `CUSTOMER_SUPPORT` (`category_id`);
CREATE INDEX `IDX_CUSTOMER_SUPPORT_QUESTION_STATUS` ON `CUSTOMER_SUPPORT` (`question_status`);
CREATE INDEX `IDX_FLIGHT_INFO_ORIGIN_DEST_DEPARTURE` ON `FLIGHT_INFO` (`origin_airport_id`, `destination_airport_id`, `departure_time`);
CREATE INDEX `IDX_TICKET_RESERVATION_ID` ON `TICKET` (`reservation_id`);
CREATE INDEX `IDX_REPLY_SUPPORT_ID` ON `REPLY` (`support_id`);

-- PROCEDURE Recommendations

-- Procedure to create a new reservation
DELIMITER //
CREATE PROCEDURE `CreateReservation`(
    IN p_flight_info_id BIGINT,
    IN p_user_id BIGINT, -- NULL for non-members
    IN p_booker_info VARCHAR(255),
    IN p_pnr VARCHAR(20),
    IN p_trip_type VARCHAR(10),
    IN p_refundable BOOLEAN,
    IN p_passenger_ids TEXT -- Comma-separated passenger IDs (e.g., '1,2,3')
)
BEGIN
    DECLARE v_reservation_id BIGINT;
    DECLARE v_seat_stock INT;
    DECLARE v_num_passengers INT;
    DECLARE v_total_fare DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_total_taxes DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_passenger_id_str VARCHAR(20);
    DECLARE v_passenger_id BIGINT;
    DECLARE v_birth_date DATE;
    DECLARE v_age INT;
    DECLARE v_adult_fare DECIMAL(10,2);
    DECLARE v_child_fare DECIMAL(10,2);
    DECLARE v_infant_fare DECIMAL(10,2);
    DECLARE v_fuel_surcharge DECIMAL(10,2);
    DECLARE cur_pos INT DEFAULT 1;
    DECLARE comma_pos INT;

    -- Calculate number of passengers
    SET v_num_passengers = 1 + LENGTH(p_passenger_ids) - LENGTH(REPLACE(p_passenger_ids, ',', ''));

    START TRANSACTION;

    -- Check seat availability
    SELECT seat_stock, fuel_surcharge INTO v_seat_stock, v_fuel_surcharge
    FROM `FLIGHT_INFO` WHERE flight_info_id = p_flight_info_id FOR UPDATE;

    IF v_seat_stock < v_num_passengers THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough seats available';
    ELSE
        -- Get prices
        SELECT adult, child, infant INTO v_adult_fare, v_child_fare, v_infant_fare
        FROM `PRICE_BY_AGE` WHERE flight_info_id = p_flight_info_id;

        -- Calculate total fare based on passenger age
        WHILE cur_pos > 0 DO
                SET comma_pos = LOCATE(',', p_passenger_ids, cur_pos);
                IF comma_pos = 0 THEN
                    SET v_passenger_id_str = SUBSTRING(p_passenger_ids, cur_pos);
                    SET cur_pos = 0;
                ELSE
                    SET v_passenger_id_str = SUBSTRING(p_passenger_ids, cur_pos, comma_pos - cur_pos);
                    SET cur_pos = comma_pos + 1;
                END IF;

                SET v_passenger_id = CAST(v_passenger_id_str AS UNSIGNED);

                SELECT birth_date INTO v_birth_date FROM `PASSENGER` WHERE passenger_id = v_passenger_id;
                SET v_age = TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE());

                IF v_age >= 12 THEN
                    SET v_total_fare = v_total_fare + v_adult_fare;
                ELSEIF v_age >= 2 THEN
                    SET v_total_fare = v_total_fare + v_child_fare;
                ELSE
                    SET v_total_fare = v_total_fare + v_infant_fare;
                END IF;

                -- Assuming a simple tax calculation for example
                SET v_total_taxes = v_total_taxes + v_fuel_surcharge + (v_total_fare * 0.1); -- Fare * 10% as tax
            END WHILE;

        -- Create reservation
        INSERT INTO `RESERVATION` (user_id, flight_info_id, booker_info, fare_amount, taxes, pnr, trip_type, refundable)
        VALUES (p_user_id, p_flight_info_id, p_booker_info, v_total_fare, v_total_taxes, p_pnr, p_trip_type, p_refundable);
        SET v_reservation_id = LAST_INSERT_ID();

        -- Update seat stock
        UPDATE `FLIGHT_INFO` SET seat_stock = seat_stock - v_num_passengers WHERE flight_info_id = p_flight_info_id;

        -- Link passengers to reservation
        SET cur_pos = 1;
        WHILE cur_pos > 0 DO
                SET comma_pos = LOCATE(',', p_passenger_ids, cur_pos);
                IF comma_pos = 0 THEN
                    SET v_passenger_id_str = SUBSTRING(p_passenger_ids, cur_pos);
                    SET cur_pos = 0;
                ELSE
                    SET v_passenger_id_str = SUBSTRING(p_passenger_ids, cur_pos, comma_pos - cur_pos);
                    SET cur_pos = comma_pos + 1;
                END IF;

                SET v_passenger_id = CAST(v_passenger_id_str AS UNSIGNED);
                INSERT INTO `RESERVATION_PASSENGER` (reservation_id, passenger_id) VALUES (v_reservation_id, v_passenger_id);
            END WHILE;

        COMMIT;
        SELECT v_reservation_id AS reservation_id;
    END IF;
END //
DELIMITER ;

-- Procedure to cancel a reservation
DELIMITER //
CREATE PROCEDURE `CancelReservation`(
    IN p_reservation_id BIGINT,
    IN p_refund_amount INT
)
BEGIN
    DECLARE v_flight_info_id BIGINT;
    DECLARE v_num_passengers INT;
    DECLARE v_current_status VARCHAR(20);

    START TRANSACTION;

    SELECT flight_info_id, reservation_status INTO v_flight_info_id, v_current_status
    FROM `RESERVATION` WHERE reservation_id = p_reservation_id FOR UPDATE;

    IF v_current_status = 'CANCELED' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reservation already canceled';
    ELSE
        UPDATE `RESERVATION` SET reservation_status = 'CANCELED' WHERE reservation_id = p_reservation_id;

        SELECT COUNT(*) INTO v_num_passengers FROM `RESERVATION_PASSENGER` WHERE reservation_id = p_reservation_id;

        UPDATE `FLIGHT_INFO` SET seat_stock = seat_stock + v_num_passengers WHERE flight_info_id = v_flight_info_id;

        INSERT INTO `CANCEL_LOG` (reservation_id, cancelled_at, refund_amount)
        VALUES (p_reservation_id, NOW(), p_refund_amount);

        -- Also cancel associated tickets
        UPDATE `TICKET` SET ticket_status = 'CANCELLED' WHERE reservation_id = p_reservation_id;

        COMMIT;
        SELECT 'Reservation canceled successfully' AS message;
    END IF;
END //
DELIMITER ;


-- TRIGGER Recommendations

-- Trigger to update CUSTOMER_SUPPORT.updated_at when a reply is added or updated
DELIMITER //
CREATE TRIGGER `trg_update_support_timestamp_on_reply`
    AFTER INSERT ON `REPLY`
    FOR EACH ROW
BEGIN
    UPDATE `CUSTOMER_SUPPORT`
    SET `updated_at` = NOW()
    WHERE `support_id` = NEW.support_id;
END //
DELIMITER ;
