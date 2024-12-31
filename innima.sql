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
    policy_id INT,
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
    ('Attendance Policy', 'Students must attend at least 80% of classes.', 'Academic', '2023-08-01', '2024-08-01'),
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


CREATE TABLE unnormalized_table(
    student_id INT,
    name VARCHAR(100),
    policy_name VARCHAR,
    course_enrolled VARCHAR(255), 
);


INSERT INTO unnormalized_table(student_id, student_name,course_enrolled, policy_details)
VALUES

	(1,'John Doe','206:Sam,209:Hit','208:Mathematics major,506:Science'),
	(2,'Innima Karki','380:Wal,111:Gis','447:Differential,780:Computer');



-- Describe the unnormalized_table
DESCRIBE unnormalized_table;

-- Show the unnormalized_policy_management table
SELECT * FROM unnormalized_policy_management;



-- 2nf


CREATE TABLE students_2nf (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
);

-- Create a table for course and policy details
CREATE TABLE course_policy_2nf (
    student_id INT,
    course_enrolled VARCHAR(255),
    policy_name VARCHAR(100),
    policy_description TEXT,
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id)
);

-- Create a table for policies
CREATE TABLE policies_3nf (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100),
    policy_description TEXT
);

-- Create a table for student course and policy relations
CREATE TABLE course_policy_3nf (
    student_id INT,
    course_enrolled VARCHAR(255),
    policy_id INT,
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
    FOREIGN KEY (policy_id) REFERENCES policies_3nf(policy_id)
);

-- Insert data into students_2nf table
INSERT INTO students_2nf (student_id, name)
VALUES
    (1, 'John Doe'),
    (2, 'Jane Smith'),
    (3, 'Emma Brown');
    
    INSERT INTO course_policy_2nf (student_id, course_enrolled, policy_name, policy_description)
VALUES
    (1, 'Mathematics', 'Attendance Policy', 'Must attend 80% of classes'),
    (1, 'Mathematics', 'Fee Payment Policy', 'Pay by 10th of each month'),
    (2, 'History', 'Attendance Policy', 'Must attend 80% of classes'),
    (3, 'Literature', 'Disciplinary Policy', 'Adhere to school rules'),
    (3, 'Mathematics', 'Disciplinary Policy', 'Adhere to school rules');
    
-- Insert data into policies_3nf table
INSERT INTO policies_3nf (policy_name, policy_description)
VALUES
    ('Attendance Policy', 'Must attend 80% of classes'),
    ('Fee Payment Policy', 'Pay by 10th of each month'),
    ('Disciplinary Policy', 'Adhere to school rules');

-- Insert data into course_policy_3nf table
INSERT INTO course_policy_3nf (student_id, course_enrolled, policy_id)
VALUES
    (1, 'Mathematics', 1), -- John Doe with Attendance Policy
    (1, 'Mathematics', 2), -- John Doe with Fee Payment Policy
    (2, 'History', 1), -- Jane Smith with Attendance Policy
    (3, 'Literature', 3), -- Emma Brown with Disciplinary Policy
    (3, 'Mathematics', 3); -- Emma Brown with Disciplinary Policy

-- Show all tables in 3NF
SHOW TABLES;

-- Select data from the students_2nf table (same as in 2NF)
SELECT * FROM students_2nf;

-- Select data from the policies_3nf table
SELECT * FROM policies_3nf;

-- Select data from the course_policy_3nf table
SELECT * FROM course_policy_3nf;


--3nf 
-- Create database and use it
CREATE DATABASE policy_management_3nf_db;
USE policy_management_3nf_db;

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age > 0),
    gender VARCHAR(10),
    enrollment_date DATE NOT NULL,
    course_enrolled VARCHAR(100) NOT NULL
);

-- Create policies table
CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100) NOT NULL UNIQUE,
    policy_description TEXT NOT NULL,
    policy_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK (end_date > start_date)
);

-- Create a junction table for students and policies (resolving many-to-many relationships)
CREATE TABLE student_policies (
    student_id INT NOT NULL,
    policy_id INT NOT NULL,
    compliance_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    violation_report TEXT,
    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (student_id, policy_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id) ON DELETE CASCADE,
    CHECK (compliance_status IN ('Compliant', 'Non-compliant', 'Pending'))
);

-- Create a table for violations (each violation relates to a student and a policy)
CREATE TABLE policy_violations (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    policy_id INT NOT NULL,
    violation_date DATE NOT NULL,
    violation_description TEXT NOT NULL,
    penalty VARCHAR(100) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id) ON DELETE CASCADE
);

-- Create a table for policy updates (each update is tied to a single policy)
CREATE TABLE policy_updates (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT NOT NULL,
    update_date DATE NOT NULL DEFAULT CURRENT_DATE,
    update_description TEXT NOT NULL,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id) ON DELETE CASCADE
);


DELIMITER $$

