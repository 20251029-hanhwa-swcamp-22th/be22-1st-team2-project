-- 회원탈퇴
UPDATE USER
SET
    account_status = 'WITHDRAWN',
    withdrawal_reason = '다른 서비스가 더 저렴해서 탈주합니다.',
    nickname = NULL,
    profile_image = NULL
WHERE user_id = 4;

-- 회원탈퇴 2
UPDATE USER
SET
    account_status = 'WITHDRAWN',
    withdrawal_reason = '다른 서비스가 더 저렴해서 탈주합니다.',
    nickname = NULL,
    profile_image = NULL
WHERE user_id = 2;

# 1) 전체 회원 + 계정 상태 조회
SELECT
    user_id,
    name,
    email,
    phone,
    account_status,
    withdrawal_reason
FROM USER
ORDER BY account_status, user_id;

# 2) 현재 서비스 이용 중(ACTIVE) 인 고객만
SELECT
    user_id,
    name,
    email,
    phone,
    account_status
FROM USER
WHERE account_status = 'ACTIVE'
ORDER BY user_id;

# 3) 정지(SUSPENDED) 고객만 (문제 계정 모니터링)
SELECT
    user_id,
    name,
    email,
    phone,
    account_status
FROM USER
WHERE account_status = 'SUSPENDED'
ORDER BY user_id;

# 4) 탈퇴(WITHDRAWN) 회원 + 사유
SELECT
    user_id,
    name,
    email,
    account_status,
    withdrawal_reason
FROM USER
WHERE account_status = 'WITHDRAWN'
ORDER BY user_id;

# 1) 특정 회원을 일시 정지(SUSPENDED) 로 전환
UPDATE USER
SET account_status = 'SUSPENDED'
WHERE user_id = 1;

# 2) 다시 정상(ACTIVE) 으로 복구
UPDATE USER
SET account_status = 'ACTIVE'
WHERE user_id = 4;

# 3) 회원 탈퇴 처리(WITHDRAWN) + 탈퇴 사유 기록
UPDATE USER
SET account_status    = 'WITHDRAWN',
    withdrawal_reason = '장기간 미사용으로 탈퇴 처리(관리자)'
WHERE user_id = 4;

