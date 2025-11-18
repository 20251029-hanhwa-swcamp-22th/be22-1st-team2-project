-- =======================================================================
-- 1. Table Creation and CHECK Constraints
-- =======================================================================
/*CREATE USER 'trip'@'%' IDENTIFIED BY 'trip';
CREATE DATABASE tripdb;
GRANT ALL PRIVILEGES ON tripdb.* TO 'trip'@'%';
GRANT ALL PRIVILEGES ON tripdb.* TO 'trip'@'localhost' IDENTIFIED BY 'trip' WITH GRANT OPTION ;*/
CREATE USER 'trip'@'%' IDENTIFIED BY 'trip';
CREATE DATABASE tripdb;
GRANT ALL PRIVILEGES ON tripdb.* TO 'trip'@'%';
GRANT ALL PRIVILEGES ON tripdb.* TO 'trip'@'localhost' IDENTIFIED BY 'trip' WITH GRANT OPTION ;

-- Corrected DDL for COUNTRY
DROP TABLE IF EXISTS `COUNTRY`;
CREATE TABLE `COUNTRY` (
	`country_id`	CHAR(2)	NOT NULL	COMMENT 'ISO국가코드 (KR,JP,US)', -- Removed AUTO_INCREMENT
	`country_name`	VARCHAR(100)	NOT NULL	COMMENT '국가 이름',
	PRIMARY KEY (`country_id`)
);

-- Create table PRICE_BY_AGE
CREATE TABLE PRICE_BY_AGE (
    flight_info_id BIGINT NOT NULL,
    adult DECIMAL(10,2) NOT NULL,
    child DECIMAL(10,2) NOT NULL,
    infant DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (flight_info_id) REFERENCES FLIGHT_INFO (flight_info_id)
);

-- Corrected DDL for CITY
DROP TABLE IF EXISTS `CITY`;
CREATE TABLE `CITY` (
	`city_id`	CHAR(3)	NOT NULL	COMMENT 'IATA 도시 CODE(SEL, TYO)',
	`country_id`	CHAR(2)	NOT NULL	COMMENT '국가코드',
	`city_name`	VARCHAR(100)	NOT NULL	COMMENT '도시명(서울,도쿄,뉴욕 등)',
	PRIMARY KEY (`city_id`)
);

-- Corrected DDL for AIRPORT
DROP TABLE IF EXISTS `AIRPORT`;
CREATE TABLE `AIRPORT` (
	`airport_id`	CHAR(3)	NOT NULL	COMMENT 'IATA 공항 CODE(ICN,GMP,NRT 등)',
	`city_id`	CHAR(3)	NOT NULL	COMMENT 'city_id 참조',
	`airport_name`	VARCHAR(100)	NOT NULL	COMMENT '공항명 ( 인천국제공항, 김포공항 등)',
	PRIMARY KEY (`airport_id`)
);

-- Corrected DDL for AIRLINE
DROP TABLE IF EXISTS `AIRLINE`;
CREATE TABLE `AIRLINE` (
	`airline_id`	CHAR(2)	NOT NULL	COMMENT 'IATA 항공사 코드(KE, OZ 등)',
	`airline_name`	VARCHAR(100)	NOT NULL	COMMENT '항공사명 (대한항공, 아시아나 등)',
	PRIMARY KEY (`airline_id`)
);

-- Corrected DDL for AIRCRAFT
DROP TABLE IF EXISTS `AIRCRAFT`;
CREATE TABLE `AIRCRAFT` (
	`aircraft_id`	VARCHAR(10)	NOT NULL	COMMENT '기종코드 (예: B777)',
	`aircraft_name`	VARCHAR(100)	NOT NULL	COMMENT '기종이름 (BOEING 777-000등)',
	`aircraft_type`	VARCHAR(30)	NULL	COMMENT '기체유형(대형, 중형, 소형)',
	PRIMARY KEY (`aircraft_id`)
);

-- Corrected DDL for AIRLINE_AIRCRAFT
DROP TABLE IF EXISTS `AIRLINE_AIRCRAFT`;
CREATE TABLE `AIRLINE_AIRCRAFT` (
	`airline_aircraft_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '항공사 기종 매핑 ID',
	`aircraft_id`	VARCHAR(10)	NOT NULL	COMMENT '기종 (FK)',
	`airline_id`	CHAR(2)	NOT NULL	COMMENT '항공사 (FK)', -- Corrected type
	PRIMARY KEY (`airline_aircraft_id`)
);

-- Corrected DDL for FLIGHT_INFO (Table name corrected from FIGHT_INFO)
DROP TABLE IF EXISTS `FLIGHT_INFO`;
CREATE TABLE `FLIGHT_INFO` (
	`flight_info_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '운항정보 식별자', -- Changed to BIGINT and AUTO_INCREMENT
	`origin_airport_id`	CHAR(3)	NOT NULL	COMMENT '출발 공항 코드 (AIRPORT FK)',
	`destination_airport_id`	CHAR(3)	NOT NULL	COMMENT '도착 공항 코드 (AIRPORT FK)',
	`airline_aircraft_id`	BIGINT	NOT NULL	COMMENT '항공사+항공기 매핑 테이블 (FK)', -- Corrected type
	`departure_time`	DATETIME	NOT NULL	COMMENT '출발 일시',
	`arrival_time`	DATETIME	NOT NULL	COMMENT '도착 일시',
	`flight_time`	INT	NOT NULL	DEFAULT 0	COMMENT '비행 시간',
	`seat_class`	VARCHAR(20)	NOT NULL	COMMENT '좌석 등급',
	`seat_counts`	INT	NOT NULL	DEFAULT 0	COMMENT '총 좌석 수',
	`seat_stock`	INT	NOT NULL	DEFAULT 0	COMMENT '판매 가능 좌석 수',
	`tax_structure`	DECIMAL(10,2)	NULL	DEFAULT NULL	COMMENT '세금',
	`fuel_surcharge`	DECIMAL(10,2)	NULL	DEFAULT NULL	COMMENT '유류할증료',
	`fare_amount`	DECIMAL(10,2)	NULL	DEFAULT NULL	COMMENT '기본운임',
	PRIMARY KEY (`flight_info_id`)
);
ALTER TABLE `FLIGHT_INFO` ADD CONSTRAINT `CHK_FLIGHT_INFO_SEAT_CLASS` CHECK (`seat_class` IN ('ECONOMY', 'BUSINESS', 'FIRST'));

