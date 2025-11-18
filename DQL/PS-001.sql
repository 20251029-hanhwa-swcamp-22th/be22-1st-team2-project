
# 2) 서비스 제공사(프로바이더)가 스스로 등록하는 INSERT 예시
INSERT INTO PROVIDER_INFO (
    business_number,
    provider_name,
    provider_info,
    settlement_account,
    contact,
    service_type,
    approval_status
) VALUES (
             '1234567890',
             'SkyAir Provider',
             '국내/국제선 항공권 실시간 공급사',
             '110-123-456789',
             '02-1234-5678',
             '항공',
             'PENDING'
         );

# 예: 부가서비스(수하물/기내식 등) 제공사
INSERT INTO PROVIDER_INFO (
    business_number,
    provider_name,
    provider_info,
    settlement_account,
    contact,
    service_type,
    approval_status
) VALUES (
             '9876543210',
             'AirExtra Service',
             '항공사 부가서비스 공급 전문 업체',
             '333-222-111111',
             '02-9876-5432',
             '부가서비스',
             'PENDING'
         );

# 3) 관리자의 승인 대기 목록 조회
SELECT
    business_number,
    provider_name,
    contact,
    service_type,
    approval_status,
    provider_info,
    settlement_account
FROM PROVIDER_INFO
WHERE approval_status = 'PENDING'
ORDER BY provider_name ASC;


# (1) 승인(APPROVED)
UPDATE PROVIDER_INFO
SET approval_status = 'APPROVED'
WHERE business_number = '1234567890';

# (2) 거절(REJECTED)
UPDATE PROVIDER_INFO
SET approval_status = 'REJECTED'
WHERE business_number = '9876543210';

#  6) 승인된 공급사만 실제 운항/부가서비스 제공 가능하게 필터링
SELECT *
FROM PROVIDER_INFO
WHERE approval_status = 'APPROVED'
  AND service_type = '항공';



