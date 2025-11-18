# (1) 전체 문의 목록 (결제/예약 변경/환불/기타 문의)

SELECT
    CS.support_id,
    U.user_id,
    U.name        AS user_name,
    U.email,
    C.category_title AS category,      -- 결제 / 예약 변경 / 환불 / 기타 문의
    CS.question_content,
    CS.question_status,                -- PENDING / IN_PROGRESS / COMPLETED
    CS.created_at,
    CS.updated_at
FROM CUSTOMER_SUPPORT CS
         JOIN USER U     ON CS.user_id = U.user_id
         JOIN CATEGORY C ON CS.category_id = C.category_id
ORDER BY CS.created_at DESC;

# 2) “대기(미처리)” 상태만 보기 (PENDING)

SELECT CS.support_id,
       U.name           AS user_name,
       C.category_title AS category,
       CS.question_content,
       CS.created_at
FROM CUSTOMER_SUPPORT CS
         JOIN USER U ON CS.user_id = U.user_id
         JOIN CATEGORY C ON CS.category_id = C.category_id
WHERE CS.question_status = 'PENDING'
ORDER BY CS.created_at ASC;

# 3) “처리완료” 상태만 보기 (COMPLETED)

SELECT CS.support_id,
       U.name           AS user_name,
       C.category_title AS category,
       CS.question_content,
       CS.created_at
FROM CUSTOMER_SUPPORT CS
         JOIN USER U ON CS.user_id = U.user_id
         JOIN CATEGORY C ON CS.category_id = C.category_id
WHERE CS.question_status = 'COMPLETED'
ORDER BY CS.created_at ASC;


# (1) 문의 1건을 “처리완료”로 변경
UPDATE CUSTOMER_SUPPORT
SET question_status = 'COMPLETED'
WHERE support_id = 8;

# (2) 다시 “대기(PENDING)”로 돌리기 (테스트용)
UPDATE CUSTOMER_SUPPORT
SET question_status = 'PENDING'
WHERE support_id = 1;