-- Corrected DDL for USER
DROP TABLE IF EXISTS `USER`;
CREATE TABLE `USER` (
	`user_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '회원아이디',
	`city_id`	CHAR(3)	NULL	COMMENT 'IATA 도시 CODE(SEL, TYO)',
	`name`	VARCHAR(50)	NOT NULL	COMMENT '회원 실명',
	`gender`	CHAR(1)	NULL	DEFAULT NULL	COMMENT 'M/W',
	`birth_date`	DATE	NULL	DEFAULT NULL	COMMENT 'YYYY-MM-DD',
	`email`	VARCHAR(100)	NOT NULL	COMMENT '회원 이메일(로그인 ID)',
	`phone`	VARCHAR(20)	NOT NULL	COMMENT '휴대폰 번호',
	`address`	VARCHAR(255)	NULL	DEFAULT NULL	COMMENT '기본거주주소',
	`residence_country`	CHAR(2)	NULL	DEFAULT 'KR'	COMMENT 'ISO 국가코드(KR, US등)',
	`preferred_language`	VARCHAR(10)	NULL	DEFAULT 'ko'	COMMENT 'UI로 표시되는 언어',
	`preferred_currency`	VARCHAR(10)	NULL	DEFAULT 'KRW'	COMMENT 'KRW, USD, JPY 등',
	`preferred_airline`	VARCHAR(10)	NULL	DEFAULT NULL	COMMENT '선호하는 항공사 코드(KE, OZ 등)',
	`preferred_seat_class`	VARCHAR(10)	NULL	DEFAULT 'ECONOMY'	COMMENT 'ECONOMY / BUSINESS / FIRST',
	`nickname`	VARCHAR(30)	NULL	DEFAULT NULL	COMMENT '서비스 표시용 별명',
	`profile_image`	VARCHAR(255)	NULL	DEFAULT NULL	COMMENT '이미지 URL',
	`account_status`	VARCHAR(20)	NOT NULL	DEFAULT 'ACTIVE'	COMMENT 'ACTIVE / SUSPENDED / WITHDRAWN',
	`withdrawal_reason`	VARCHAR(255)	NULL	DEFAULT NULL	COMMENT '회원 탈퇴 시 입력값',
	PRIMARY KEY (`user_id`)
);
ALTER TABLE `USER` ADD CONSTRAINT `CHK_USER_GENDER` CHECK (`gender` IN ('M', 'W'));
ALTER TABLE `USER` ADD CONSTRAINT `CHK_PREFERRED_SEAT_CLASS` CHECK (`preferred_seat_class` IN ('ECONOMY', 'BUSINESS', 'FIRST'));
ALTER TABLE `USER` ADD CONSTRAINT `CHK_ACCOUNT_STATUS` CHECK (`account_status` IN ('ACTIVE', 'SUSPENDED', 'WITHDRAWN'));

-- Corrected DDL for PASSENGER
DROP TABLE IF EXISTS `PASSENGER`;
CREATE TABLE `PASSENGER` (
	`passenger_id`	BIGINT	NOT NULL	COMMENT '탑승자 고유 식별자 (PK)',
	`english_name`	VARCHAR(100)	NULL	DEFAULT NULL	COMMENT '여권 영문명',
	`passport_number`	VARCHAR(20)	NULL	DEFAULT NULL	COMMENT '여권 번호',
	`nationality`	CHAR(2)	NULL	DEFAULT NULL	COMMENT '국적 (국가 FK)',
	`birth_date`	DATE	NULL	DEFAULT NULL	COMMENT '탑승자 생년월일',
	`gender`	CHAR(1)	NULL	DEFAULT NULL	COMMENT '성별', -- Changed from ENUM
	`user_id`	BIGINT	NOT NULL	COMMENT '회원ID (FK)',
	PRIMARY KEY (`passenger_id`)
);
ALTER TABLE `PASSENGER` ADD CONSTRAINT `CHK_PASSENGER_GENDER` CHECK (`gender` IN ('M', 'F', 'U'));

-- Corrected DDL for RESERVATION
DROP TABLE IF EXISTS `RESERVATION`;
CREATE TABLE `RESERVATION` (
	`reservation_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '예약 고유 식별자',
	`flight_info_id`	BIGINT	NOT NULL	COMMENT '운항정보(FK)',
	`booker_info`	VARCHAR(255)	NULL	DEFAULT NULL	COMMENT '예약 당시 예약자 스냅샷 데이터',
	`fare_amount`	DECIMAL(12,2)	NULL	DEFAULT 0.00	COMMENT '기본 운임 금액',
	`taxes`	DECIMAL(12,2)	NULL	DEFAULT 0.00	COMMENT '공항세/유류할증료/발권수수료 총합',
	`reservation_status`	VARCHAR(20)	NOT NULL	DEFAULT 'BOOKED'	COMMENT 'BOOKED / TICKETED / CANCELED',
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP	COMMENT '예약 생성 시간',
	`pnr`	VARCHAR(20)	NOT NULL	COMMENT '항공사 예약번호 16자리 (1400822706909208)',
	`trip_type`	VARCHAR(10)	NOT NULL	DEFAULT 'ONE_WAY'	COMMENT 'ONE_WAY / ROUND / MULTI',
	`user_id`	BIGINT	NOT NULL	COMMENT '회원ID (FK)',
	PRIMARY KEY (`reservation_id`)
);
ALTER TABLE `RESERVATION` ADD CONSTRAINT `CHK_RESERVATION_STATUS` CHECK (`reservation_status` IN ('BOOKED', 'TICKETED', 'CANCELED'));
ALTER TABLE `RESERVATION` ADD CONSTRAINT `CHK_TRIP_TYPE` CHECK (`trip_type` IN ('ONE_WAY', 'ROUND', 'MULTI'));

-- Corrected DDL for RESERVATION_PASSENGER
DROP TABLE IF EXISTS `RESERVATION_PASSENGER`;
CREATE TABLE `RESERVATION_PASSENGER` (
	`reservation_id`	BIGINT	NOT NULL	COMMENT '예약 고유 식별자 (FK)',
	`passenger_id`	BIGINT	NOT NULL	COMMENT '탑승자 고유 식별자 (FK)',
	PRIMARY KEY (`reservation_id`, `passenger_id`)
);

