CREATE TABLE students(
    student_id INT GENERATED ALWAYS AS IDENTITY,
    student_name VARCHAR(50) NOT NULL,
    email TEXT,
    join_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT students_student_id_pk PRIMARY KEY (student_id),
    CONSTRAINT students_email_uk UNIQUE (email)
);


CREATE TABLE instructors (
    instructor_id INT GENERATED ALWAYS AS IDENTITY,
    instructor_name VARCHAR(50) NOT NULL,
    expertise VARCHAR(50),
    CONSTRAINT instructors_instructor_id_pk PRIMARY KEY (instructor_id)
);

CREATE TABLE categories(
	CATEGORY_ID INT GENERATED ALWAYS AS IDENTITY,
	CATEGORY_NAME VARCHAR(50) NOT NULL,
	CONSTRAINT categories_CATEGORY_ID_PK PRIMARY KEY(CATEGORY_ID),
	CONSTRAINT categories_CATEGORY_NAME_UK UNIQUE(CATEGORY_NAME)
);

CREATE TABLE courses(
	COURSE_ID INT GENERATED ALWAYS AS IDENTITY,
	COURSE_NAME VARCHAR(100) NOT NULL,
	CATEGORY_ID INT ,
	INSTRUCTOR_ID INT ,
	PRICE NUMERIC(8,2),
	CREATED_DATE DATE DEFAULT CURRENT_DATE,
	CONSTRAINT  courses_COURSE_ID_PK PRIMARY KEY(COURSE_ID),
	CONSTRAINT courses_CATEGORY_ID_FK
			  FOREIGN KEY(CATEGORY_ID)
			  REFERENCES categories(CATEGORY_ID),
	CONSTRAINT courses_INSTRUCTOR_ID_FK
			  FOREIGN KEY(INSTRUCTOR_ID)
			  REFERENCES instructors(INSTRUCTOR_ID)
);


CREATE TABLE enrollments (
    enrollment_id INT GENERATED ALWAYS AS IDENTITY,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    completion_percent INT,

    CONSTRAINT enrollments_enrollment_id_pk
        PRIMARY KEY (enrollment_id),

    CONSTRAINT enrollments_student_id_fk
        FOREIGN KEY (student_id)
        REFERENCES students (student_id),

    CONSTRAINT enrollments_course_id_fk
        FOREIGN KEY (course_id)
        REFERENCES courses (course_id),

    CONSTRAINT enrollments_completion_percent_ck
        CHECK (completion_percent BETWEEN 0 AND 100)
);


CREATE TABLE course_ratings(
	RATING_ID INT GENERATED ALWAYS AS IDENTITY,
	COURSE_ID INT,
	STUDENT_ID INT,
	RATING INT,
	RATING_DATE DATE DEFAULT CURRENT_DATE,
	CONSTRAINT course_ratings_RATING_ID_PK PRIMARY KEY(RATING_ID),
	CONSTRAINT course_ratings_COURSE_ID_FK
			  FOREIGN KEY(COURSE_ID)
			  REFERENCES courses(COURSE_ID),
	CONSTRAINT course_ratings_STUDENT_ID_FK
			  FOREIGN KEY(STUDENT_ID)
			  REFERENCES students(STUDENT_ID),
	CONSTRAINT course_ratings_RATING_CK CHECK(RATING>=1 AND RATING<=5)
);

INSERT INTO students (student_name, email, join_date) VALUES
('Amit Sharma', 'amit@gmail.com', '2024-01-10'),
('Riya Verma', 'riya@gmail.com', '2024-01-15'),
('Karan Singh', 'karan@gmail.com', '2024-02-01'),
('Neha Gupta', 'neha@gmail.com', '2024-02-10'),
('Rahul Mehta', 'rahul@gmail.com', '2024-03-01'),
('Priya Kapoor', 'priya@gmail.com', '2024-03-05'),
('Ankit Jain', 'ankit@gmail.com', '2024-03-10'),
('Sneha Iyer', 'sneha@gmail.com', '2024-03-15');

INSERT INTO instructors (instructor_name, expertise) VALUES
('Suresh Kumar', 'Data Science'),
('Pooja Malhotra', 'Web Development'),
('Rajiv Menon', 'Databases'),
('Ananya Rao', 'Machine Learning');

