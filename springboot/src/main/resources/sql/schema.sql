CREATE DATABASE IF NOT EXISTS study_warning DEFAULT CHARACTER SET utf8mb4;
USE study_warning;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  real_name VARCHAR(50) NOT NULL,
  role ENUM('ADMIN','STUDENT') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS subjects (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  credit INT NOT NULL,
  total_hours INT NOT NULL,
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
  UNIQUE KEY uk_exam_student_once(exam_id, student_id),
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
  risk_level ENUM('RED','ORANGE','YELLOW','GREEN') NOT NULL DEFAULT 'RED',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_gpa_student FOREIGN KEY(student_id) REFERENCES users(id)
) ENGINE=InnoDB;

INSERT IGNORE INTO subjects(id, name, credit, total_hours) VALUES
(1,'高等数学',4,64),
(2,'数据结构',4,48),
(3,'操作系统',3,48),
(4,'计算机网络',3,32),
(5,'Java程序设计',4,64);

INSERT IGNORE INTO users(id, username, password, real_name, role) VALUES
(1,'admin','123456','管理员','ADMIN'),
(2,'stu1','123456','张三','STUDENT'),
(3,'stu2','123456','李四','STUDENT'),
(4,'stu3','123456','王五','STUDENT'),
(5,'stu4','123456','赵六','STUDENT'),
(6,'stu5','123456','孙七','STUDENT');