-- Corrected DDL for TICKET
DROP TABLE IF EXISTS `TICKET`;
CREATE TABLE `TICKET` (
	`ticket_number`	VARCHAR(20)	NOT NULL	COMMENT '전자티켓 번호(806-0000001067)',
	`reservation_id`	BIGINT	NOT NULL	COMMENT '예약 고유 식별자 (FK)',
	`issued_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP	COMMENT '발권 일시',
	`passenger_id`	BIGINT	NOT NULL	COMMENT '탑승객 (FK)', -- Corrected column name and added FK
	`flight_info_id`	BIGINT	NOT NULL	COMMENT '구간정보 (FK)', -- Corrected column name and added FK
	`ticket_status`	VARCHAR(20)	NOT NULL	DEFAULT 'ISSUED'	COMMENT 'ISSUED / CANCELLED 등',
	PRIMARY KEY (`ticket_number`)
);
ALTER TABLE `TICKET` ADD CONSTRAINT `CHK_TICKET_STATUS` CHECK (`ticket_status` IN ('ISSUED', 'CANCELLED'));

-- Corrected DDL for CANCEL_LOG
DROP TABLE IF EXISTS `CANCEL_LOG`;
CREATE TABLE `CANCEL_LOG` (
	`cancel_log_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT 'PK', -- Corrected typo
	`reservation_id`	BIGINT	NOT NULL	COMMENT '예약 고유 식별자 (FK)',
	`cancelled_at`	DATETIME	NOT NULL	COMMENT '취소 일시',
	`refundable`	TINYINT(1)	NOT NULL	COMMENT '환불 가능 여부 (0/1)',
	`refund_amount`	INT	NOT NULL	COMMENT '환불 금액',
	PRIMARY KEY (`cancel_log_id`)
);

-- Corrected DDL for CATEGORY
DROP TABLE IF EXISTS `CATEGORY`;
CREATE TABLE `CATEGORY` (
	`category_id`	INT	NOT NULL AUTO_INCREMENT	COMMENT '문의 유형 고유 ID',
	`category_title`	VARCHAR(50)	NOT NULL	COMMENT '문의 카테고리명 (예: 결제, 예약변경, 환불 등)',
	PRIMARY KEY (`category_id`)
);

-- Corrected DDL for CUSTOMER_SUPPORT
DROP TABLE IF EXISTS `CUSTOMER_SUPPORT`;
CREATE TABLE `CUSTOMER_SUPPORT` (
	`support_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '문의 고유 식별자', -- Corrected typo
	`user_id`	BIGINT	NOT NULL	COMMENT '회원ID (FK)',
	`question_content`	TEXT	NOT NULL	COMMENT '회원이 작성한 문의 상세 내용',
	`question_status`	VARCHAR(20)	NOT NULL	DEFAULT 'PENDING'	COMMENT '문의 처리 상태 (PENDING / IN_PROGRESS / COMPLETED)',
	`category_id`	INT	NOT NULL	COMMENT '문의 종류 코드 (FK → SUPPORT_CATEGORY.category_id)',
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT CURRENT_TIMESTAMP	COMMENT '문의 접수 일시',
	`updated_at`	TIMESTAMP	NULL	DEFAULT NULL	COMMENT '문의/답변 수정 일시',
	PRIMARY KEY (`support_id`)
);
ALTER TABLE `CUSTOMER_SUPPORT` ADD CONSTRAINT `CHK_QUESTION_STATUS` CHECK (`question_status` IN ('PENDING', 'IN_PROGRESS', 'COMPLETED'));

-- Corrected DDL for ADMIN
DROP TABLE IF EXISTS `ADMIN`;
CREATE TABLE `ADMIN` (
	`admin_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '관리자 고유 식별자',
	`admin_login_id`	VARCHAR(50)	NOT NULL	COMMENT '관리자 계정 ID', -- Removed UNIQUE recommendation
	`admin_password`	VARCHAR(255)	NOT NULL	COMMENT '해시된 비밀번호 (암호화 저장)',
	PRIMARY KEY (`admin_id`)
);

-- Corrected DDL for REPLY
DROP TABLE IF EXISTS `REPLY`;
CREATE TABLE `REPLY` (
	`reply_id`	BIGINT	NOT NULL AUTO_INCREMENT	COMMENT '답변 고유 식별자',
	`reply_content`	TEXT	NOT NULL	COMMENT '상담원이 작성한 답변 텍스트',
	`replied_at`	TIMESTAMP	NOT NULL	DEFAULT CURRENT_TIMESTAMP	COMMENT '답변 작성 시간',
	`updated_at`	TIMESTAMP	NULL	DEFAULT NULL	COMMENT '답변이 수정된 시간',
	`support_id`	BIGINT	NOT NULL	COMMENT 'CUSTOMER_SUPPORT.support_id FK', -- Corrected FK reference
	`admin_id`	BIGINT	NOT NULL	COMMENT '답변 작성한 관리자 ID (ADMIN 테이블 FK)',
	PRIMARY KEY (`reply_id`)
);

-- Corrected DDL for PROVIDER_INFO
DROP TABLE IF EXISTS `PROVIDER_INFO`;
CREATE TABLE `PROVIDER_INFO` (
	`business_number`	CHAR(10)	NOT NULL	COMMENT '숫자 10자리 사업자 등록번호',
	`provider_info`	VARCHAR(255)	NULL	DEFAULT NULL	COMMENT '상세 설명 또는 간단한 소개',
	`provider_name`	VARCHAR(100)	NOT NULL	COMMENT '회사 또는 공급사 이름',
	`settlement_account`	VARCHAR(30)	NULL	DEFAULT NULL	COMMENT '정산 입금 계좌번호',
	`contact`	VARCHAR(20)	NULL	DEFAULT NULL	COMMENT '대표 연락처(전화번호)',
	`service_type`	VARCHAR(30)	NULL	DEFAULT NULL	COMMENT '항공, 호텔, 투어, 보험 등 제공 서비스 종류',
	PRIMARY KEY (`business_number`)
);

