-- =============================================================
-- College Course Delivery Database (MySQL 8)
-- Author: Gabriel Malini Rodrigues
-- 01_schema.sql: creates the database and all tables
-- =============================================================

DROP DATABASE IF EXISTS regent_college;
CREATE DATABASE regent_college CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE regent_college;

-- Table: campus
-- Rationale: stores campus locations. campus_id as PK; campus_name must be unique.
CREATE TABLE campus (
  campus_id INT AUTO_INCREMENT PRIMARY KEY,
  campus_name VARCHAR(100) NOT NULL UNIQUE,
  address VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: validating_university
-- Rationale: list of external validating universities for courses.
CREATE TABLE validating_university (
  university_id INT AUTO_INCREMENT PRIMARY KEY,
  university_name VARCHAR(150) NOT NULL UNIQUE,
  country VARCHAR(80),
  contact_email VARCHAR(150)
);

-- Table: school
-- Rationale: academic school/faculty. head_of_school_staff_id is linked to staff below.
CREATE TABLE school (
  school_id INT AUTO_INCREMENT PRIMARY KEY,
  school_name VARCHAR(150) NOT NULL UNIQUE,
  description TEXT,
  head_of_school_staff_id INT NULL
);

-- Table: course
-- Rationale: school_id links to school, validating_university_id links to validating_university.
CREATE TABLE course (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  course_code VARCHAR(20) NOT NULL UNIQUE,
  course_name VARCHAR(200) NOT NULL,
  level ENUM('Undergraduate','Masters','PhD','Diploma','Certificate') NOT NULL,
  duration_months INT NOT NULL,
  school_id INT NOT NULL,
  validating_university_id INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_course_school FOREIGN KEY (school_id) REFERENCES school(school_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_course_univ FOREIGN KEY (validating_university_id) REFERENCES validating_university(university_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: staff
CREATE TABLE staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  staff_number VARCHAR(20) NOT NULL UNIQUE,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  position VARCHAR(120),
  email VARCHAR(150) UNIQUE,
  campus_id INT DEFAULT NULL,
  hired_date DATE,
  CONSTRAINT fk_staff_campus FOREIGN KEY (campus_id) REFERENCES campus(campus_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Head of school must be an existing staff member
ALTER TABLE school
  ADD CONSTRAINT fk_school_head FOREIGN KEY (head_of_school_staff_id)
  REFERENCES staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE;

-- Table: course_delivery
-- Rationale: many deliveries for a course at particular campuses and dates.
CREATE TABLE course_delivery (
  course_delivery_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  campus_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  delivery_mode ENUM('Onsite','Online','Blended') DEFAULT 'Onsite',
  CONSTRAINT fk_cd_course FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cd_campus FOREIGN KEY (campus_id) REFERENCES campus(campus_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table: staff_assignment
-- Rationale: a staff member can teach many course deliveries,
-- and each course delivery can have many staff (many-to-many).
CREATE TABLE staff_assignment (
  assignment_id INT AUTO_INCREMENT PRIMARY KEY,
  staff_id INT NOT NULL,
  course_delivery_id INT NOT NULL,
  role ENUM('Lecturer','Course Lead','Tutor','Assistant') DEFAULT 'Lecturer',
  assigned_date DATE NOT NULL DEFAULT (CURDATE()),
  CONSTRAINT fk_sa_staff FOREIGN KEY (staff_id)
      REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sa_delivery FOREIGN KEY (course_delivery_id)
      REFERENCES course_delivery(course_delivery_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uc_staff_delivery UNIQUE (staff_id, course_delivery_id)
);
