-- Deduplicate question_bank by normalized content (strip suffix like "（第N题）").
-- Safe for MySQL 5.7+. Run once on existing data.

CREATE TEMPORARY TABLE tmp_question_keep AS
SELECT
  MIN(id) AS keep_id,
  subject_id,
  TRIM(SUBSTRING_INDEX(content, '（第', 1)) AS norm_content,
  option_a, option_b, option_c, option_d, correct_option
FROM question_bank
GROUP BY subject_id, TRIM(SUBSTRING_INDEX(content, '（第', 1)), option_a, option_b, option_c, option_d, correct_option;

CREATE TEMPORARY TABLE tmp_question_map AS
SELECT
  q.id AS old_id,
  k.keep_id
FROM question_bank q
JOIN tmp_question_keep k
  ON q.subject_id = k.subject_id
 AND TRIM(SUBSTRING_INDEX(q.content, '（第', 1)) = k.norm_content
 AND q.option_a = k.option_a
 AND q.option_b = k.option_b
 AND q.option_c = k.option_c
 AND q.option_d = k.option_d
 AND q.correct_option = k.correct_option;

-- Re-link exam_question to canonical questions.
INSERT IGNORE INTO exam_question(exam_id, question_id)
SELECT eq.exam_id, m.keep_id
FROM exam_question eq
JOIN tmp_question_map m ON eq.question_id = m.old_id;

DELETE eq
FROM exam_question eq
JOIN tmp_question_map m ON eq.question_id = m.old_id
WHERE m.old_id <> m.keep_id;

-- Delete duplicated questions and keep canonical rows.
DELETE q
FROM question_bank q
JOIN tmp_question_map m ON q.id = m.old_id
WHERE m.old_id <> m.keep_id;

DROP TEMPORARY TABLE IF EXISTS tmp_question_map;
DROP TEMPORARY TABLE IF EXISTS tmp_question_keep;