-- Corrected DDL for FAVORITE
DROP TABLE IF EXISTS `FAVORITE`;
CREATE TABLE `FAVORITE` (
	`airport_id`	CHAR(3)	NOT NULL	COMMENT '공항 IATA 코드 (FK → AIRPORT.airport_id)',
	`user_id`	BIGINT	NOT NULL	COMMENT '회원 고유 ID (FK → USER.user_id)',
	PRIMARY KEY (`airport_id`, `user_id`)
);

-- Corrected DDL for AIR_ALLIANCE
DROP TABLE IF EXISTS `AIR_ALLIANCE`;
CREATE TABLE `AIR_ALLIANCE` (
	`alliance_id`	VARCHAR(10)	NOT NULL	COMMENT 'STAR / SKYTEAM / ONEWORLD 등의 코드',
	`airline_id`	CHAR(2)	NOT NULL	COMMENT '항공사 코드 (FK → AIRLINE.airline_id)', -- Corrected type
	`alliance_name`	VARCHAR(50)	NULL	COMMENT '동맹 이름 (예: Star Alliance)',
	PRIMARY KEY (`alliance_id`)
);


-- =======================================================================
-- 2. Foreign Key Constraints
-- =======================================================================

ALTER TABLE `CITY` ADD CONSTRAINT `FK_COUNTRY_TO_CITY_1` FOREIGN KEY (`country_id`) REFERENCES `COUNTRY` (`country_id`);
ALTER TABLE `AIRPORT` ADD CONSTRAINT `FK_CITY_TO_AIRPORT_1` FOREIGN KEY (`city_id`) REFERENCES `CITY` (`city_id`);
ALTER TABLE `AIRLINE_AIRCRAFT` ADD CONSTRAINT `FK_AIRCRAFT_TO_AIRLINE_AIRCRAFT_1` FOREIGN KEY (`aircraft_id`) REFERENCES `AIRCRAFT` (`aircraft_id`);
ALTER TABLE `AIRLINE_AIRCRAFT` ADD CONSTRAINT `FK_AIRLINE_TO_AIRLINE_AIRCRAFT_1` FOREIGN KEY (`airline_id`) REFERENCES `AIRLINE` (`airline_id`);
ALTER TABLE `FLIGHT_INFO` ADD CONSTRAINT `FK_AIRPORT_TO_FLIGHT_INFO_1` FOREIGN KEY (`origin_airport_id`) REFERENCES `AIRPORT` (`airport_id`);
ALTER TABLE `FLIGHT_INFO` ADD CONSTRAINT `FK_AIRPORT_TO_FLIGHT_INFO_2` FOREIGN KEY (`destination_airport_id`) REFERENCES `AIRPORT` (`airport_id`);
ALTER TABLE `FLIGHT_INFO` ADD CONSTRAINT `FK_AIRLINE_AIRCRAFT_TO_FLIGHT_INFO_1` FOREIGN KEY (`airline_aircraft_id`) REFERENCES `AIRLINE_AIRCRAFT` (`airline_aircraft_id`);
ALTER TABLE `PASSENGER` ADD CONSTRAINT `FK_USER_TO_PASSENGER_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`);
ALTER TABLE `RESERVATION` ADD CONSTRAINT `FK_FLIGHT_INFO_TO_RESERVATION_1` FOREIGN KEY (`flight_info_id`) REFERENCES `FLIGHT_INFO` (`flight_info_id`);
ALTER TABLE `RESERVATION` ADD CONSTRAINT `FK_USER_TO_RESERVATION_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`);
ALTER TABLE `RESERVATION_PASSENGER` ADD CONSTRAINT `FK_RESERVATION_TO_RESERVATION_PASSENGER_1` FOREIGN KEY (`reservation_id`) REFERENCES `RESERVATION` (`reservation_id`);
ALTER TABLE `RESERVATION_PASSENGER` ADD CONSTRAINT `FK_PASSENGER_TO_RESERVATION_PASSENGER_1` FOREIGN KEY (`passenger_id`) REFERENCES `PASSENGER` (`passenger_id`);
ALTER TABLE `TICKET` ADD CONSTRAINT `FK_RESERVATION_TO_TICKET_1` FOREIGN KEY (`reservation_id`) REFERENCES `RESERVATION` (`reservation_id`);
ALTER TABLE `TICKET` ADD CONSTRAINT `FK_PASSENGER_TO_TICKET_1` FOREIGN KEY (`passenger_id`) REFERENCES `PASSENGER` (`passenger_id`);
ALTER TABLE `TICKET` ADD CONSTRAINT `FK_FLIGHT_INFO_TO_TICKET_1` FOREIGN KEY (`flight_info_id`) REFERENCES `FLIGHT_INFO` (`flight_info_id`);
ALTER TABLE `CANCEL_LOG` ADD CONSTRAINT `FK_RESERVATION_TO_CANCEL_LOG_1` FOREIGN KEY (`reservation_id`) REFERENCES `RESERVATION` (`reservation_id`);
ALTER TABLE `CUSTOMER_SUPPORT` ADD CONSTRAINT `FK_USER_TO_CUSTOMER_SUPPORT_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`);
ALTER TABLE `CUSTOMER_SUPPORT` ADD CONSTRAINT `FK_CATEGORY_TO_CUSTOMER_SUPPORT_1` FOREIGN KEY (`category_id`) REFERENCES `CATEGORY` (`category_id`);
ALTER TABLE `REPLY` ADD CONSTRAINT `FK_CUSTOMER_SUPPORT_TO_REPLY_1` FOREIGN KEY (`support_id`) REFERENCES `CUSTOMER_SUPPORT` (`support_id`);
ALTER TABLE `REPLY` ADD CONSTRAINT `FK_ADMIN_TO_REPLY_1` FOREIGN KEY (`admin_id`) REFERENCES `ADMIN` (`admin_id`);
ALTER TABLE `FAVORITE` ADD CONSTRAINT `FK_AIRPORT_TO_FAVORITE_1` FOREIGN KEY (`airport_id`) REFERENCES `AIRPORT` (`airport_id`);
ALTER TABLE `FAVORITE` ADD CONSTRAINT `FK_USER_TO_FAVORITE_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`);
ALTER TABLE `USER` ADD CONSTRAINT `FK_CITY_TO_USER_1` FOREIGN KEY (`city_id`) REFERENCES `CITY` (`city_id`);
ALTER TABLE `AIR_ALLIANCE` ADD CONSTRAINT `FK_AIRLINE_TO_AIR_ALLIANCE_1` FOREIGN KEY (`airline_id`) REFERENCES `AIRLINE` (`airline_id`);


