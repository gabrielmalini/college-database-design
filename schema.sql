-- College Course Delivery Database (MySQL)
-- Author: Gabriel Malini Rodrigues
-- Schema in Third Normal Form (3NF), recreated from the project ERD.

CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

CREATE TABLE university (
    university_id INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(200) NOT NULL,
    address       TEXT,
    contact       VARCHAR(150),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE school (
    school_id      INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(200) NOT NULL,
    head_of_school VARCHAR(150),
    contact        VARCHAR(150),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campus (
    campus_id  INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    address    TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staff (
    staff_id     INT AUTO_INCREMENT PRIMARY KEY,
    staff_number VARCHAR(50) NOT NULL UNIQUE,
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    position     VARCHAR(100),
    email        VARCHAR(150) UNIQUE,
    phone        VARCHAR(30),
    campus_id    INT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campus_id) REFERENCES campus(campus_id)
);

CREATE TABLE course (
    course_code              VARCHAR(20) PRIMARY KEY,
    course_name              VARCHAR(200) NOT NULL,
    level                    VARCHAR(50),
    validating_university_id INT,
    school_id                INT,
    created_at               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (validating_university_id) REFERENCES university(university_id),
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

CREATE TABLE course_delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL,
    campus_id   INT NOT NULL,
    start_date  DATE NOT NULL,
    end_date    DATE,
    notes       TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_code) REFERENCES course(course_code),
    FOREIGN KEY (campus_id) REFERENCES campus(campus_id),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- Associative table: resolves the many-to-many between deliveries and staff
CREATE TABLE course_delivery_staff (
    delivery_id INT NOT NULL,
    staff_id    INT NOT NULL,
    role        VARCHAR(100),
    PRIMARY KEY (delivery_id, staff_id),
    FOREIGN KEY (delivery_id) REFERENCES course_delivery(delivery_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
