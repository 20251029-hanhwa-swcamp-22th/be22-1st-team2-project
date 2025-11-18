# “고객이 2025-12-01(월)에 인천(ICN) → 도쿄(나리타 NRT) 편도, 이코노미, 직항, 오전 8시~12시, 성인 2명 + 소아 1명으로 검색한다.”

SELECT * FROM FLIGHT_INFO;

SELECT
    flight_info_id,
    flight_number,
    origin_airport_id,
    destination_airport_id,
    departure_time,
    arrival_time,
    seat_class,
    seat_stock,
    fuel_surcharge
FROM FLIGHT_INFO
WHERE origin_airport_id = 'ICN'
  AND destination_airport_id = 'NRT'
  AND DATE(departure_time) = '2025-12-01'
  AND seat_class = 'ECONOMY'
  AND seat_stock >= 3

  AND TIME(departure_time) BETWEEN '08:00:00' AND '12:00:00';