CREATE PROCEDURE AddStudentAndAssignPolicies(
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_course_enrolled VARCHAR(255),
    IN p_policy_ids TEXT 
)
BEGIN
    DECLARE p_student_id INT;
    DECLARE policy_id INT;

    -- Step 1: Add the student to the `students_2nf` table
    INSERT INTO students_2nf (name, age, gender, course_enrolled)
    VALUES (p_name, p_age, p_gender);

    -- Get the last inserted student ID
    SET p_student_id = LAST_INSERT_ID();

    -- Step 2: Split the policy IDs and assign them to the student
    -- Create a temporary table to store policy IDs
    CREATE TEMPORARY TABLE temp_policy_ids (policy_id INT);

    -- Split the comma-separated list into individual rows
    SET @query = CONCAT(
        'INSERT INTO temp_policy_ids (policy_id) ',
        'SELECT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(''', p_policy_ids, ''', '','', seq), '','', -1) AS UNSIGNED) ',
        'FROM (SELECT 1 AS seq UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) seq ',
        'WHERE seq <= (LENGTH(''', p_policy_ids, ''') - LENGTH(REPLACE(''', p_policy_ids, ''', '','', '''')) + 1)'
    );
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Iterate through the policy IDs and assign each one to the student
    DECLARE done INT DEFAULT 0;
    DECLARE policy_cursor CURSOR FOR SELECT policy_id FROM temp_policy_ids;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN policy_cursor;
    fetch_loop: LOOP
        FETCH policy_cursor INTO policy_id;
        IF done THEN
            LEAVE fetch_loop;
        END IF;

        -- Assign the policy to the student
        INSERT INTO student_policies_2nf (student_id, policy_id)
        VALUES (p_student_id, policy_id);
    END LOOP;
    CLOSE policy_cursor;

    -- Drop the temporary table
    DROP TEMPORARY TABLE temp_policy_ids;
END$$

DELIMITER ;



    -- transaction Process
    START TRANSACTION;

    -- Insert the student
    INSERT INTO students_2nf (student_name, age, gender) 
    VALUES (p_name, p_age, p_gender);
    SET p_student_id = LAST_INSERT_ID();

    -- Open the cursor to iterate through policy IDs
    OPEN policy_cursor;
    read_loop: LOOP
        FETCH policy_cursor INTO policy_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Assign the policy to the student for the course
        INSERT INTO course_policy_3nf (student_id, course_enrolled, policy_id)
        VALUES (p_student_id, p_course_enrolled, policy_id);
    END LOOP;
    CLOSE policy_cursor;

    -- Commit the transaction 
    COMMIT;
END$$

DELIMITER ;
 
 Select *from course_policy_3nf;


- Create database and use it
CREATE DATABASE policy_management_db;
USE policy_management_db;

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age > 0),
    gender VARCHAR(10),
    enrollment_date DATE NOT NULL,
    course_enrolled VARCHAR(100) NOT NULL
);

-- Create policies table
CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(100) NOT NULL UNIQUE,
    policy_description TEXT NOT NULL,
    policy_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK (end_date > start_date)
);

-- Create student_policies table
CREATE TABLE student_policies (
    student_id INT,
    policy_id INT,
    compliance_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    violation_report TEXT,
    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id) ON DELETE CASCADE,
    PRIMARY KEY (student_id, policy_id),
    CHECK (compliance_status IN ('Compliant', 'Non-compliant', 'Pending'))
);

-- Create policy_violations table
CREATE TABLE policy_violations (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    policy_id INT NOT NULL,
    violation_date DATE NOT NULL,
    violation_description TEXT NOT NULL,
    penalty VARCHAR(100) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id) ON DELETE CASCADE
);

-- Create policy_updates table
CREATE TABLE policy_updates (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_id INT NOT NULL,
    update_date DATE NOT NULL DEFAULT CURRENT_DATE,
    update_description TEXT NOT NULL,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id) ON DELETE CASCADE
);

-- Stored procedure for adding a student and assigning policies
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
    DECLARE policy_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET error_occurred = TRUE;
        ROLLBACK;
    END;

    START TRANSACTION;
    
    -- Insert the student
    INSERT INTO students (name, age, gender, enrollment_date, course_enrolled)
    VALUES (p_name, p_age, p_gender, CURRENT_DATE, p_course_enrolled);
    
    SET p_student_id = LAST_INSERT_ID();
    
    -- Create temporary table for policy IDs
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_policy_ids (
        policy_id INT
    );
    
    -- Split and insert policy IDs
    SET @sql = CONCAT('INSERT INTO temp_policy_ids (policy_id) 
                      SELECT CAST(TRIM(value) AS UNSIGNED) 
                      FROM JSON_TABLE(
                          CONCAT(\'["', REPLACE(p_policy_ids, \',\', \'","'), \'"]\'),
                          "$[*]" COLUMNS(value VARCHAR(10) PATH "$")
                      ) AS jt');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Assign policies to student
    INSERT INTO student_policies (student_id, policy_id, compliance_status, assigned_date)
    SELECT p_student_id, policy_id, 'Pending', CURRENT_DATE
    FROM temp_policy_ids
    WHERE EXISTS (SELECT 1 FROM policies p WHERE p.policy_id = temp_policy_ids.policy_id);
    
    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS temp_policy_ids;
    
    IF error_occurred THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An error occurred during the transaction';
    ELSE
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- Sample data insertions
INSERT INTO students (name, age, gender, enrollment_date, course_enrolled)
VALUES
    ('John Doe', 16, 'Male', '2023-08-15', 'Mathematics'),
    ('Jane Smith', 17, 'Female', '2023-08-20', 'Science'),
    ('Emma Brown', 15, 'Female', '2023-07-10', 'History'),
    ('Liam Johnson', 18, 'Male', '2023-09-01', 'Literature');

INSERT INTO policies (policy_name, policy_description, policy_type, start_date, end_date)
VALUES
    ('Attendance Policy', 'Students must attend at least 80% of classes.', 'Academic', '2023-08-01', '2024-08-01'),
    ('Fee Payment Policy', 'Students must pay their fees by the 10th of each month.', 'Financial', '2023-08-01', '2024-08-01'),
    ('Disciplinary Policy', 'Students must adhere to school rules and regulations.', 'Behavioral', '2023-08-01', '2024-08-01');







