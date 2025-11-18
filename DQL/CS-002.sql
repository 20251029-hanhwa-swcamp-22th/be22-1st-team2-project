-- 로그인
SELECT
    user_id,
    name,
    email,
    account_status
FROM USER
WHERE email = 'wjdqudwls100@gmail.com'
  AND password_hash = SHA2('temp1234', 256)  -- 사용자가 입력한 비밀번호(임시)
  AND account_status = 'ACTIVE';











-- 프로필 확인
SELECT *
FROM USER
WHERE user_id = 4;

-- 탑승객 확인
SELECT *
FROM PASSENGER
WHERE user_id = 4;

-- 예약정보
SELECT *
FROM RESERVATION R
         JOIN FLIGHT_INFO FI ON (R.flight_info_id = FI.flight_info_id)
WHERE user_id = 4;