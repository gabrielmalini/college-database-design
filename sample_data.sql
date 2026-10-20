-- Sample data (fictional) and example queries
USE college_db;

INSERT INTO university (name, contact) VALUES ('Example University', 'admissions@example.ac.uk');
INSERT INTO school (name, head_of_school) VALUES ('School of Computing', 'Dr A. Example');
INSERT INTO campus (name, address) VALUES ('Central Campus', 'London'), ('East Campus', 'London');

INSERT INTO staff (staff_number, first_name, last_name, position, email, campus_id) VALUES
('S001', 'Anita', 'Sharma', 'Lead Lecturer', 'a.sharma@example.ac.uk', 1),
('S002', 'Omar', 'Ali', 'Tutor', 'o.ali@example.ac.uk', 1);

INSERT INTO course (course_code, course_name, level, validating_university_id, school_id)
VALUES ('CS101', 'BSc Computing', 'Level 4', 1, 1);

INSERT INTO course_delivery (course_code, campus_id, start_date, end_date)
VALUES ('CS101', 1, '2025-09-01', '2025-12-15');

INSERT INTO course_delivery_staff (delivery_id, staff_id, role) VALUES (1, 1, 'Lead Lecturer'), (1, 2, 'Tutor');

-- Which staff teach each course delivery, and where?
SELECT c.course_name, ca.name AS campus, cd.start_date,
       CONCAT(s.first_name, ' ', s.last_name) AS staff, cds.role
FROM course_delivery cd
JOIN course c                  ON c.course_code = cd.course_code
JOIN campus ca                 ON ca.campus_id  = cd.campus_id
JOIN course_delivery_staff cds ON cds.delivery_id = cd.delivery_id
JOIN staff s                   ON s.staff_id = cds.staff_id;
