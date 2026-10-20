-- =============================================================
-- 03_queries.sql: reporting queries, data changes and transactions
-- =============================================================
USE regent_college;

-- All courses with their school and validating university
SELECT c.course_code, c.course_name, c.level, s.school_name, vu.university_name
FROM course c
LEFT JOIN school s ON c.school_id = s.school_id
LEFT JOIN validating_university vu ON c.validating_university_id = vu.university_id;

-- Masters courses validated by the University of Warwick
SELECT c.course_code, c.course_name, s.school_name, vu.university_name
FROM course c
JOIN school s ON c.school_id = s.school_id
JOIN validating_university vu ON c.validating_university_id = vu.university_id
WHERE vu.university_name = 'University of Warwick' AND c.level = 'Masters';

-- Staff working at more than one campus
SELECT s.staff_id, s.first_name, s.last_name,
       COUNT(DISTINCT cd.campus_id) AS campus_count,
       GROUP_CONCAT(DISTINCT cp.campus_name SEPARATOR ', ') AS campuses
FROM staff s
JOIN staff_assignment sa ON s.staff_id = sa.staff_id
JOIN course_delivery cd  ON sa.course_delivery_id = cd.course_delivery_id
JOIN campus cp           ON cd.campus_id = cp.campus_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING COUNT(DISTINCT cd.campus_id) > 1;

-- Q1: All courses offered at a specified campus
SELECT cp.campus_name, c.course_name, c.level, vu.university_name AS validating_university
FROM course_delivery cd
JOIN campus cp ON cd.campus_id = cp.campus_id
JOIN course c  ON cd.course_id = c.course_id
LEFT JOIN validating_university vu ON c.validating_university_id = vu.university_id
WHERE cp.campus_name = 'City Centre Campus';

-- Q2: Number of courses delivered by each school
SELECT s.school_name, COUNT(DISTINCT c.course_id) AS course_count
FROM course c
JOIN school s ON c.school_id = s.school_id
JOIN course_delivery cd ON c.course_id = cd.course_id
GROUP BY s.school_name
ORDER BY course_count DESC;

-- Transaction: add a new delivery and move a staff member's primary campus
START TRANSACTION;
INSERT INTO course_delivery (course_id, campus_id, start_date, end_date, delivery_mode)
VALUES ((SELECT course_id FROM course WHERE course_code='SE201'), 1, '2026-01-05', '2026-07-31', 'Blended');
UPDATE staff SET campus_id = 1 WHERE staff_number = 'S1004';
COMMIT;

-- Q3: Delete all course deliveries that ended before today
SET SQL_SAFE_UPDATES = 0;
DELETE FROM course_delivery WHERE end_date < CURDATE();
SET SQL_SAFE_UPDATES = 1;

-- Q4: Insert a new delivery for an existing course and campus
INSERT INTO course_delivery (course_id, campus_id, start_date, end_date, delivery_mode)
VALUES (
  (SELECT course_id FROM course WHERE course_code = 'CS101'),
  (SELECT campus_id FROM campus WHERE campus_name = 'Online Campus'),
  '2026-03-01', '2026-12-15', 'Online'
);

-- Q5: Transaction: hire new staff, assign them to CS101 and set their campus
START TRANSACTION;

INSERT INTO staff (staff_number, first_name, last_name, position, email, campus_id, hired_date)
VALUES ('S1008','Olivia','Green','Lecturer','olivia.green@example.ac.uk', NULL, '2025-10-13');

INSERT INTO staff_assignment (staff_id, course_delivery_id, role)
VALUES (
  (SELECT staff_id FROM staff WHERE staff_number = 'S1008'),
  (SELECT course_delivery_id FROM course_delivery
     WHERE course_id = (SELECT course_id FROM course WHERE course_code='CS101') LIMIT 1),
  'Lecturer'
);

-- Derived table avoids MySQL error 1093 (updating a table used in its own subquery)
UPDATE staff
SET campus_id = (
  SELECT campus_id FROM (
    SELECT cd.campus_id
    FROM course_delivery cd
    JOIN staff_assignment sa ON cd.course_delivery_id = sa.course_delivery_id
    JOIN staff s2 ON sa.staff_id = s2.staff_id
    WHERE s2.staff_number = 'S1008'
    LIMIT 1
  ) AS temp
)
WHERE staff_number = 'S1008';

COMMIT;

-- Verify
SELECT s.staff_number, s.first_name, s.last_name, cp.campus_name
FROM staff s
LEFT JOIN campus cp ON s.campus_id = cp.campus_id
WHERE s.staff_number = 'S1008';
