ALTER TABLE users ADD COLUMN email VARCHAR(100) DEFAULT NULL;

UPDATE users SET email='admin@study.local' WHERE id=1 AND (email IS NULL OR email='');
UPDATE users SET email=CONCAT(username, '@study.local') WHERE role='STUDENT' AND (email IS NULL OR email='');

INSERT IGNORE INTO users(id, username, password, real_name, role, email) VALUES
(7,'stu6','123456','钱八','STUDENT','stu6@study.local'),
(8,'stu7','123456','周九','STUDENT','stu7@study.local'),
(9,'stu8','123456','吴十','STUDENT','stu8@study.local'),
(10,'stu9','123456','郑十一','STUDENT','stu9@study.local'),
(11,'stu10','123456','王十二','STUDENT','stu10@study.local');

INSERT IGNORE INTO exams(id, name, subject_id, total_score, pass_score, start_time, end_time)
SELECT 3000 + (s.id - 1) * 7 + n.seq + 1 AS id,
       CONCAT(s.name, '-阶段测验', n.seq + 1) AS name,
       s.id,
       100 AS total_score,
       60 AS pass_score,
       DATE_ADD('2026-03-03 09:00:00', INTERVAL ((s.id - 1) * 2 + n.seq * 5) DAY) AS start_time,
       DATE_ADD('2026-03-03 11:00:00', INTERVAL ((s.id - 1) * 2 + n.seq * 5) DAY) AS end_time
FROM subjects s
JOIN (
  SELECT 0 seq UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
  SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) n
WHERE s.id BETWEEN 1 AND 5;

INSERT IGNORE INTO student_exam_record(exam_id, student_id, score, is_passed, submit_time)
SELECT e.id AS exam_id,
       u.id AS student_id,
       (35 + ((u.id * 13 + e.id * 7) % 66)) AS score,
       CASE WHEN (35 + ((u.id * 13 + e.id * 7) % 66)) >= 60 THEN 1 ELSE 0 END AS is_passed,
       DATE_ADD(e.end_time, INTERVAL 1 DAY) AS submit_time
FROM exams e
JOIN users u ON u.role='STUDENT' AND u.id BETWEEN 2 AND 11
WHERE e.id BETWEEN 3001 AND 3035;