-- =======================================================================
-- 3. Sample Data
-- =======================================================================

-- Sample Data for COUNTRY
INSERT INTO `COUNTRY` (`country_id`, `country_name`) VALUES
('KR', '대한민국'),
('US', '미국'),
('JP', '일본'),
('CN', '중국');

-- Sample Data for CITY
INSERT INTO `CITY` (`city_id`, `country_id`, `city_name`) VALUES
('SEL', 'KR', '서울'),
('PUS', 'KR', '부산'),
('TYO', 'JP', '도쿄'),
('NYC', 'US', '뉴욕'),
('LAX', 'US', '로스앤젤레스'),
('BJS', 'CN', '베이징');

-- Sample Data for AIRPORT
INSERT INTO `AIRPORT` (`airport_id`, `city_id`, `airport_name`) VALUES
('ICN', 'SEL', '인천국제공항'),
('GMP', 'SEL', '김포국제공항'),
('NRT', 'TYO', '나리타국제공항'),
('HND', 'TYO', '하네다국제공항'),
('JFK', 'NYC', '존 F. 케네디 국제공항'),
('LAX', 'LAX', '로스앤젤레스 국제공항');

-- Sample Data for AIRLINE
ALTER TABLE AIRLINE ADD COLUMN airline_category VARCHAR(3) NOT NULL;
INSERT INTO `AIRLINE` (`airline_id`, `airline_name`, airline_category) VALUES
('KE', '대한항공','FSC'),
('OZ', '아시아나항공','FSC'),
('JL', '일본항공','FSC'),
('NH', '전일본공수','FSC'),
('7C', '제주항공', 'LCC'),
('LJ', '진에어', 'LCC'),
('TW', '티웨이항공', 'LCC'),
('BX', '에어부산', 'LCC'),
('RS', '에어서울', 'LCC'),
('ZE', '이스타항공', 'LCC'),
('MM', '피치항공', 'LCC'),
('JW', '제트스타 재팬', 'LCC'),
('GK', 'Spring Japan', 'LCC'),
('AA', '아메리칸항공', 'FSC'),
('DL', '델타항공', 'FSC'),
('UA', '유나이티드항공', 'FSC'),
('HA', '하와이안항공', 'FSC'),
('AS', '알래스카항공', 'FSC'),
('B6', '젯블루항공', 'LCC'),
('F9', '프론티어항공', 'LCC'),
('NK', '스피릿항공', 'LCC'),
('G4', '얼리전트항공', 'LCC'),
('CA', '중국국제항공 (Air China)', 'FSC'),
('MU', '중국동방항공 (China Eastern)', 'FSC'),
('CZ', '중국남방항공 (China Southern)', 'FSC'),
('9C', '스프링항공', 'LCC'),
('HO', '준야오항공', 'LCC'),
('SQ', '싱가포르항공', 'FSC'),
('TG', '타이항공', 'FSC'),
('MH', '말레이시아항공', 'FSC'),
('TR', '스쿠트(Scoot)', 'LCC'),
('FD', '타이 에어아시아', 'LCC');

-- Sample Data for AIRCRAFT
INSERT INTO `AIRCRAFT` (`aircraft_id`, `aircraft_name`, `aircraft_type`) VALUES
('B747', 'BOEING 747-400', '대형'),
('B777', 'BOEING 777-300ER', '대형'),
('A380', 'AIRBUS A380-800', '초대형'),
('A320', 'AIRBUS A320-200', '중형');

-- Sample Data for AIRLINE_AIRCRAFT
INSERT INTO `AIRLINE_AIRCRAFT` (`aircraft_id`, `airline_id`) VALUES
('B747', 'KE'),
('B777', 'KE'),
('A380', 'OZ'),
('A320', 'OZ'),
('B777', 'JL'),
('A320', 'NH');

-- Sample Data for USER
INSERT INTO `USER` (`user_id`, `name`, `gender`, `birth_date`, `email`, `phone`, `address`, `residence_country`, `preferred_language`, `preferred_currency`, `preferred_airline`, `preferred_seat_class`, `nickname`, `account_status`) VALUES
(1, '김철수', 'M', '1990-05-15', 'kim.cs@example.com','010-1234-5678', '서울시 강남구', 'KR', 'ko', 'KRW', 'KE', 'ECONOMY', '철수', 'ACTIVE'),
(2, '이영희', 'W', '1988-11-22', 'lee.yh@example.com', '010-9876-5432', '부산시 해운대구', 'KR', 'ko', 'KRW', 'OZ', 'BUSINESS', '영희', 'ACTIVE'),
(3, 'John Doe', 'M', '1985-03-10', 'john.doe@example.com', '001-123-4567', '123 Main St, New York', 'US', 'en', 'USD', NULL, 'FIRST', 'JD', 'ACTIVE');

-- 비밀번호(해시 값) 컬럼 추가
ALTER TABLE `USER`
    ADD COLUMN `password_hash` VARCHAR(255) NULL COMMENT '비밀번호 해시값' AFTER `email`;
-- 유저 비밀번호 Null 값 임시 비밀번호 설정(해시 값 설정)
UPDATE USER
SET password_hash = SHA2('temp1234', 256) -- 임시 비밀번호 temp1234
WHERE password_hash IS NULL;


-- Sample Data for PASSENGER
-- Assuming user_id 1 is Kim Cheol-su, user_id 2 is Lee Young-hee, user_id 3 is John Doe
INSERT INTO `PASSENGER` (`passenger_id`, `english_name`, `passport_number`, `nationality`, `birth_date`, `gender`, `user_id`) VALUES
(1001, 'Kim Cheol Su', 'K12345678', 'KR', '1990-05-15', 'M', 1),
(1002, 'Lee Young Hee', 'L87654321', 'KR', '1988-11-22', 'F', 2),
(1003, 'John Doe', 'US98765432', 'US', '1985-03-10', 'M', 3),
(1004, 'Jane Doe', 'US12345678', 'US', '1987-07-01', 'F', 3);

