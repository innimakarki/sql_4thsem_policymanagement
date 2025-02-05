-- Create database and use it
CREATE DATABASE policymanagement_____DB;
USE policymanagement_____DB;

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    enrollment_date DATE,
    course_enrolled VARCHAR(100)
);

-- Create policies table
CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100),
    policy_description TEXT,
    policy_type VARCHAR(50),
    start_date DATE,
    end_date DATE
);

-- Create student_policies table
CREATE TABLE student_policies (
    student_id INT,
    policy_id INT,Ω
    compliance_status VARCHAR(20),
    violation_report TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    PRIMARY KEY (student_id, policy_id)
);

-- Create policy_violations table
CREATE TABLE policy_violations (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    policy_id INT,
    violation_date DATE,
    violation_description TEXT,
    penalty VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- Create policy_updates table
CREATE TABLE policy_updates (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT,
    update_date DATE,
    update_description TEXT,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- Insert data into students table
INSERT INTO students (name, age, gender, enrollment_date, course_enrolled)
VALUES
    ('John Doe', 16, 'Male', '2023-08-15', 'Mathematics'),
    ('Jane Smith', 17, 'Female', '2023-08-20', 'Science'),
    ('Emma Brown', 15, 'Female', '2023-07-10', 'History'),
    ('Liam Johnson', 18, 'Male', '2023-09-01', 'Literature');

-- Insert data into policies table
INSERT INTO policies (policy_name, policy_description, policy_type, start_date, end_date)
VALUES
    ('Attendance Policy', 'Student must attend at least 80% of classes.', 'Academic', '2023-08-01', '2024-08-01'),
    ('Fee Payment Policy', 'Students must pay their fees by the 10th of each month.', 'Financial', '2023-08-01', '2024-08-01'),
    ('Disciplinary Policy', 'Students must adhere to school rules and regulations.', 'Behavioral', '2023-08-01', '2024-08-01');

-- Insert data into student_policies table
INSERT INTO student_policies (student_id, policy_id, compliance_status, violation_report)
VALUES
    (1, 1, 'Compliant', NULL),  -- John Doe with Attendance Policy
    (1, 2, 'Compliant', NULL),  -- John Doe with Fee Payment Policy
    (2, 1, 'Non-compliant', 'Missed more than 5 classes'),  -- Jane Smith with Attendance Policy
    (3, 3, 'Compliant', NULL);

-- Insert data into policy_violations table
INSERT INTO policy_violations (student_id, policy_id, violation_date, violation_description, penalty)
VALUES
    (2, 1, '2023-09-15', 'Missed more than 5 classes without a valid reason', 'Warning');

-- Insert data into policy_updates table
INSERT INTO policy_updates (policy_id, update_date, update_description)
VALUES
    (1, '2023-09-10', 'Policy updated to include exemptions for medical leave.');

-- Show all tables
SHOW TABLES;

-- Describe the students table
DESCRIBE students;

-- Describe the policies table
DESCRIBE policies;

-- Describe the student_policies table
DESCRIBE student_policies;

-- Describe the policy_violations table
DESCRIBE policy_violations;

-- Describe the policy_updates table
DESCRIBE policy_updates;


-- Select all data from students
SELECT * FROM students;

-- Select all data from policies
SELECT * FROM policies;

-- Select all data from student_policies
SELECT * FROM student_policies;

-- Select all data from policy_violations
SELECT * FROM policy_violations;

-- Select all data from policy_updates
SELECT * FROM policy_updates;


-- Join students and student_policies to get student compliance details
SELECT students.student_id, students.name, policies.policy_name, student_policies.compliance_status
FROM students
INNER JOIN student_policies ON students.student_id = student_policies.student_id
INNER JOIN policies ON student_policies.policy_id = policies.policy_id;


-- Show all students and their policies (including students without policies)
SELECT students.student_id, students.name, policies.policy_name, student_policies.compliance_status
FROM students
LEFT JOIN student_policies ON students.student_id = student_policies.student_id
LEFT JOIN policies ON student_policies.policy_id = policies.policy_id;


-- Show all policies and the students assigned to them (including policies without students)
SELECT policies.policy_id, policies.policy_name, students.name, student_policies.compliance_status
FROM policies
RIGHT JOIN student_policies ON policies.policy_id = student_policies.policy_id
RIGHT JOIN students ON student_policies.student_id = students.student_id;


-- Show all students and policies, even if they have no relation
SELECT students.student_id, students.name, policies.policy_name, student_policies.compliance_status
FROM students
LEFT JOIN student_policies ON students.student_id = student_policies.student_id
LEFT JOIN policies ON student_policies.policy_id = policies.policy_id

UNION

SELECT students.student_id, students.name, policies.policy_name, student_policies.compliance_status
FROM students
RIGHT JOIN student_policies ON students.student_id = student_policies.student_id
RIGHT JOIN policies ON student_policies.policy_id = policies.policy_id;


-- Cross Product: All combinations of students and policies
SELECT *
FROM students, policies;

-- Selection: Retrieve students enrolled in Mathematics
SELECT *FROM students
WHERE course_enrolled = 'Mathematics';

-- Selection: Retrieve policies of type Academic
SELECT *FROM policies
WHERE policy_type = 'Academic';


-- Projection: Retrieve only student names and their courses
SELECT name, course_enrolled
FROM students;

-- cartesian
SELECT *FROM students,policies; 



-- normalization

CREATE TABLE unnormalized_table (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    policy_name VARCHAR(255), 
    course_enrolled VARCHAR(255)
);



INSERT INTO unnormalized_table(student_id, name, course_enrolled, policy_name)
VALUES
    (1, 'John Doe', '206:Sam,209:Hit', '208:Mathematics major,506:Science'),
    (2, 'Innima Karki', '380:Wal,111:Gis', '447:Differential,780:Computer');



-- Describe the unnormalized_table
DESCRIBE unnormalized_table;

-- Show the unnormalized_policy_management table
SELECT * FROM unnormalized_table;



-- 1nf
CREATE TABLE students_1nf (
    student_id INT,
    name VARCHAR(100),
    course_id INT,
    course_name VARCHAR(100),
    policy_id INT,
    policy_name VARCHAR(255),
    PRIMARY KEY (student_id, course_id, policy_id)
);

INSERT INTO students_1nf (student_id, name, course_id, course_name, policy_id, policy_name)
VALUES
    (1, 'John Doe', 206, 'Sam', 208, 'Mathematics major'),
    (1, 'John Doe', 209, 'Hit', 506, 'Science'),
    (2, 'Innima Karki', 380, 'Wal', 447, 'Differential'),
    (2, 'Innima Karki', 111, 'Gis', 780, 'Computer');

select* from students_1nf;

-- 2nf
-- Create Tables
CREATE TABLE students__2nf (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE courses__2nf (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE policies__2nf (
    policy_id INT PRIMARY KEY,
    policy_name VARCHAR(255)
);

CREATE TABLE student_course_policy__2nf (
    student_id INT,
    course_id INT,
    policy_id INT,
    PRIMARY KEY (student_id, course_id, policy_id),
    FOREIGN KEY (student_id) REFERENCES students__2nf(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_2nf(course_id),
    FOREIGN KEY (policy_id) REFERENCES policies_2nf(policy_id)
); 

-- Insert Data
INSERT INTO students__2nf (student_id, name)
VALUES
    (1, 'John Doe'),
    (2, 'Innima Karki');

INSERT INTO courses__2nf (course_id, course_name)
VALUES
    (206, 'Sam'),
    (209, 'Hit'),
    (380, 'Wal'),
    (111, 'Gis');

INSERT INTO policies__2nf (policy_id, policy_name)
VALUES
    (208, 'Mathematics major'),
    (506, 'Science'),
    (447, 'Differential'),
    (780, 'Computer');

INSERT INTO student_course_policy__2nf (student_id, course_id, policy_id)
VALUES
    (1, 206, 208),
    (1, 209, 506),
    (2, 380, 447),
    (2, 111, 780);

-- show tables
SHOW tables;
SELECT * FROM students__2nf;
SELECT * FROM courses__2nf;
SELECT * FROM policies__2nf;
SELECT * FROM student_course_policy__2nf;


-- 3nf
-- Create a table for policies
CREATE TABLE policies_3nf (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100),
    policy_description TEXT
);

-- Create a table for student course and policy relations
CREATE TABLE course_policy___3nf (
    student_id INT,
    course_enrolled VARCHAR(255),
    policy_id INT,
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
    FOREIGN KEY (policy_id) REFERENCES policies_3nf(policy_id)
);
    
    INSERT INTO policies_3nf (policy_id,policy_name, policy_description)
VALUES
    (3,'Attendance Policy', 'Must attend 80% of classes'),
    (4,'Fee Payment Policy', 'Pay by 10th of each month'),
    (4,'Disciplinary Policy', 'Adhere to school rules');


    INSERT INTO course_policy___3nf (student_id, course_enrolled,policy_id)
VALUES
    (1, 'Mathematics', '1'),
    (1, 'Mathematics', '2'),
    (2, 'History', '3'),
    (3, 'Literature', '2'),
    (3, 'Mathematics', '1');
    
SHOW TABLES;
SELECT * FROM course_policy___3nf;
SELECT * FROM policies_3nf;



-- bcnf

-- Create table for students
CREATE TABLE students_bcnf (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Create table for courses
CREATE TABLE courses_bcnf (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

--  Create table for policies
CREATE TABLE policies_bcnf (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100),
    policy_description TEXT
);

-- Create table mapping students to courses
CREATE TABLE student_courses_bcnf (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students_bcnf(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_bcnf(course_id)
);

-- Create table mapping courses to policies
CREATE TABLE course_policies_bcnf (
    course_id INT,
    policy_id INT,
    PRIMARY KEY (course_id, policy_id),
    FOREIGN KEY (course_id) REFERENCES courses_bcnf(course_id),
    FOREIGN KEY (policy_id) REFERENCES policies_bcnf(policy_id)
);

-- Insert data into students_bcnf
INSERT INTO students_bcnf (student_id, name)
VALUES
    (1, 'John Doe'),
    (2, 'Innima Karki');
    
INSERT INTO courses_bcnf (course_id, course_name)
VALUES
    (206, 'Mathematics'),
    (209, 'Science'),
    (380, 'History'),
    (111, 'Literature');
    
-- Insert data into policies_bcnf
INSERT INTO policies_bcnf (policy_name, policy_description)
VALUES
    ('Attendance Policy', 'Must attend 80% of classes'),
    ('Fee Payment Policy', 'Pay by 10th of each month'),
    ('Disciplinary Policy', 'Adhere to school rules');


-- Insert data into student_courses_bcnf
INSERT INTO student_courses_bcnf (student_id, course_id)
VALUES
    (1, 206),
    (1, 209),
    (2, 380),
    (2, 111);

-- Insert data into course_policies_bcnf
INSERT INTO course_policies_bcnf (course_id, policy_id)
VALUES
    (206, 1),
    (206, 2),
    (209, 3),
    (380, 1),
    (111, 3);

-- Display tables
SHOW TABLES;

-- View data in all tables
SELECT * FROM students_bcnf;
SELECT * FROM courses_bcnf;
SELECT * FROM policies_bcnf;
SELECT * FROM student_courses_bcnf;
SELECT * FROM course_policies_bcnf;














DELIMITER $$

CREATE PROCEDURE AddStudentAndAssignPolicies(
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_course_enrolled VARCHAR(100),
    IN p_policy_ids VARCHAR(255)
)
BEGIN
    DECLARE p_student_id INT;
    DECLARE policy_id VARCHAR(10);
    DECLARE policy_pos INT DEFAULT 0;
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;

    -- Error handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error_occurred = TRUE;
        ROLLBACK;
    END;

    -- Start transaction
    START TRANSACTION;

    -- Insert the student
    INSERT INTO students (name, age, gender, enrollment_date, course_enrolled)
    VALUES (p_name, p_age, p_gender, CURRENT_DATE, p_course_enrolled);

    -- Get the last inserted student ID
    SET p_student_id = LAST_INSERT_ID();

    -- Assign policies to the student
    WHILE LENGTH(p_policy_ids) > 0 DO
        SET policy_pos = LOCATE(',', p_policy_ids);
        
        IF policy_pos > 0 THEN
            SET policy_id = TRIM(SUBSTRING(p_policy_ids, 1, policy_pos - 1));
            SET p_policy_ids = SUBSTRING(p_policy_ids, policy_pos + 1);
        ELSE
            SET policy_id = TRIM(p_policy_ids);
            SET p_policy_ids = '';  -- Ensures exit from loop after last policy
        END IF;

        -- Insert the policy assignment
        IF policy_id REGEXP '^[0-9]+$' THEN
            INSERT INTO student_policies (student_id, policy_id, compliance_status)
            VALUES (p_student_id, CAST(policy_id AS UNSIGNED), 'Pending');
        END IF;
    END WHILE;

    -- Commit transaction
    IF NOT error_occurred THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END$$



DELIMITER ;
CALL AddStudentAndAssignPolicies('Alice Smith', 20, 'Female', 'Mathematics', '201,202,203');

SELECT * FROM students;
SELECT * FROM students ORDER BY student_id DESC;

SELECT * FROM student_policies ORDER BY policy_id DESC;


SHOW ERRORS;

