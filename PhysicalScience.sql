-- Drop database and start fresh
DROP DATABASE IF EXISTS PhysicalSciencedb;
CREATE DATABASE PhysicalSciencedb;
USE PhysicalSciencedb;

-- Drop tables in correct order
DROP TABLE IF EXISTS results, CourseRegistrations, courses, lecturers, students, departments, sessions, semesters, SessionSemesters, faculty;

-- Faculty Table
CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_name VARCHAR(100) NOT NULL UNIQUE
);

-- Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
);

-- Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    reg_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other'),
    dept_id INT,
    admission_year YEAR,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Lecturers Table
CREATE TABLE lecturers (
    lecturer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Sessions Table
CREATE TABLE sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_year VARCHAR(9) NOT NULL UNIQUE
);

-- Semesters Table
CREATE TABLE semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    semester_name ENUM('First', 'Second') NOT NULL
);

-- Session Semesters Table
CREATE TABLE SessionSemesters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    semester_id INT NOT NULL,
    UNIQUE(session_id, semester_id),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    course_title VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    lecturer_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id)
);

-- Course Registrations Table
CREATE TABLE CourseRegistrations (
    reg_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    session_id INT NOT NULL,
    semester_id INT NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id),
    UNIQUE (student_id, course_id, session_id, semester_id)
);

-- Results Table
CREATE TABLE results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    reg_id INT NOT NULL,
    score DECIMAL(5,2),
    grade CHAR(2),
    remarks VARCHAR(100),
    FOREIGN KEY (reg_id) REFERENCES CourseRegistrations(reg_id)
);

-- 1. Faculty
INSERT INTO faculty (faculty_name) VALUES
('Faculty of Physical Sciences');

-- 2. Departments
INSERT INTO departments (dept_name, faculty_id) VALUES
('Computer Science', 1),
('Physics', 1),
('Chemistry', 1);

-- 3. Sessions
INSERT INTO sessions (session_year) VALUES
('2023/2024'),
('2024/2025');

-- 4. Semesters
INSERT INTO semesters (semester_name) VALUES
('First'),
('Second');

-- 5. SessionSemesters
INSERT INTO SessionSemesters (session_id, semester_id) VALUES
(1, 1),  -- 2023/2024 First Semester
(1, 2),  -- 2023/2024 Second Semester
(2, 1);  -- 2024/2025 First Semester

-- 6. Lecturers
INSERT INTO lecturers (name, email, dept_id) VALUES
('Dr. Ada Ndu', 'ada.ndu@myuniversity.edu', 1),
('Dr. Musa Bello', 'musa.bello@myuniversity.edu', 2),
('Prof. Chika Okoro', 'chika.okoro@myuniversity.edu', 3);

-- 7. Courses
INSERT INTO courses (course_code, course_title, dept_id, lecturer_id) VALUES
('CSC101', 'Introduction to Computer Science', 1, 1),
('PHY101', 'General Physics I', 2, 2),
('CHM101', 'Introduction to Chemistry', 3, 3);

-- 8. Students
INSERT INTO students (first_name, last_name, reg_number, email, gender, dept_id, admission_year) VALUES
('Ada', 'Obi', 'CS2023001', 'ada.obi@myuniversity.edu', 'Female', 1, 2023),
('Jane', 'Orji', 'PHY2023002', 'jane.orji@myuniversity.edu', 'Female', 2, 2023),
('Mike', 'King', 'CHM2023003', 'mike.king@myuniversity.edu', 'Male', 3, 2023);

-- 9. CourseRegistrations
INSERT INTO CourseRegistrations (student_id, course_id, session_id, semester_id) VALUES
(1, 1, 1, 1),  
(2, 2, 1, 1),  
(3, 3, 1, 1);  

-- 10. Results
INSERT INTO results (reg_id, score, grade, remarks) VALUES
(1, 85.00, 'A', 'Excellent'),
(2, 68.00, 'B', 'Good'),
(3, 74.50, 'B', 'Very Good');
