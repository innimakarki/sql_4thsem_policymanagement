 -- Create the database
CREATE DATABASE policymanagementt__;
USE policymanagementt__;

-- Create a table for storing students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    course_enrolled VARCHAR(100)
);

-- Create a table for storing policies
CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100),
    policy_description TEXT,
    start_date DATE,
    end_date DATE
);

-- Create a table to store policy violations
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

-- Create a table to store compliance status of students with policies
CREATE TABLE student_compliance (
    student_id INT,
    policy_id INT,
    compliance_status VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    PRIMARY KEY (student_id, policy_id)
);

-- Create a table to store policy updates
CREATE TABLE policy_updates (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT,
    update_date DATE,
    update_description TEXT,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);


-- Insert data into students table
INSERT INTO students (name, age, gender, course_enrolled) VALUES
('John Doe', 20, 'Male', 'Computer Science'),
('Jane Smith', 22, 'Female', 'Mathematics'),
('Emma Brown', 19, 'Female', 'Biology'),
('Liam Johnson', 21, 'Male', 'Literature'),
('Sophia Davis', 23, 'Female', 'Physics');

-- Insert data into policies table
INSERT INTO policies (policy_name, policy_description, start_date, end_date) VALUES
('Attendance Policy', 'Students must attend at least 75% of the classes.', '2023-01-01', '2024-01-01'),
('Fee Payment Policy', 'Students must pay fees by the 10th of each month.', '2023-01-01', '2024-01-01'),
('Behavior Policy', 'Students must behave according to the institution’s code of conduct.', '2023-01-01', '2024-01-01'),
('Academic Integrity Policy', 'Students must maintain academic integrity in all assessments.', '2023-01-01', '2024-01-01'),
('Library Use Policy', 'Students must return library books on time.', '2023-01-01', '2024-01-01');

-- Insert data into policy_violations table
INSERT INTO policy_violations (student_id, policy_id, violation_date, violation_description, penalty) VALUES
(1, 1, '2023-08-10', 'Missed more than 3 classes', 'Warning'),
(2, 2, '2023-07-12', 'Failed to pay fees on time', 'Fine'),
(3, 3, '2023-09-20', 'Disrespecting staff members', 'Suspension'),
(4, 4, '2023-06-30', 'Plagiarism in assignment', 'Expulsion'),
(5, 5, '2023-10-01', 'Late return of library books', 'Fine');

-- Insert data into student_compliance table
INSERT INTO student_compliance (student_id, policy_id, compliance_status) VALUES
(1, 1, 'Compliant'),
(1, 2, 'Non-compliant'),
(2, 3, 'Compliant'),
(3, 4, 'Non-compliant'),
(4, 5, 'Compliant');

-- Insert data into policy_updates table
INSERT INTO policy_updates (policy_id, update_date, update_description) VALUES
(1, '2023-07-01', 'Policy updated to allow online classes attendance.'),
(2, '2023-08-01', 'Fee payment deadline extended by one week.'),
(3, '2023-09-15', 'Policy updated to include virtual conduct guidelines.'),
(4, '2023-06-01', 'Added new section on plagiarism consequences.'),
(5, '2023-05-01', 'New fines imposed for late book returns.');


-- Show all tables
SHOW TABLES;

-- Describe students table
DESCRIBE students;

-- Describe policies table
DESCRIBE policies;

-- Describe policy_violations table
DESCRIBE policy_violations;

-- Describe student_compliance table
DESCRIBE student_compliance;

-- Describe policy_updates table
DESCRIBE policy_updates;


-- Inner Join: Show students with their policy violations
SELECT students.name, policies.policy_name, policy_violations.violation_description
FROM students
INNER JOIN policy_violations ON students.student_id = policy_violations.student_id
INNER JOIN policies ON policy_violations.policy_id = policies.policy_id;


-- Left Join: Show all students and their compliance status (even if they have no compliance record)
SELECT students.name, policies.policy_name, student_compliance.compliance_status
FROM students
LEFT JOIN student_compliance ON students.student_id = student_compliance.student_id
LEFT JOIN policies ON student_compliance.policy_id = policies.policy_id;


-- Right Join: Show all policies and their updates (including policies with no updates)
SELECT policies.policy_name, policy_updates.update_description
FROM policies
RIGHT JOIN policy_updates ON policies.policy_id = policy_updates.policy_id;


-- Full Outer Join: Show all students and policies, including those with no relation
SELECT students.name, policies.policy_name, student_compliance.compliance_status
FROM students
LEFT JOIN student_compliance ON students.student_id = student_compliance.student_id
LEFT JOIN policies ON student_compliance.policy_id = policies.policy_id

UNION

SELECT students.name, policies.policy_name, student_compliance.compliance_status
FROM students
RIGHT JOIN student_compliance ON students.student_id = student_compliance.student_id
RIGHT JOIN policies ON student_compliance.policy_id = policies.policy_id;


-- Cross Product: Show all combinations of students and policies
SELECT students.name, policies.policy_name
FROM students, policies;


-- Selection: Retrieve all students enrolled in 'Computer Science'
SELECT * FROM students
WHERE course_enrolled = 'Computer Science';


-- Projection: Show only student names and their courses
SELECT name, course_enrolled
FROM students;


--unnormalised table
CREATE TABLE student_policy_details (
    student_id INT,
    student_name VARCHAR(100),
    course_enrolled VARCHAR(255),
    policy_details VARCHAR(255) -- This column contains multiple policy IDs and descriptions.
);

