-- 고객은 로그인 비밀번호 및 보안 정보를 변경하여 계정 보안을 강화한다.
UPDATE USER
SET password_hash = SHA2(:newPassword, 256)
WHERE user_id = 4;

-- 회원정보 수정
UPDATE USER
SET
    nickname = 'wjdqudwls',
    gender = 'W',
    birth_date = '1997-04-12',
    phone = '010-7777-8888',
    address = '서울특별시 송파구 올림픽로 240',
    residence_country = 'KR',
    preferred_language = 'KR',
    preferred_currency = 'KRW',
    preferred_airline = 'KE',
    preferred_seat_class = 'ECONOMY',
    preferred_city_id = 'TYO',
    profile_image = '/profile/user4.png',
    account_status = 'ACTIVE'
WHERE user_id = 4;



select user_id,
       nickname,
       gender,
       birth_date,
       phone
from user
WHERE user_id = 4;

SELECT
    profile_image,
    preferred_language,
    preferred_currency,
    preferred_airline,
    preferred_seat_class
FROM USER
WHERE user_id = 4;

-- 회원정보 수정 2
UPDATE USER
SET
    preferred_airline    = 'KE',
    preferred_seat_class = 'FIRST'
WHERE user_id = 4;