INSERT INTO categories (category_name) VALUES
('Programming'),
('Data Science'),
('Databases');


INSERT INTO courses (course_name, category_id, instructor_id, price, created_date) VALUES
('Python for Beginners', 1, 1, 2999.00, '2024-01-05'),
('Advanced Java', 1, 2, 3499.00, '2024-01-20'),
('SQL Mastery', 3, 3, 2499.00, '2024-02-01'),
('Data Analysis with Python', 2, 1, 3999.00, '2024-02-10'),
('Machine Learning Basics', 2, 4, 4499.00, '2024-02-20'),
('PostgreSQL Performance Tuning', 3, 3, 2999.00, '2024-03-01');



INSERT INTO enrollments (student_id, course_id, enrollment_date, completion_percent) VALUES
(1, 1, '2024-01-10', 100),
(2, 1, '2024-01-15', 80),
(3, 1, '2024-02-01', 60),

(1, 3, '2024-02-05', 90),
(4, 3, '2024-02-10', 100),
(5, 3, '2024-03-01', 70),

(2, 4, '2024-02-15', 85),
(6, 4, '2024-03-05', 40),

(3, 5, '2024-02-20', 30),
(7, 5, '2024-03-10', 50),

(8, 6, '2024-03-15', 95),
(6, 6, '2024-03-12', 60),
(5, 6, '2024-03-08', 100),
(2, 6, '2024-03-18', 80);




INSERT INTO course_ratings (course_id, student_id, rating, rating_date) VALUES
(1, 1, 5, '2024-02-01'),
(1, 2, 4, '2024-02-05'),
(1, 3, 4, '2024-02-10'),

(3, 1, 5, '2024-02-20'),
(3, 4, 5, '2024-02-25'),
(3, 5, 4, '2024-03-05'),

(4, 2, 4, '2024-03-01'),
(4, 6, 3, '2024-03-10'),

(5, 3, 3, '2024-03-01'),
(5, 7, 4, '2024-03-15'),

(6, 8, 5, '2024-03-20'),
(6, 5, 5, '2024-03-22');

-------------------------------QUERIES------------------
SELECT *
FROM STUDENTS;

SELECT *
FROM INSTURCTORS;

SELECT *
FROM COURSES;

SELECT *
FROM CATEGORIES;

SELECT *
FROM ENROLLMENT;
 
SELECT *
FROM COURSE_RATINGS;



SELECT
    c.course_name,
    COUNT(e.student_id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e
    ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY c.course_name;


SELECT
    s.student_name,
    c.course_name,
    e.completion_percent
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE e.completion_percent < 50
ORDER BY s.student_name;




SELECT
    cat.category_name,
    COUNT(c.course_id) AS total_courses
FROM categories cat
LEFT JOIN courses c
    ON cat.category_id = c.category_id
GROUP BY cat.category_name
ORDER BY cat.category_name;




SELECT
    c.course_name,
    cat.category_name,
    AVG(r.rating) AS avg_rating
FROM courses c
LEFT JOIN categories cat
    ON c.category_id = cat.category_id
LEFT JOIN course_ratings r
    ON c.course_id = r.course_id
GROUP BY
    c.course_name,
    cat.category_name
ORDER BY c.course_name;




SELECT *
FROM (
    SELECT
        s.student_name,
        c.course_name,
        e.completion_percent,
        AVG(e.completion_percent) OVER (
            PARTITION BY e.course_id
        ) AS course_avg_completion
    FROM enrollments e
    JOIN students s
        ON e.student_id = s.student_id
    JOIN courses c
        ON e.course_id = c.course_id
) x
WHERE completion_percent > course_avg_completion;



SELECT
    i.instructor_name,
    AVG(r.rating) AS avg_rating,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) AS instructor_rank
FROM instructors i
JOIN courses c
    ON i.instructor_id = c.instructor_id
JOIN course_ratings r
    ON c.course_id = r.course_id
GROUP BY
    i.instructor_name;


SELECT
    s.student_name,
    COUNT(e.course_id) AS total_courses_enrolled,
    AVG(e.completion_percent) AS average_completion_percent
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
GROUP BY
    s.student_name
HAVING COUNT(e.course_id) > 1;