-- Sample Data for FLIGHT_INFO
-- Assuming airline_aircraft_id 1 is KE B747, 2 is KE B777, 3 is OZ A380
INSERT INTO `FLIGHT_INFO` (`flight_info_id`, `origin_airport_id`, `destination_airport_id`, `airline_aircraft_id`, `departure_time`, `arrival_time`, `flight_time`, `seat_class`, `seat_counts`, `seat_stock`, `tax_structure`, `fuel_surcharge`, `fare_amount`) VALUES
('ICN', 'NRT', 2, '2025-01-01 09:00:00', '2025-01-01 11:30:00', 150, 'ECONOMY', 250, 220, 30000.00, 15000.00, 220000.00),
('ICN', 'NRT', 2, '2025-01-01 09:00:00', '2025-01-01 11:30:00', 150, 'BUSINESS', 40, 35, 50000.00, 20000.00, 520000.00),
('ICN', 'NRT', 2, '2025-01-01 09:00:00', '2025-01-01 11:30:00', 150, 'FIRST', 8, 6, 80000.00, 25000.00, 950000.00),
-- 4~6: ICN -> NRT, OZ A380 (ID=3)
('ICN', 'NRT', 3, '2025-01-01 13:30:00', '2025-01-01 16:00:00', 150, 'ECONOMY', 420, 380, 32000.00, 16000.00, 210000.00),
('ICN', 'NRT', 3, '2025-01-01 13:30:00', '2025-01-01 16:00:00', 150, 'BUSINESS', 60, 52, 52000.00, 21000.00, 510000.00),
('ICN', 'NRT', 3, '2025-01-01 13:30:00', '2025-01-01 16:00:00', 150, 'FIRST', 12, 10, 85000.00, 26000.00, 930000.00),
-- 7~9: GMP -> HND, JL B777 (ID=5)
('GMP', 'HND', 5, '2025-01-02 08:00:00', '2025-01-02 10:20:00', 140, 'ECONOMY', 230, 210, 28000.00, 14000.00, 205000.00),
('GMP', 'HND', 5, '2025-01-02 08:00:00', '2025-01-02 10:20:00', 140, 'BUSINESS', 32, 29, 48000.00, 19000.00, 495000.00),
('GMP', 'HND', 5, '2025-01-02 08:00:00', '2025-01-02 10:20:00', 140, 'FIRST', 6, 5, 78000.00, 24000.00, 910000.00),
-- 10~12: GMP -> HND, NH A320 (ID=6)
('GMP', 'HND', 6, '2025-01-02 18:30:00', '2025-01-02 20:50:00', 140, 'ECONOMY', 150, 140, 27000.00, 13000.00, 195000.00),
('GMP', 'HND', 6, '2025-01-02 18:30:00', '2025-01-02 20:50:00', 140, 'BUSINESS', 20, 18, 47000.00, 18000.00, 480000.00),
('GMP', 'HND', 6, '2025-01-02 18:30:00', '2025-01-02 20:50:00', 140, 'FIRST', 0, 0, 0.00, 0.00, 0.00), -- A320에 FIRST 미운영 예시
-- 13~15: ICN -> JFK, KE B747 (ID=1)
('ICN', 'JFK', 1, '2025-01-03 10:00:00', '2025-01-03 22:30:00', 750, 'ECONOMY', 320, 280, 90000.00, 65000.00, 980000.00),
('ICN', 'JFK', 1, '2025-01-03 10:00:00', '2025-01-03 22:30:00', 750, 'BUSINESS', 50, 45, 120000.00, 70000.00, 2500000.00),
('ICN', 'JFK', 1, '2025-01-03 10:00:00', '2025-01-03 22:30:00', 750, 'FIRST', 12, 10, 150000.00, 80000.00, 4200000.00),
-- 16~18: ICN -> LAX, KE B777 (ID=2)
('ICN', 'LAX', 2, '2025-01-04 15:00:00', '2025-01-04 21:00:00', 720, 'ECONOMY', 280, 250, 88000.00, 60000.00, 930000.00),
('ICN', 'LAX', 2, '2025-01-04 15:00:00', '2025-01-04 21:00:00', 720, 'BUSINESS', 40, 36, 118000.00, 65000.00, 2400000.00),
('ICN', 'LAX', 2, '2025-01-04 15:00:00', '2025-01-04 21:00:00', 720, 'FIRST', 8, 7, 148000.00, 75000.00, 4000000.00),
-- 19~21: NRT -> LAX, JL B777 (ID=5)
('NRT', 'LAX', 5, '2025-01-05 17:00:00', '2025-01-05 09:30:00', 660, 'ECONOMY', 260, 230, 87000.00, 58000.00, 910000.00),
('NRT', 'LAX', 5, '2025-01-05 17:00:00', '2025-01-05 09:30:00', 660, 'BUSINESS', 36, 32, 117000.00, 63000.00, 2350000.00),
('NRT', 'LAX', 5, '2025-01-05 17:00:00', '2025-01-05 09:30:00', 660, 'FIRST', 10, 9, 147000.00, 72000.00, 3950000.00),
-- 22~24: HND -> ICN, NH A320 (ID=6)
('HND', 'ICN', 6, '2025-01-06 07:30:00', '2025-01-06 09:50:00', 140, 'ECONOMY', 150, 130, 26000.00, 12000.00, 185000.00),
('HND', 'ICN', 6, '2025-01-06 07:30:00', '2025-01-06 09:50:00', 140, 'BUSINESS', 20, 18, 46000.00, 17000.00, 470000.00),
('HND', 'ICN', 6, '2025-01-06 07:30:00', '2025-01-06 09:50:00', 140, 'FIRST', 0, 0, 0.00, 0.00, 0.00),
-- 25~27: ICN -> GMP, 국내선 테스트, KE B747 (ID=1) - (예시용 비현실 설정)
('ICN', 'GMP', 1, '2025-01-07 08:00:00', '2025-01-07 09:00:00', 60, 'ECONOMY', 300, 260, 10000.00, 5000.00, 80000.00),
('ICN', 'GMP', 1, '2025-01-07 08:00:00', '2025-01-07 09:00:00', 60, 'BUSINESS', 30, 26, 15000.00, 7000.00, 200000.00),
('ICN', 'GMP', 1, '2025-01-07 08:00:00', '2025-01-07 09:00:00', 60, 'FIRST', 8, 7, 20000.00, 9000.00, 350000.00),
-- 28~30: LAX -> ICN, OZ A380 (ID=3) 리턴편
('LAX', 'ICN', 3, '2025-01-08 23:00:00', '2025-01-09 05:30:00', 690, 'ECONOMY', 420, 380, 90000.00, 64000.00, 970000.00),
('LAX', 'ICN', 3, '2025-01-08 23:00:00', '2025-01-09 05:30:00', 690, 'BUSINESS', 60, 54, 120000.00, 69000.00, 2450000.00),
('LAX', 'ICN', 3, '2025-01-08 23:00:00', '2025-01-09 05:30:00', 690, 'FIRST', 12, 11, 150000.00, 78000.00, 4100000.00);
-- Sample Data for RESERVATION
-- Assuming user_id 1 (Kim Cheol-su) makes a reservation for flight_info_id 1
INSERT INTO `RESERVATION` (`reservation_id`, `flight_info_id`, `booker_info`, `fare_amount`, `taxes`, `reservation_status`, `created_at`, `pnr`, `trip_type`, `user_id`) VALUES
(1, 1, '{"name": "김철수", "email": "kim.cs@example.com"}', 150000.00, 30000.00, 'BOOKED', '2025-11-17 10:00:00', 'ABCDEF1234567890', 'ONE_WAY', 1),
(2, 3, '{"name": "John Doe", "email": "john.doe@example.com"}', 2000000.00, 150000.00, 'BOOKED', '2025-11-17 11:00:00', 'GHIJKL9876543210', 'ROUND', 3);