INSERT IGNORE INTO question_bank(id,subject_id,content,option_a,option_b,option_c,option_d,correct_option,score) VALUES
(1000,1,'极限lim(x→0) sinx/x 等于？（第1题）','0','1','∞','不存在','B',5),
(1001,1,'函数f(x)=x^2在x=1处导数是？（第2题）','1','2','3','4','B',5),
(1002,1,'极限lim(x→0) sinx/x 等于？（第3题）','0','1','∞','不存在','B',5),
(1003,1,'函数f(x)=x^2在x=1处导数是？（第4题）','1','2','3','4','B',5),
(1004,1,'极限lim(x→0) sinx/x 等于？（第5题）','0','1','∞','不存在','B',5),
(1005,1,'函数f(x)=x^2在x=1处导数是？（第6题）','1','2','3','4','B',5),
(1006,1,'极限lim(x→0) sinx/x 等于？（第7题）','0','1','∞','不存在','B',5),
(1007,1,'函数f(x)=x^2在x=1处导数是？（第8题）','1','2','3','4','B',5),
(1008,1,'极限lim(x→0) sinx/x 等于？（第9题）','0','1','∞','不存在','B',5),
(1009,1,'函数f(x)=x^2在x=1处导数是？（第10题）','1','2','3','4','B',5),
(1010,1,'极限lim(x→0) sinx/x 等于？（第11题）','0','1','∞','不存在','B',5),
(1011,1,'函数f(x)=x^2在x=1处导数是？（第12题）','1','2','3','4','B',5),
(1012,1,'极限lim(x→0) sinx/x 等于？（第13题）','0','1','∞','不存在','B',5),
(1013,1,'函数f(x)=x^2在x=1处导数是？（第14题）','1','2','3','4','B',5),
(1014,1,'极限lim(x→0) sinx/x 等于？（第15题）','0','1','∞','不存在','B',5),
(1015,1,'函数f(x)=x^2在x=1处导数是？（第16题）','1','2','3','4','B',5),
(1016,1,'极限lim(x→0) sinx/x 等于？（第17题）','0','1','∞','不存在','B',5),
(1017,1,'函数f(x)=x^2在x=1处导数是？（第18题）','1','2','3','4','B',5),
(1018,1,'极限lim(x→0) sinx/x 等于？（第19题）','0','1','∞','不存在','B',5),
(1019,1,'函数f(x)=x^2在x=1处导数是？（第20题）','1','2','3','4','B',5),
(1020,2,'二分查找适用于？（第1题）','无序表','有序表','链表','哈希表','B',5),
(1021,2,'栈的特点是？（第2题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1022,2,'二分查找适用于？（第3题）','无序表','有序表','链表','哈希表','B',5),
(1023,2,'栈的特点是？（第4题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1024,2,'二分查找适用于？（第5题）','无序表','有序表','链表','哈希表','B',5),
(1025,2,'栈的特点是？（第6题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1026,2,'二分查找适用于？（第7题）','无序表','有序表','链表','哈希表','B',5),
(1027,2,'栈的特点是？（第8题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1028,2,'二分查找适用于？（第9题）','无序表','有序表','链表','哈希表','B',5),
(1029,2,'栈的特点是？（第10题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1030,2,'二分查找适用于？（第11题）','无序表','有序表','链表','哈希表','B',5),
(1031,2,'栈的特点是？（第12题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1032,2,'二分查找适用于？（第13题）','无序表','有序表','链表','哈希表','B',5),
(1033,2,'栈的特点是？（第14题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1034,2,'二分查找适用于？（第15题）','无序表','有序表','链表','哈希表','B',5),
(1035,2,'栈的特点是？（第16题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1036,2,'二分查找适用于？（第17题）','无序表','有序表','链表','哈希表','B',5),
(1037,2,'栈的特点是？（第18题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1038,2,'二分查找适用于？（第19题）','无序表','有序表','链表','哈希表','B',5),
(1039,2,'栈的特点是？（第20题）','FIFO','LIFO','随机访问','哈希访问','B',5),
(1040,3,'死锁四条件不包括？（第1题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1041,3,'进程切换由谁完成？（第2题）','编译器','内核','数据库','浏览器','B',5),
(1042,3,'死锁四条件不包括？（第3题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1043,3,'进程切换由谁完成？（第4题）','编译器','内核','数据库','浏览器','B',5),
(1044,3,'死锁四条件不包括？（第5题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1045,3,'进程切换由谁完成？（第6题）','编译器','内核','数据库','浏览器','B',5),
(1046,3,'死锁四条件不包括？（第7题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1047,3,'进程切换由谁完成？（第8题）','编译器','内核','数据库','浏览器','B',5),
(1048,3,'死锁四条件不包括？（第9题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1049,3,'进程切换由谁完成？（第10题）','编译器','内核','数据库','浏览器','B',5),
(1050,3,'死锁四条件不包括？（第11题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1051,3,'进程切换由谁完成？（第12题）','编译器','内核','数据库','浏览器','B',5),
(1052,3,'死锁四条件不包括？（第13题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1053,3,'进程切换由谁完成？（第14题）','编译器','内核','数据库','浏览器','B',5),
(1054,3,'死锁四条件不包括？（第15题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1055,3,'进程切换由谁完成？（第16题）','编译器','内核','数据库','浏览器','B',5),
(1056,3,'死锁四条件不包括？（第17题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1057,3,'进程切换由谁完成？（第18题）','编译器','内核','数据库','浏览器','B',5),
(1058,3,'死锁四条件不包括？（第19题）','互斥','请求保持','可剥夺','循环等待','C',5),
(1059,3,'进程切换由谁完成？（第20题）','编译器','内核','数据库','浏览器','B',5),
(1060,4,'IPv4地址长度是？（第1题）','16','32','64','128','B',5),
(1061,4,'TCP位于哪一层？（第2题）','网络层','传输层','会话层','应用层','B',5),
(1062,4,'IPv4地址长度是？（第3题）','16','32','64','128','B',5),
(1063,4,'TCP位于哪一层？（第4题）','网络层','传输层','会话层','应用层','B',5),
(1064,4,'IPv4地址长度是？（第5题）','16','32','64','128','B',5),
(1065,4,'TCP位于哪一层？（第6题）','网络层','传输层','会话层','应用层','B',5),
(1066,4,'IPv4地址长度是？（第7题）','16','32','64','128','B',5),
(1067,4,'TCP位于哪一层？（第8题）','网络层','传输层','会话层','应用层','B',5),
(1068,4,'IPv4地址长度是？（第9题）','16','32','64','128','B',5),
(1069,4,'TCP位于哪一层？（第10题）','网络层','传输层','会话层','应用层','B',5),
(1070,4,'IPv4地址长度是？（第11题）','16','32','64','128','B',5),
(1071,4,'TCP位于哪一层？（第12题）','网络层','传输层','会话层','应用层','B',5),
(1072,4,'IPv4地址长度是？（第13题）','16','32','64','128','B',5),
(1073,4,'TCP位于哪一层？（第14题）','网络层','传输层','会话层','应用层','B',5),
(1074,4,'IPv4地址长度是？（第15题）','16','32','64','128','B',5),
(1075,4,'TCP位于哪一层？（第16题）','网络层','传输层','会话层','应用层','B',5),
(1076,4,'IPv4地址长度是？（第17题）','16','32','64','128','B',5),
(1077,4,'TCP位于哪一层？（第18题）','网络层','传输层','会话层','应用层','B',5),
(1078,4,'IPv4地址长度是？（第19题）','16','32','64','128','B',5),
(1079,4,'TCP位于哪一层？（第20题）','网络层','传输层','会话层','应用层','B',5),
(1080,5,'JVM执行的是？（第1题）','源代码','字节码','机器码','脚本','B',5),
(1081,5,'Java继承关键字是？（第2题）','implements','extends','inherit','instanceof','B',5),
(1082,5,'JVM执行的是？（第3题）','源代码','字节码','机器码','脚本','B',5),
(1083,5,'Java继承关键字是？（第4题）','implements','extends','inherit','instanceof','B',5),
(1084,5,'JVM执行的是？（第5题）','源代码','字节码','机器码','脚本','B',5),
(1085,5,'Java继承关键字是？（第6题）','implements','extends','inherit','instanceof','B',5),
(1086,5,'JVM执行的是？（第7题）','源代码','字节码','机器码','脚本','B',5),
(1087,5,'Java继承关键字是？（第8题）','implements','extends','inherit','instanceof','B',5),
(1088,5,'JVM执行的是？（第9题）','源代码','字节码','机器码','脚本','B',5),
(1089,5,'Java继承关键字是？（第10题）','implements','extends','inherit','instanceof','B',5),
(1090,5,'JVM执行的是？（第11题）','源代码','字节码','机器码','脚本','B',5),
(1091,5,'Java继承关键字是？（第12题）','implements','extends','inherit','instanceof','B',5),
(1092,5,'JVM执行的是？（第13题）','源代码','字节码','机器码','脚本','B',5),
(1093,5,'Java继承关键字是？（第14题）','implements','extends','inherit','instanceof','B',5),
(1094,5,'JVM执行的是？（第15题）','源代码','字节码','机器码','脚本','B',5),
(1095,5,'Java继承关键字是？（第16题）','implements','extends','inherit','instanceof','B',5),
(1096,5,'JVM执行的是？（第17题）','源代码','字节码','机器码','脚本','B',5),
(1097,5,'Java继承关键字是？（第18题）','implements','extends','inherit','instanceof','B',5),
(1098,5,'JVM执行的是？（第19题）','源代码','字节码','机器码','脚本','B',5),
(1099,5,'Java继承关键字是？（第20题）','implements','extends','inherit','instanceof','B',5);

INSERT IGNORE INTO login_attendance(student_id, login_date)
SELECT 2, DATE_ADD('2026-01-01', INTERVAL seq DAY) FROM (
SELECT 0 seq
UNION ALL
SELECT 1 seq
UNION ALL
SELECT 2 seq
UNION ALL
SELECT 3 seq
UNION ALL
SELECT 4 seq
UNION ALL
SELECT 5 seq
UNION ALL
SELECT 6 seq
UNION ALL
SELECT 7 seq
UNION ALL
SELECT 8 seq
UNION ALL
SELECT 9 seq
UNION ALL
SELECT 10 seq
UNION ALL
SELECT 11 seq
UNION ALL
SELECT 12 seq
UNION ALL
SELECT 13 seq
UNION ALL
SELECT 14 seq
UNION ALL
SELECT 15 seq
UNION ALL
SELECT 16 seq
UNION ALL
SELECT 17 seq
UNION ALL
SELECT 18 seq
UNION ALL
SELECT 19 seq
UNION ALL
SELECT 20 seq
UNION ALL
SELECT 21 seq
UNION ALL
SELECT 22 seq
UNION ALL
SELECT 23 seq
UNION ALL
SELECT 24 seq
UNION ALL
SELECT 25 seq
UNION ALL
SELECT 26 seq
UNION ALL
SELECT 27 seq
UNION ALL
SELECT 28 seq
UNION ALL
SELECT 29 seq
UNION ALL
SELECT 30 seq
UNION ALL
SELECT 31 seq
UNION ALL
SELECT 32 seq
UNION ALL
SELECT 33 seq
UNION ALL
SELECT 34 seq
UNION ALL
SELECT 35 seq
UNION ALL
SELECT 36 seq
UNION ALL
SELECT 37 seq
UNION ALL
SELECT 38 seq
UNION ALL
SELECT 39 seq
UNION ALL
SELECT 40 seq
UNION ALL
SELECT 41 seq
UNION ALL
SELECT 42 seq
UNION ALL
SELECT 43 seq
UNION ALL
SELECT 44 seq
) t;

INSERT IGNORE INTO login_attendance(student_id, login_date)
SELECT 3, DATE_ADD('2026-01-01', INTERVAL seq DAY) FROM (
SELECT 0 seq
UNION ALL
SELECT 1 seq
UNION ALL
SELECT 2 seq
UNION ALL
SELECT 3 seq
UNION ALL
SELECT 4 seq
UNION ALL
SELECT 5 seq
UNION ALL
SELECT 6 seq
UNION ALL
SELECT 7 seq
UNION ALL
SELECT 8 seq
UNION ALL
SELECT 9 seq
UNION ALL
SELECT 10 seq
UNION ALL
SELECT 11 seq
UNION ALL
SELECT 12 seq
UNION ALL
SELECT 13 seq
UNION ALL
SELECT 14 seq
UNION ALL
SELECT 15 seq
UNION ALL
SELECT 16 seq
UNION ALL
SELECT 17 seq
UNION ALL
SELECT 18 seq
UNION ALL
SELECT 19 seq
UNION ALL
SELECT 20 seq
UNION ALL
SELECT 21 seq
UNION ALL
SELECT 22 seq
UNION ALL
SELECT 23 seq
UNION ALL
SELECT 24 seq
) t;

INSERT IGNORE INTO login_attendance(student_id, login_date)
SELECT 4, DATE_ADD('2026-01-01', INTERVAL seq DAY) FROM (
SELECT 0 seq
UNION ALL
SELECT 1 seq
UNION ALL
SELECT 2 seq
UNION ALL
SELECT 3 seq
UNION ALL
SELECT 4 seq
UNION ALL
SELECT 5 seq
UNION ALL
SELECT 6 seq
UNION ALL
SELECT 7 seq
UNION ALL
SELECT 8 seq
UNION ALL
SELECT 9 seq
UNION ALL
SELECT 10 seq
UNION ALL
SELECT 11 seq
UNION ALL
SELECT 12 seq
UNION ALL
SELECT 13 seq
UNION ALL
SELECT 14 seq
UNION ALL
SELECT 15 seq
UNION ALL
SELECT 16 seq
UNION ALL
SELECT 17 seq
UNION ALL
SELECT 18 seq
UNION ALL
SELECT 19 seq
UNION ALL
SELECT 20 seq
UNION ALL
SELECT 21 seq
UNION ALL
SELECT 22 seq
UNION ALL
SELECT 23 seq
UNION ALL
SELECT 24 seq
UNION ALL
SELECT 25 seq
UNION ALL
SELECT 26 seq
UNION ALL
SELECT 27 seq
UNION ALL
SELECT 28 seq
UNION ALL
SELECT 29 seq
UNION ALL
SELECT 30 seq
UNION ALL
SELECT 31 seq
UNION ALL
SELECT 32 seq
UNION ALL
SELECT 33 seq
UNION ALL
SELECT 34 seq
UNION ALL
SELECT 35 seq
UNION ALL
SELECT 36 seq
UNION ALL
SELECT 37 seq
UNION ALL
SELECT 38 seq
UNION ALL
SELECT 39 seq
) t;

INSERT IGNORE INTO login_attendance(student_id, login_date)
SELECT 5, DATE_ADD('2026-01-01', INTERVAL seq DAY) FROM (
SELECT 0 seq
UNION ALL
SELECT 1 seq
UNION ALL
SELECT 2 seq
UNION ALL
SELECT 3 seq
UNION ALL
SELECT 4 seq
UNION ALL
SELECT 5 seq
UNION ALL
SELECT 6 seq
UNION ALL
SELECT 7 seq
UNION ALL
SELECT 8 seq
UNION ALL
SELECT 9 seq
UNION ALL
SELECT 10 seq
UNION ALL
SELECT 11 seq
) t;

INSERT IGNORE INTO login_attendance(student_id, login_date)
SELECT 6, DATE_ADD('2026-01-01', INTERVAL seq DAY) FROM (
SELECT 0 seq
UNION ALL
SELECT 1 seq
UNION ALL
SELECT 2 seq
UNION ALL
SELECT 3 seq
UNION ALL
SELECT 4 seq
UNION ALL
SELECT 5 seq
UNION ALL
SELECT 6 seq
UNION ALL
SELECT 7 seq
UNION ALL
SELECT 8 seq
UNION ALL
SELECT 9 seq
UNION ALL
SELECT 10 seq
UNION ALL
SELECT 11 seq
UNION ALL
SELECT 12 seq
UNION ALL
SELECT 13 seq
UNION ALL
SELECT 14 seq
UNION ALL
SELECT 15 seq
UNION ALL
SELECT 16 seq
UNION ALL
SELECT 17 seq
UNION ALL
SELECT 18 seq
UNION ALL
SELECT 19 seq
UNION ALL
SELECT 20 seq
UNION ALL
SELECT 21 seq
UNION ALL
SELECT 22 seq
UNION ALL
SELECT 23 seq
UNION ALL
SELECT 24 seq
UNION ALL
SELECT 25 seq
UNION ALL
SELECT 26 seq
UNION ALL
SELECT 27 seq
UNION ALL
SELECT 28 seq
UNION ALL
SELECT 29 seq
UNION ALL
SELECT 30 seq
UNION ALL
SELECT 31 seq
UNION ALL
SELECT 32 seq
UNION ALL
SELECT 33 seq
UNION ALL
SELECT 34 seq
UNION ALL
SELECT 35 seq
UNION ALL
SELECT 36 seq
UNION ALL
SELECT 37 seq
UNION ALL
SELECT 38 seq
UNION ALL
SELECT 39 seq
UNION ALL
SELECT 40 seq
UNION ALL
SELECT 41 seq
UNION ALL
SELECT 42 seq
UNION ALL
SELECT 43 seq
UNION ALL
SELECT 44 seq
UNION ALL
SELECT 45 seq
UNION ALL
SELECT 46 seq
UNION ALL
SELECT 47 seq
UNION ALL
SELECT 48 seq
UNION ALL
SELECT 49 seq
) t;
