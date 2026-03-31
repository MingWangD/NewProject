ALTER TABLE users ADD COLUMN email VARCHAR(100) DEFAULT NULL;
ALTER TABLE exams ADD COLUMN exam_type ENUM('REGULAR','FINAL') NOT NULL DEFAULT 'REGULAR';

UPDATE users SET email='admin@study.local' WHERE id=1 AND (email IS NULL OR email='');
UPDATE users SET email=CONCAT(username, '@study.local') WHERE role='STUDENT' AND (email IS NULL OR email='');
UPDATE subjects SET credit=4;

INSERT IGNORE INTO users(id, username, password, real_name, role, email) VALUES
(7,'stu6','123456','钱八','STUDENT','stu6@study.local'),
(8,'stu7','123456','周九','STUDENT','stu7@study.local'),
(9,'stu8','123456','吴十','STUDENT','stu8@study.local'),
(10,'stu9','123456','郑十一','STUDENT','stu9@study.local'),
(11,'stu10','123456','王十二','STUDENT','stu10@study.local');

INSERT IGNORE INTO exams(id, name, subject_id, total_score, pass_score, start_time, end_time, exam_type)
SELECT 3000 + (s.id - 1) * 7 + n.seq + 1 AS id,
       CONCAT(s.name, '-阶段测验', n.seq + 1) AS name,
       s.id,
       100 AS total_score,
       60 AS pass_score,
       DATE_ADD('2026-03-03 09:00:00', INTERVAL ((s.id - 1) * 2 + n.seq * 5) DAY) AS start_time,
       DATE_ADD('2026-03-03 11:00:00', INTERVAL ((s.id - 1) * 2 + n.seq * 5) DAY) AS end_time,
       'REGULAR' AS exam_type
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

-- 调整样本成绩分层，确保四种风险颜色都有代表
UPDATE student_exam_record SET score = LEAST(100, score + 18) WHERE student_id IN (2, 11);
UPDATE student_exam_record SET score = LEAST(100, score + 8) WHERE student_id IN (3, 9);
UPDATE student_exam_record SET score = GREATEST(20, score - 6) WHERE student_id IN (4, 8);
UPDATE student_exam_record SET score = GREATEST(20, score - 14) WHERE student_id IN (5, 10);
UPDATE student_exam_record SET score = GREATEST(20, score - 24) WHERE student_id IN (6, 7);


-- 按最新分数重算通过状态，避免出现“100分但未通过”
UPDATE student_exam_record
SET is_passed = CASE WHEN score >= 60 THEN 1 ELSE 0 END
WHERE exam_id BETWEEN 3001 AND 3035;

-- 为历史样本补充最小化答题明细（可查看每题选择与正确答案）
INSERT IGNORE INTO exam_question(exam_id, question_id)
SELECT e.id AS exam_id, MIN(q.id) AS question_id
FROM exams e
JOIN question_bank q ON q.subject_id=e.subject_id
WHERE e.id BETWEEN 3001 AND 3035
GROUP BY e.id;

INSERT IGNORE INTO student_answer_record(exam_record_id, question_id, selected_option, is_correct)
SELECT r.id AS exam_record_id,
       eq.question_id,
       CASE
         WHEN r.is_passed = 1 THEN q.correct_option
         WHEN q.correct_option = 'A' THEN 'B'
         ELSE 'A'
       END AS selected_option,
       CASE WHEN r.is_passed = 1 THEN 1 ELSE 0 END AS is_correct
FROM student_exam_record r
JOIN exam_question eq ON eq.exam_id=r.exam_id
JOIN question_bank q ON q.id=eq.question_id
WHERE r.exam_id BETWEEN 3001 AND 3035;


INSERT IGNORE INTO login_attendance(student_id, login_date)
SELECT u.id, DATE_ADD('2026-03-01', INTERVAL d.seq DAY)
FROM users u
JOIN (
  SELECT ones.n + tens.n * 10 AS seq
  FROM (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
  CROSS JOIN
       (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
) d
WHERE u.role='STUDENT'
  AND u.id BETWEEN 2 AND 11
  AND d.seq < 90
  AND MOD(d.seq + u.id, (u.id % 4) + 2) <> 0;