-- Sample Data for RESERVATION_PASSENGER
-- Reservation 1 (Kim Cheol-su) for passenger 1001 (Kim Cheol Su)
INSERT INTO `RESERVATION_PASSENGER` (`reservation_id`, `passenger_id`) VALUES
(1, 1001),
(2, 1003),
(2, 1004);

-- Sample Data for CATEGORY
INSERT INTO `CATEGORY` (`category_id`, `category_title`) VALUES
(1, '결제'),
(2, '예약 변경'),
(3, '환불'),
(4, '기타 문의');

-- Sample Data for CUSTOMER_SUPPORT
-- User 1 (Kim Cheol-su) makes a payment inquiry
INSERT INTO `CUSTOMER_SUPPORT` (`support_id`, `user_id`, `question_content`, `question_status`, `category_id`, `created_at`) VALUES
(1, 1, '결제가 완료되지 않았습니다. 확인 부탁드립니다.', 'PENDING', 1, '2025-11-17 12:00:00');

-- Sample Data for ADMIN
INSERT INTO `ADMIN` (`admin_id`, `admin_login_id`, `admin_password`) VALUES
(1, 'admin01', 'hashed_password_admin01'),
(2, 'admin02', 'hashed_password_admin02');

-- Sample Data for REPLY
-- Admin 1 replies to customer support inquiry 1
INSERT INTO `REPLY` (`reply_id`, `reply_content`, `replied_at`, `support_id`, `admin_id`) VALUES
(1, '결제 시스템 오류로 확인되었습니다. 재결제 시도 부탁드립니다.', '2025-11-17 13:00:00', 1, 1);

-- Sample Data for AIR_ALLIANCE
INSERT INTO `AIR_ALLIANCE` (`alliance_id`, `airline_id`, `alliance_name`) VALUES
/*('STAR', 'OZ', 'Star Alliance'),
('SKYTEAM', 'KE', 'SkyTeam'),*/
('ONEWORLD','DL','One World');

-- Sample Data for PRICE_BY_AGE
INSERT INTO PRICE_BY_AGE VALUES
    (1, 100000.00, 75000.00, 10000.00),
    (2, 105000.00, 78750.00, 10500.00),
    (3, 110000.00, 82500.00, 11000.00),
    (4, 115000.00, 86250.00, 11500.00),
    (5, 120000.00, 90000.00, 12000.00),
    (6, 125000.00, 93750.00, 12500.00),
    (7, 130000.00, 97500.00, 13000.00),
    (8, 135000.00, 101250.00, 13500.00),
    (9, 140000.00, 105000.00, 14000.00),
    (10, 145000.00, 108750.00, 14500.00),
    (11, 150000.00, 112500.00, 15000.00),
    (12, 155000.00, 116250.00, 15500.00),
    (13, 160000.00, 120000.00, 16000.00),
    (14, 165000.00, 123750.00, 16500.00),
    (15, 170000.00, 127500.00, 17000.00),
    (16, 175000.00, 131250.00, 17500.00),
    (17, 180000.00, 135000.00, 18000.00),
    (18, 185000.00, 138750.00, 18500.00),
    (19, 190000.00, 142500.00, 19000.00),
    (20, 195000.00, 146250.00, 19500.00),
    (21, 200000.00, 150000.00, 20000.00),
    (22, 205000.00, 153750.00, 20500.00),
    (23, 210000.00, 157500.00, 21000.00),
    (24, 215000.00, 161250.00, 21500.00),
    (25, 220000.00, 165000.00, 22000.00),
    (26, 225000.00, 168750.00, 22500.00),
    (27, 230000.00, 172500.00, 23000.00),
    (28, 235000.00, 176250.00, 23500.00),
    (29, 240000.00, 180000.00, 24000.00),
    (30, 245000.00, 183750.00, 24500.00),
    (31, 250000.00, 187500.00, 25000.00),
    (32, 255000.00, 191250.00, 25500.00),
    (33, 260000.00, 195000.00, 26000.00);
-- =======================================================================
-- 4. INDEX Creation
-- =======================================================================

