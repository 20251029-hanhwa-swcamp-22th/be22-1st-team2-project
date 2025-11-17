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

