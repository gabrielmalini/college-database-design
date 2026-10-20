-- =============================================================
-- 02_sample_data.sql: fictional sample data
-- =============================================================
USE regent_college;

INSERT INTO campus (campus_name, address) VALUES
('Edgbaston Campus','Edgbaston Road, Birmingham'),
('City Centre Campus','High Street, Birmingham'),
('North Campus','North Road, Birmingham'),
('South Campus','South Avenue, Birmingham'),
('Online Campus','Remote / Online');

INSERT INTO validating_university (university_name, country, contact_email) VALUES
('University of Birmingham','United Kingdom','partnerships@example.ac.uk'),
('University of Warwick','United Kingdom','partnerships@example.ac.uk'),
('Aston University','United Kingdom','partnerships@example.ac.uk'),
('Coventry University','United Kingdom','partnerships@example.ac.uk'),
('Example International University','USA','info@example.edu');

INSERT INTO school (school_name, description) VALUES
('School of Computing','Computer science and software engineering courses'),
('School of Business','Business, Management and Accounting'),
('School of Health','Healthcare and social care programmes'),
('School of Engineering','Engineering and technology courses'),
('School of Arts','Creative arts and design');

INSERT INTO course (course_code, course_name, level, duration_months, school_id, validating_university_id) VALUES
('CS101','BSc Computer Science','Undergraduate',36, (SELECT school_id FROM school WHERE school_name='School of Computing'), (SELECT university_id FROM validating_university WHERE university_name='University of Birmingham')),
('SE201','MSc Software Engineering','Masters',24, (SELECT school_id FROM school WHERE school_name='School of Computing'), (SELECT university_id FROM validating_university WHERE university_name='University of Warwick')),
('BA101','BSc Business Management','Undergraduate',36, (SELECT school_id FROM school WHERE school_name='School of Business'), (SELECT university_id FROM validating_university WHERE university_name='Aston University')),
('NURS_MA','MSc Nursing','Masters',18, (SELECT school_id FROM school WHERE school_name='School of Health'), (SELECT university_id FROM validating_university WHERE university_name='Coventry University')),
('ENG_DIP','Diploma in Engineering','Diploma',12, (SELECT school_id FROM school WHERE school_name='School of Engineering'), NULL);

INSERT INTO staff (staff_number, first_name, last_name, position, email, campus_id, hired_date) VALUES
('S1001','Alex','Taylor','Lecturer','alex.taylor@example.ac.uk', 1, '2019-08-01'),
('S1002','John','Brown','Senior Lecturer','john.brown@example.ac.uk', 2, '2018-01-15'),
('S1003','Rhea','Patel','Course Lead','rhea.patel@example.ac.uk', 1, '2020-03-20'),
('S1004','Liam','Evans','Administrator','liam.evans@example.ac.uk', 3, '2021-09-01');

-- Course deliveries (one ended in the past)
INSERT INTO course_delivery (course_id, campus_id, start_date, end_date, delivery_mode) VALUES
((SELECT course_id FROM course WHERE course_code='CS101'), 1, '2023-09-01', '2024-06-30', 'Onsite'),
((SELECT course_id FROM course WHERE course_code='SE201'), 2, '2025-02-01', '2025-09-30', 'Blended'),
((SELECT course_id FROM course WHERE course_code='BA101'), 2, '2022-01-10', '2022-12-31', 'Onsite');

INSERT INTO staff_assignment (staff_id, course_delivery_id, role) VALUES
(1, 1, 'Lecturer'),      -- Alex teaches CS101 at Edgbaston
(2, 1, 'Course Lead'),   -- John also teaches CS101
(2, 2, 'Lecturer'),      -- John teaches SE201 at City Centre
(3, 3, 'Tutor'),         -- Rhea teaches BA101 at City Centre
(4, 2, 'Assistant');     -- Liam helps on SE201

-- Set the head of the School of Computing
UPDATE school
SET head_of_school_staff_id = (SELECT staff_id FROM staff WHERE first_name = 'John' AND last_name = 'Brown')
WHERE school_name = 'School of Computing';