CREATE INDEX `IDX_USER_EMAIL` ON `USER` (`email`);
CREATE INDEX `IDX_RESERVATION_PNR` ON `RESERVATION` (`pnr`);
CREATE INDEX `IDX_CUSTOMER_SUPPORT_USER_ID` ON `CUSTOMER_SUPPORT` (`user_id`);
CREATE INDEX `IDX_CUSTOMER_SUPPORT_CATEGORY_ID` ON `CUSTOMER_SUPPORT` (`category_id`);
CREATE INDEX `IDX_CUSTOMER_SUPPORT_QUESTION_STATUS` ON `CUSTOMER_SUPPORT` (`question_status`);
CREATE INDEX `IDX_FLIGHT_INFO_ORIGIN_DEST_DEPARTURE` ON `FLIGHT_INFO` (`origin_airport_id`, `destination_airport_id`, `departure_time`);
CREATE INDEX `IDX_TICKET_RESERVATION_ID` ON `TICKET` (`reservation_id`);
CREATE INDEX `IDX_REPLY_SUPPORT_ID` ON `REPLY` (`support_id`);


-- =======================================================================
-- 5. PROCEDURE Creation
-- =======================================================================

DELIMITER //
CREATE PROCEDURE `CreateReservation`(
    IN p_flight_info_id BIGINT,
    IN p_booker_info VARCHAR(255),
    IN p_fare_amount DECIMAL(12,2),
    IN p_taxes DECIMAL(12,2),
    IN p_pnr VARCHAR(20),
    IN p_trip_type VARCHAR(10),
    IN p_user_id BIGINT,
    IN p_passenger_ids VARCHAR(255) -- Comma-separated passenger IDs (e.g., '1001,1002')
)
BEGIN
    DECLARE v_reservation_id BIGINT;
    DECLARE v_seat_stock INT;
    DECLARE v_num_passengers INT;
    DECLARE v_passenger_id_str VARCHAR(255);
    DECLARE v_cur_pos INT DEFAULT 1;
    DECLARE v_comma_pos INT;

    START TRANSACTION;

    -- Get current seat stock
    SELECT seat_stock INTO v_seat_stock FROM `FLIGHT_INFO` WHERE flight_info_id = p_flight_info_id FOR UPDATE;

    -- Calculate number of passengers
    SET v_num_passengers = LENGTH(p_passenger_ids) - LENGTH(REPLACE(p_passenger_ids, ',', '')) + 1;

    IF v_seat_stock >= v_num_passengers THEN
        -- Insert into RESERVATION
        INSERT INTO `RESERVATION` (flight_info_id, booker_info, fare_amount, taxes, reservation_status, pnr, trip_type, user_id)
        VALUES (p_flight_info_id, p_booker_info, p_fare_amount, p_taxes, 'BOOKED', p_pnr, p_trip_type, p_user_id);

        SET v_reservation_id = LAST_INSERT_ID();

        -- Update seat stock
        UPDATE `FLIGHT_INFO` SET seat_stock = v_seat_stock - v_num_passengers WHERE flight_info_id = p_flight_info_id;

        -- Insert into RESERVATION_PASSENGER
        SET @sql = 'INSERT INTO `RESERVATION_PASSENGER` (reservation_id, passenger_id) VALUES ';
        SET p_passenger_ids = CONCAT(p_passenger_ids, ',');
        WHILE (LOCATE(',', p_passenger_ids) > 0) DO
            SET v_comma_pos = LOCATE(',', p_passenger_ids);
            SET v_passenger_id_str = SUBSTRING(p_passenger_ids, 1, v_comma_pos - 1);
            SET @sql = CONCAT(@sql, '(', v_reservation_id, ',', v_passenger_id_str, '),');
            SET p_passenger_ids = SUBSTRING(p_passenger_ids, v_comma_pos + 1);
        END WHILE;
        
        SET @sql = TRIM(TRAILING ',' FROM @sql);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        COMMIT;
        SELECT 'Reservation created successfully' AS message, v_reservation_id AS reservation_id;
    ELSE
        ROLLBACK;
        SELECT 'Not enough seats available' AS message, NULL AS reservation_id;
    END IF;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE `CancelReservation`(
    IN p_reservation_id BIGINT,
    IN p_refundable TINYINT(1),
    IN p_refund_amount INT
)
BEGIN
    DECLARE v_flight_info_id BIGINT;
    DECLARE v_num_passengers INT;
    DECLARE v_current_status VARCHAR(20);

    START TRANSACTION;

    -- Get reservation details
    SELECT flight_info_id, reservation_status INTO v_flight_info_id, v_current_status
    FROM `RESERVATION` WHERE reservation_id = p_reservation_id FOR UPDATE;

    IF v_current_status = 'CANCELED' THEN
        ROLLBACK;
        SELECT 'Reservation already canceled' AS message;
    ELSE
        -- Update reservation status
        UPDATE `RESERVATION` SET reservation_status = 'CANCELED' WHERE reservation_id = p_reservation_id;

        -- Get number of passengers for this reservation
        SELECT COUNT(*) INTO v_num_passengers FROM `RESERVATION_PASSENGER` WHERE reservation_id = p_reservation_id;

        -- Restore seat stock
        UPDATE `FLIGHT_INFO` SET seat_stock = seat_stock + v_num_passengers WHERE flight_info_id = v_flight_info_id;

        -- Log cancellation
        INSERT INTO `CANCEL_LOG` (reservation_id, cancelled_at, refundable, refund_amount)
        VALUES (p_reservation_id, NOW(), p_refundable, p_refund_amount);

        COMMIT;
        SELECT 'Reservation canceled successfully' AS message;
    END IF;
END //
DELIMITER ;


-- =======================================================================
-- 6. TRIGGER Creation
-- =======================================================================

DELIMITER //
CREATE TRIGGER `trg_update_customer_support_updated_at_on_reply_insert`
AFTER INSERT ON `REPLY`
FOR EACH ROW
BEGIN
    UPDATE `CUSTOMER_SUPPORT`
    SET `updated_at` = NOW()
    WHERE `support_id` = NEW.support_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER `trg_update_customer_support_updated_at_on_reply_update`
AFTER UPDATE ON `REPLY`
FOR EACH ROW
BEGIN
    UPDATE `CUSTOMER_SUPPORT`
    SET `updated_at` = NOW()
    WHERE `support_id` = NEW.support_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER `trg_update_customer_support_status_updated_at`
AFTER UPDATE ON `CUSTOMER_SUPPORT`
FOR EACH ROW
BEGIN
    IF OLD.question_status <> NEW.question_status THEN
        UPDATE `CUSTOMER_SUPPORT`
        SET `updated_at` = NOW()
        WHERE `support_id` = NEW.support_id;
    END IF;
END //
DELIMITER ;

select *