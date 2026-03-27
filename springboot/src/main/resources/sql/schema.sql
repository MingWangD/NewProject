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
  UNIQUE KEY uk_question_subject_content(subject_id, content(191)),
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
  risk_level VARCHAR(20) NOT NULL DEFAULT 'RED',
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
(1000,1,'函数f(x)=x^2在x=1处导数是','1','2','3','4','B',5),
(1001,1,'极限lim x→0 sinx/x 的值是','0','1','无穷大','不存在','B',5),
(1002,1,'不定积分∫2x dx 的结果是','x^2+C','2x+C','x+C','2x^2+C','A',5),
(1003,1,'矩阵A可逆的充要条件是','det(A)=0','det(A)≠0','A对称','A上三角','B',5),
(1004,1,'二元函数偏导数符号通常写作','Δ','∂','∑','∫','B',5),
(1005,1,'向量点积结果是','向量','标量','矩阵','张量','B',5),
(1006,1,'导数几何意义是曲线的','面积','切线斜率','弧长','体积','B',5),
(1007,1,'定积分表示','平均值','累积量','最小值','导数','B',5),
(1008,1,'若f可导则f一定','连续','有界','周期','单调','A',5),
(1009,1,'二阶导数可用于判断函数的','凹凸性','定义域','值域','周期','A',5),
(1010,1,'泰勒展开基于函数在一点的','极值','导数信息','积分值','零点个数','B',5),
(1011,1,'线性方程组有唯一解的条件是','系数矩阵奇异','秩小于未知数个数','系数矩阵可逆','常数项全零','C',5),
(1012,1,'拉格朗日中值定理要求函数在区间上','有界','连续且可导','单调','周期','B',5),
(1013,1,'向量叉积只在几维空间常用','一维','二维','三维','任意维','C',5),
(1014,1,'概率密度函数在全域积分为','0','1','无穷','随机值','B',5),
(1015,1,'正交向量的点积为','1','-1','0','2','C',5),
(1016,1,'若A为对称矩阵 则特征值通常为','复数且非实','实数','全为0','全为1','B',5),
(1017,1,'梯度方向表示函数增长','最快方向','最慢方向','不变方向','震荡方向','A',5),
(1018,1,'常微分方程dy/dx=y的解含有','对数项','指数项','三角项','常数项','B',5),
(1019,1,'极值点的一阶导通常满足','等于0或不存在','一定大于0','一定小于0','一定等于1','A',5),
(1020,2,'顺序表随机访问时间复杂度是','O(1)','O(logn)','O(n)','O(nlogn)','A',5),
(1021,2,'链表插入已知结点后位置复杂度是','O(1)','O(n)','O(logn)','O(n^2)','A',5),
(1022,2,'队列遵循的原则是','LIFO','FIFO','随机','双端都不可操作','B',5),
(1023,2,'二叉搜索树中序遍历结果是','降序','升序','随机','层序','B',5),
(1024,2,'堆通常用于实现','栈','优先队列','哈希表','并查集','B',5),
(1025,2,'哈希冲突常见解决方法不包括','拉链法','开放寻址','再哈希','深度优先','D',5),
(1026,2,'快速排序平均时间复杂度','O(n)','O(logn)','O(nlogn)','O(n^2)','C',5),
(1027,2,'归并排序是','不稳定排序','稳定排序','原地排序且稳定','计数排序','B',5),
(1028,2,'图的广度优先遍历用到','栈','队列','堆','哈希','B',5),
(1029,2,'图的深度优先遍历常用','队列','栈或递归','堆','并查集','B',5),
(1030,2,'最短路径Dijkstra不适用于','正权图','有向图','含负权边图','稠密图','C',5),
(1031,2,'最小生成树算法不包括','Prim','Kruskal','Dijkstra','Boruvka','C',5),
(1032,2,'平衡二叉树AVL要求','左右子树高度差<=1','完全平衡','满二叉','只在左旋','A',5),
(1033,2,'红黑树属于','多叉树','平衡二叉搜索树','堆','图','B',5),
(1034,2,'B+树常用于','内存栈实现','数据库索引','图最短路','字符串匹配','B',5),
(1035,2,'KMP算法用于','最短路','字符串匹配','排序','哈希','B',5),
(1036,2,'并查集主要支持','区间求和','集合合并与查询','拓扑排序','最小堆','B',5),
(1037,2,'拓扑排序适用于','无向图','DAG','完全图','二叉树','B',5),
(1038,2,'邻接矩阵适合','稀疏图','稠密图','树','链表','B',5),
(1039,2,'动态规划核心是','贪心选择','最优子结构与重叠子问题','回溯剪枝','随机化','B',5),
(1040,3,'进程与程序的主要区别是','进程是静态文件','程序是运行中的实体','进程是动态执行实例','两者完全相同','C',5),
(1041,3,'线程是CPU调度的','最小单位','最大单位','磁盘单位','网络单位','A',5),
(1042,3,'临界区问题需要满足','互斥','死锁','饥饿','抢占','A',5),
(1043,3,'信号量P操作通常表示','释放资源','申请资源','切换进程','读磁盘','B',5),
(1044,3,'虚拟内存技术主要依赖','缓存','分页或分段','RAID','网卡','B',5),
(1045,3,'页面置换算法不包括','LRU','FIFO','OPT','BFS','D',5),
(1046,3,'死锁预防可通过破坏哪项实现','四个必要条件之一','时间片','中断','DMA','A',5),
(1047,3,'银行家算法用于','死锁检测与避免','文件加密','负载均衡','缓存替换','A',5),
(1048,3,'系统调用发生在','用户态内部','用户态到内核态切换','内核态到用户态切换','BIOS阶段','B',5),
(1049,3,'进程通信方式不包括','管道','消息队列','共享内存','二叉树','D',5),
(1050,3,'文件系统中的inode主要存储','文件内容','文件元数据','用户密码','网络地址','B',5),
(1051,3,'磁盘调度算法不包括','SSTF','SCAN','C-SCAN','KMP','D',5),
(1052,3,'时间片轮转算法属于','抢占式调度','非抢占式','静态分配','批处理专用','A',5),
(1053,3,'优先级反转可通过什么缓解','忙等','优先级继承','禁用中断','增加线程数','B',5),
(1054,3,'TLB用于加速','磁盘访问','地址转换','进程切换','网络路由','B',5),
(1055,3,'缺页中断发生于','页不在内存','CPU过热','磁盘满','线程结束','A',5),
(1056,3,'僵尸进程是指','正在运行','已终止但未回收','长期阻塞','高优先级','B',5),
(1057,3,'守护进程通常运行于','前台交互','后台长期服务','引导扇区','显卡','B',5),
(1058,3,'用户态不能直接执行','普通算术','特权指令','函数调用','字符串操作','B',5),
(1059,3,'写时复制技术常用于','进程fork优化','磁盘压缩','网络缓存','日志切割','A',5),
(1060,4,'OSI七层中传输层常见协议是','IP','TCP','ARP','ICMP','B',5),
(1061,4,'IP协议工作在OSI的','应用层','传输层','网络层','链路层','C',5),
(1062,4,'MAC地址长度通常是','32位','48位','64位','128位','B',5),
(1063,4,'子网掩码255.255.255.0对应前缀','/8','/16','/24','/32','C',5),
(1064,4,'TCP三次握手的作用是','释放连接','建立可靠连接','广播路由','地址转换','B',5),
(1065,4,'TCP四次挥手主要用于','建立连接','断开连接','流量控制','拥塞避免','B',5),
(1066,4,'UDP的特点是','面向连接','不可靠无连接','必须重传','有序可靠','B',5),
(1067,4,'DNS主要负责','文件传输','域名解析','邮件收发','网页渲染','B',5),
(1068,4,'HTTP默认端口是','21','53','80','443','C',5),
(1069,4,'HTTPS在HTTP基础上增加','压缩','加密传输','路由选择','多播','B',5),
(1070,4,'ARP协议用于','IP到MAC解析','域名解析','路由发现','时间同步','A',5),
(1071,4,'ICMP常用于','网页渲染','网络控制与差错报告','数据库复制','流媒体编码','B',5),
(1072,4,'路由器工作在','物理层','数据链路层','网络层','应用层','C',5),
(1073,4,'交换机主要工作在','物理层','数据链路层','会话层','表示层','B',5),
(1074,4,'NAT的作用是','提高带宽','地址转换','错误恢复','链路聚合','B',5),
(1075,4,'CDN主要优化','数据库事务','内容分发访问速度','CPU主频','内存分页','B',5),
(1076,4,'拥塞控制与流量控制关系是','完全相同','前者面向网络后者面向接收端','互不相关','都只在UDP中用','B',5),
(1077,4,'TCP可靠性机制不包括','序号确认','重传机制','流量控制','随机丢包','D',5),
(1078,4,'局域网常用以太网标准是','802.3','802.11','802.15','802.16','A',5),
(1079,4,'Wi-Fi常见标准系列是','802.3','802.11','802.1Q','802.5','B',5),
(1080,5,'Java中定义类的关键字是','def','class','struct','object','B',5),
(1081,5,'Java程序入口方法是','main','start','runApp','entry','A',5),
(1082,5,'面向对象三大特性不包括','封装','继承','多态','回溯','D',5),
(1083,5,'重载要求','方法名相同参数不同','返回值不同即可','访问修饰符相同','必须static','A',5),
(1084,5,'重写发生在','同一类','父子类','接口常量','构造器','B',5),
(1085,5,'String是','可变','不可变','线程','注解','B',5),
(1086,5,'ArrayList底层主要是','链表','数组','哈希表','树','B',5),
(1087,5,'HashMap键值存储基于','数组+链表/树','纯链表','纯数组','堆栈','A',5),
(1088,5,'Java异常体系根类是','Error','Throwable','Exception','Runtime','B',5),
(1089,5,'finally代码块通常用于','条件判断','资源释放','循环控制','反射调用','B',5),
(1090,5,'接口中默认方法关键字是','public','static','default','final','C',5),
(1091,5,'抽象类不能','有成员变量','有构造方法','直接实例化','有普通方法','C',5),
(1092,5,'线程启动应调用','run()','start()','sleep()','yield()','B',5),
(1093,5,'synchronized主要用于','网络通信','线程同步','文件压缩','图像处理','B',5),
(1094,5,'JDBC用于','图形绘制','数据库连接访问','网络抓包','日志收集','B',5),
(1095,5,'JVM内存中用于对象分配的是','栈','堆','方法区','寄存器','B',5),
(1096,5,'垃圾回收主要回收','栈帧','堆中无引用对象','字节码','线程句柄','B',5),
(1097,5,'泛型的主要作用是','提高IO','类型安全','减少网络请求','加密数据','B',5),
(1098,5,'Lambda表达式引入于','Java6','Java7','Java8','Java11','C',5),
(1099,5,'Spring Boot常用于','快速构建Java后端应用','替代JVM','编译C语言','制作动画','A',5);

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
