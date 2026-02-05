-- 1. CONTESTS: Manage timing and scoreboard freeze 
CREATE TABLE contests (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    freeze_mins INT DEFAULT 60 -- Minutes before end_time to freeze
);

-- 2. USERS: Integration with Cloudflare Auth
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL
);

-- 3. PROBLEMS: Links to PDF and constraints
CREATE TABLE problems (
    id SERIAL PRIMARY KEY,
    contest_id INT REFERENCES contests(id) ON DELETE CASCADE,
    letter_code CHAR(1) NOT NULL, -- e.g., 'A', 'B', 'C' [cite: 10]
    time_limit_ms INT DEFAULT 1000,
    pdf_path TEXT NOT NULL -- Path to /var/lib/judge/data [cite: 7, 10]
);

-- 4. SUBMISSIONS: The core ingestion pipeline [cite: 11, 20]
CREATE TABLE submissions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    problem_id INT REFERENCES problems(id),
    status TEXT DEFAULT 'PENDING', -- PENDING, AC, WA, TLE, RE [cite: 11, 26]
    compiler_log TEXT,
    test_case_fail INT, -- The first test case that failed [cite: 11]
    file_path TEXT NOT NULL, -- Path to /var/lib/judge/src [cite: 7, 11]
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);