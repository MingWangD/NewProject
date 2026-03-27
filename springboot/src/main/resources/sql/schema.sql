CREATE DATABASE IF NOT EXISTS study_warning DEFAULT CHARACTER SET utf8mb4;
USE study_warning;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  real_name VARCHAR(50) NOT NULL,
  role ENUM('ADMIN','STUDENT') NOT NULL,
  total_hours INT NOT NULL DEFAULT 48,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS subjects (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  credit INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS question_bank (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  subject_id BIGINT NOT NULL,
  content VARCHAR(500) NOT NULL,
  option_a VARCHAR(255) NOT NULL,
  option_b VARCHAR(255) NOT NULL,
  option_c VARCHAR(255) NOT NULL,
  option_d VARCHAR(255) NOT NULL,
  correct_option CHAR(1) NOT NULL,
  score INT NOT NULL DEFAULT 5,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_question_subject(subject_id),
  CONSTRAINT fk_question_subject FOREIGN KEY(subject_id) REFERENCES subjects(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exams (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  subject_id BIGINT NOT NULL,
  total_score INT NOT NULL,
  pass_score INT NOT NULL,
  course_hours INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_exam_subject(subject_id),
  CONSTRAINT fk_exam_subject FOREIGN KEY(subject_id) REFERENCES subjects(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exam_question (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  UNIQUE KEY uk_exam_question(exam_id, question_id),
  INDEX idx_eq_exam(exam_id),
  INDEX idx_eq_question(question_id),
  CONSTRAINT fk_eq_exam FOREIGN KEY(exam_id) REFERENCES exams(id),
  CONSTRAINT fk_eq_question FOREIGN KEY(question_id) REFERENCES question_bank(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student_exam_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  score INT NOT NULL,
  is_passed TINYINT NOT NULL,
  submit_time DATETIME NOT NULL,
  INDEX idx_record_exam(exam_id),
  INDEX idx_record_student(student_id),
  CONSTRAINT fk_record_exam FOREIGN KEY(exam_id) REFERENCES exams(id),
  CONSTRAINT fk_record_student FOREIGN KEY(student_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student_answer_record (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_record_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  selected_option CHAR(1) NOT NULL,
  is_correct TINYINT NOT NULL,
  INDEX idx_answer_record(exam_record_id),
  INDEX idx_answer_question(question_id),
  CONSTRAINT fk_answer_record FOREIGN KEY(exam_record_id) REFERENCES student_exam_record(id),
  CONSTRAINT fk_answer_question FOREIGN KEY(question_id) REFERENCES question_bank(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS login_attendance (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_id BIGINT NOT NULL,
  login_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_student_date(student_id, login_date),
  INDEX idx_attendance_student(student_id),
  CONSTRAINT fk_attendance_student FOREIGN KEY(student_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student_gpa (
  student_id BIGINT PRIMARY KEY,
  total_credits INT NOT NULL DEFAULT 0,
  total_grade_point DECIMAL(10,2) NOT NULL DEFAULT 0,
  gpa DECIMAL(3,1) NOT NULL DEFAULT 0,
  risk_level ENUM('HIGH','MEDIUM','LOW') NOT NULL DEFAULT 'HIGH',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_gpa_student FOREIGN KEY(student_id) REFERENCES users(id)
) ENGINE=InnoDB;

INSERT IGNORE INTO subjects(name, credit) VALUES
('高等数学',4),('数据结构',4),('操作系统',3),('计算机网络',3),('Java程序设计',4);

INSERT IGNORE INTO users(username,password,real_name,role,total_hours) VALUES
('admin','123456','管理员','ADMIN',48),
('stu1','123456','张三','STUDENT',48),
('stu2','123456','李四','STUDENT',48);