-- Inserting sample data into the unnormalized table
INSERT INTO student_policy_details (student_id, student_name, course_enrolled, policy_details)
VALUES
    (1, 'John Doe', 'Computer Science', '1:Attendance Policy,2:Fee Payment Policy'),
    (2, 'Jane Smith', 'Mathematics', '2:Fee Payment Policy,3:Behavior Policy'),
    (3, 'Emma Brown', 'Biology', '1:Attendance Policy,4:Academic Integrity Policy'),
    (4, 'Liam Johnson', 'Literature', '3:Behavior Policy,5:Library Use Policy'),
    (5, 'Sophia Davis', 'Physics', '1:Attendance Policy,2:Fee Payment Policy,5:Library Use Policy');

-- Convert to 1NF by separating out the multiple policy details into separate rows
CREATE TABLE student_policy_1nf (
    student_id INT,
    student_name VARCHAR(100),
    course_enrolled VARCHAR(255),
    policy_id INT,
    policy_name VARCHAR(100)
);

-- Insert data into 1NF table (splitting policy details into multiple rows)
INSERT INTO student_policy_1nf (student_id, student_name, course_enrolled, policy_id, policy_name)
VALUES
    (1, 'John Doe', 'Computer Science', 1, 'Attendance Policy'),
    (1, 'John Doe', 'Computer Science', 2, 'Fee Payment Policy'),
    (2, 'Jane Smith', 'Mathematics', 2, 'Fee Payment Policy'),
    (2, 'Jane Smith', 'Mathematics', 3, 'Behavior Policy'),
    (3, 'Emma Brown', 'Biology', 1, 'Attendance Policy'),
    (3, 'Emma Brown', 'Biology', 4, 'Academic Integrity Policy'),
    (4, 'Liam Johnson', 'Literature', 3, 'Behavior Policy'),
    (4, 'Liam Johnson', 'Literature', 5, 'Library Use Policy'),
    (5, 'Sophia Davis', 'Physics', 1, 'Attendance Policy'),
    (5, 'Sophia Davis', 'Physics', 2, 'Fee Payment Policy'),
    (5, 'Sophia Davis', 'Physics', 5, 'Library Use Policy');


-- 2NF Create a table for student information (student_id, name, course)
CREATE TABLE students_2nf (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_enrolled VARCHAR(255)
);

-- Insert data into students_2nf table
INSERT INTO students_2nf (student_id, student_name, course_enrolled)
VALUES
    (1, 'John Doe', 'Computer Science'),
    (2, 'Jane Smith', 'Mathematics'),
    (3, 'Emma Brown', 'Biology'),
    (4, 'Liam Johnson', 'Literature'),
    (5, 'Sophia Davis', 'Physics');

-- Create a table for policy details, which will be linked to students
CREATE TABLE student_policies_2nf (
    student_id INT,
    policy_id INT,
    PRIMARY KEY (student_id, policy_id),
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- Insert data into student_policies_2nf table
INSERT INTO student_policies_2nf (student_id, policy_id)
VALUES
    ('1, 1', '1, 2'),
    ('2, 2', '2, 3'),
    ('3, 1', '3, 4'),
    ('4, 3', '4, 5'),
    ('5, 1', '5, 2');


-- We already have a normalized `students_2nf` table and `student_policies_2nf` table.
-- However, to achieve 3NF, we must ensure the policy details are stored in the policies table.

-- Create a policies table (if not created yet)
CREATE TABLE policies (
    policy_id INT PRIMARY KEY,
    policy_name VARCHAR(100),
    policy_description TEXT
);

-- Insert data into the policies table
INSERT INTO policies (policy_id, policy_name, policy_description)
VALUES
    (1, 'Attendance Policy', 'Students must attend at least 75% of the classes.'),
    (2, 'Fee Payment Policy', 'Students must pay fees by the 10th of each month.'),
    (3, 'Behavior Policy', 'Students must adhere to the institution’s code of conduct.'),
    (4, 'Academic Integrity Policy', 'Students must maintain academic integrity in all assessments.'),
    (5, 'Library Use Policy', 'Students must return library books on time.');


SELECT * FROM student_policy_1nf;
SELECT * FROM students_2nf;
SELECT * FROM policies;
SELECT * FROM student_policies_2nf;
SELECT * FROM students_2nf;


DELIMITER $$

CREATE PROCEDURE AddStudent(
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10)
)
BEGIN
    INSERT INTO students_2nf (student_name, age, gender)
    VALUES (p_name, p_age, p_gender);
END$$

DELIMITER ;

CALL AddStudent('Alice Cooper', 22, 'Female');



DELIMITER $$

CREATE PROCEDURE AddStudentAndAssignPolicies(
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_course_enrolled VARCHAR(255),
    IN p_policy_ids TEXT -- A comma-separated list of policy IDs
)
BEGIN
    DECLARE p_student_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE policy_id INT;
    DECLARE policy_cursor CURSOR FOR 
        SELECT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_policy_ids, ',', n.n), ',', -1) AS UNSIGNED)
        FROM (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) n
        WHERE n.n <= (LENGTH(p_policy_ids) - LENGTH(REPLACE(p_policy_ids, ',', '')) + 1);

    -- Start Transaction
    START TRANSACTION;

    -- Insert the new student
    INSERT INTO students_2nf (student_name, age, gender, course_enrolled)
    VALUES (p_name, p_age, p_gender, p_course_enrolled);

    -- Get the student_id of the newly added student
    SET p_student_id = LAST_INSERT_ID();

    -- Loop through each policy ID and insert into the student_policies table
    OPEN policy_cursor;
    read_loop: LOOP
        FETCH policy_cursor INTO policy_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO student_policies_2nf (student_id, policy_id) VALUES (p_student_id, policy_id);
    END LOOP;

    -- Commit the transaction if everything is successful
    COMMIT;

    CLOSE policy_cursor;
END$$

DELIMITER ;

CALL AddStudentAndAssignPoliciesWithRollback('Maria Garcia', 25, 'Female', 'Literature', '2,3,5');




