-- 一键插入初始化与样本数据
USE study_warning;

INSERT IGNORE INTO subjects(id, name, credit, total_hours) VALUES
(1,'高等数学',4,64),
(2,'数据结构',4,48),
(3,'操作系统',4,48),
(4,'计算机网络',4,32),
(5,'Java程序设计',4,64);

INSERT IGNORE INTO users(id, username, password, real_name, role, email) VALUES
(1,'admin','123456','管理员','ADMIN','admin@study.local'),
(2,'stu1','123456','张三','STUDENT','stu1@study.local'),
(3,'stu2','123456','李四','STUDENT','stu2@study.local'),
(4,'stu3','123456','王五','STUDENT','stu3@study.local'),
(5,'stu4','123456','赵六','STUDENT','stu4@study.local'),
(6,'stu5','123456','孙七','STUDENT','stu5@study.local'),
(7,'stu6','123456','钱八','STUDENT','stu6@study.local'),
(8,'stu7','123456','周九','STUDENT','stu7@study.local'),
(9,'stu8','123456','吴十','STUDENT','stu8@study.local'),
(10,'stu9','123456','郑十一','STUDENT','stu9@study.local'),
(11,'stu10','123456','王十二','STUDENT','stu10@study.local');

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


-- 历史考试样本数据：10名学生 * 5门科目 * 每门7场考试
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



-- 额外模拟出勤数据（覆盖10名学生，分布更离散）
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


-- 同步 GPA 与风险等级（保证风险看板与样本数据一致）
INSERT INTO student_gpa(student_id,total_credits,total_grade_point,gpa,risk_level)
SELECT t.student_id,
       SUM(s.credit) AS total_credits,
       ROUND(SUM(t.point * s.credit), 2) AS total_grade_point,
       ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) AS gpa,
       CASE
         WHEN ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) < 1.5 THEN 'RED'
         WHEN ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) < 2.0 THEN 'ORANGE'
         WHEN ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) < 2.5 THEN 'YELLOW'
         ELSE 'GREEN'
       END AS risk_level
FROM (
  SELECT r.student_id,
         e.subject_id,
         CASE
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 90 THEN 4.0
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 85 THEN 3.7
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 82 THEN 3.3
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 78 THEN 3.0
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 75 THEN 2.7
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 72 THEN 2.3
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 69 THEN 2.0
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 65 THEN 1.7
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 61 THEN 1.3
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) = 60 THEN 1.0
           ELSE 0
         END AS point
  FROM student_exam_record r
  JOIN exams e ON r.exam_id=e.id
  GROUP BY r.student_id, e.subject_id
) t
JOIN subjects s ON s.id=t.subject_id
GROUP BY t.student_id
ON DUPLICATE KEY UPDATE
  total_credits=VALUES(total_credits),
  total_grade_point=VALUES(total_grade_point),
  gpa=VALUES(gpa),
  risk_level=VALUES(risk_level);
-- ===== 2026 DEMO FLOW DATASET (20 students, full/partial regular completion) =====
USE study_warning;

-- 清理事务数据，重建可演示“补做课后测验后 GPA 变化”的场景
DELETE FROM student_answer_record;
DELETE FROM student_exam_record;
DELETE FROM exam_question;
DELETE FROM exams;
DELETE FROM login_attendance;
DELETE FROM student_gpa;
DELETE FROM users WHERE role='STUDENT';

INSERT INTO users(id, username, password, real_name, role, email) VALUES
(2,'stu1','123456','学生1','STUDENT','stu1@study.local'),
(3,'stu2','123456','学生2','STUDENT','stu2@study.local'),
(4,'stu3','123456','学生3','STUDENT','stu3@study.local'),
(5,'stu4','123456','学生4','STUDENT','stu4@study.local'),
(6,'stu5','123456','学生5','STUDENT','stu5@study.local'),
(7,'stu6','123456','学生6','STUDENT','stu6@study.local'),
(8,'stu7','123456','学生7','STUDENT','stu7@study.local'),
(9,'stu8','123456','学生8','STUDENT','stu8@study.local'),
(10,'stu9','123456','学生9','STUDENT','stu9@study.local'),
(11,'stu10','123456','学生10','STUDENT','stu10@study.local'),
(12,'stu11','123456','学生11','STUDENT','stu11@study.local'),
(13,'stu12','123456','学生12','STUDENT','stu12@study.local'),
(14,'stu13','123456','学生13','STUDENT','stu13@study.local'),
(15,'stu14','123456','学生14','STUDENT','stu14@study.local'),
(16,'stu15','123456','学生15','STUDENT','stu15@study.local'),
(17,'stu16','123456','学生16','STUDENT','stu16@study.local'),
(18,'stu17','123456','学生17','STUDENT','stu17@study.local'),
(19,'stu18','123456','学生18','STUDENT','stu18@study.local'),
(20,'stu19','123456','学生19','STUDENT','stu19@study.local'),
(21,'stu20','123456','学生20','STUDENT','stu20@study.local');

INSERT INTO login_attendance(student_id, login_date)
SELECT u.id, DATE_ADD('2026-03-01', INTERVAL d.seq DAY)
FROM users u
JOIN (SELECT ones.n + tens.n * 10 AS seq
      FROM (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
      CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
     ) d
WHERE u.role='STUDENT' AND d.seq < 100 AND MOD(d.seq + u.id, (u.id % 5) + 2) <> 0;

INSERT INTO exams(id,name,subject_id,total_score,pass_score,start_time,end_time,exam_type) VALUES
(4001,'1课后测验A',1,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4002,'1课后测验B',1,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4003,'2课后测验A',2,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4004,'2课后测验B',2,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4005,'3课后测验A',3,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4006,'3课后测验B',3,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4007,'4课后测验A',4,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4008,'4课后测验B',4,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4009,'5课后测验A',5,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4010,'5课后测验B',5,25,15,'2026-03-10 08:00:00','2026-06-30 23:59:59','REGULAR'),
(4101,'1期末考试',1,50,30,'2026-05-20 08:00:00','2026-06-30 23:59:59','FINAL'),
(4102,'2期末考试',2,50,30,'2026-05-20 08:00:00','2026-06-30 23:59:59','FINAL'),
(4103,'3期末考试',3,50,30,'2026-05-20 08:00:00','2026-06-30 23:59:59','FINAL'),
(4104,'4期末考试',4,50,30,'2026-05-20 08:00:00','2026-06-30 23:59:59','FINAL'),
(4105,'5期末考试',5,50,30,'2026-05-20 08:00:00','2026-06-30 23:59:59','FINAL');

INSERT INTO exam_question(exam_id, question_id) VALUES
(4001,1000),
(4001,1001),
(4001,1002),
(4001,1003),
(4001,1004),
(4002,1005),
(4002,1006),
(4002,1007),
(4002,1008),
(4002,1009),
(4003,1020),
(4003,1021),
(4003,1022),
(4003,1023),
(4003,1024),
(4004,1025),
(4004,1026),
(4004,1027),
(4004,1028),
(4004,1029),
(4005,1040),
(4005,1041),
(4005,1042),
(4005,1043),
(4005,1044),
(4006,1045),
(4006,1046),
(4006,1047),
(4006,1048),
(4006,1049),
(4007,1060),
(4007,1061),
(4007,1062),
(4007,1063),
(4007,1064),
(4008,1065),
(4008,1066),
(4008,1067),
(4008,1068),
(4008,1069),
(4009,1080),
(4009,1081),
(4009,1082),
(4009,1083),
(4009,1084),
(4010,1085),
(4010,1086),
(4010,1087),
(4010,1088),
(4010,1089),
(4101,1000),
(4101,1001),
(4101,1002),
(4101,1003),
(4101,1004),
(4101,1005),
(4101,1006),
(4101,1007),
(4101,1008),
(4101,1009),
(4102,1020),
(4102,1021),
(4102,1022),
(4102,1023),
(4102,1024),
(4102,1025),
(4102,1026),
(4102,1027),
(4102,1028),
(4102,1029),
(4103,1040),
(4103,1041),
(4103,1042),
(4103,1043),
(4103,1044),
(4103,1045),
(4103,1046),
(4103,1047),
(4103,1048),
(4103,1049),
(4104,1060),
(4104,1061),
(4104,1062),
(4104,1063),
(4104,1064),
(4104,1065),
(4104,1066),
(4104,1067),
(4104,1068),
(4104,1069),
(4105,1080),
(4105,1081),
(4105,1082),
(4105,1083),
(4105,1084),
(4105,1085),
(4105,1086),
(4105,1087),
(4105,1088),
(4105,1089);

INSERT INTO student_exam_record(exam_id, student_id, score, is_passed, submit_time) VALUES
(4001,2,25,1,'2026-06-01 10:00:00'),
(4002,2,12,0,'2026-06-01 10:00:00'),
(4003,2,13,0,'2026-06-01 10:00:00'),
(4004,2,14,0,'2026-06-01 10:00:00'),
(4005,2,15,1,'2026-06-01 10:00:00'),
(4006,2,16,1,'2026-06-01 10:00:00'),
(4007,2,17,1,'2026-06-01 10:00:00'),
(4008,2,18,1,'2026-06-01 10:00:00'),
(4009,2,19,1,'2026-06-01 10:00:00'),
(4010,2,20,1,'2026-06-01 10:00:00'),
(4001,3,12,0,'2026-06-01 10:00:00'),
(4002,3,13,0,'2026-06-01 10:00:00'),
(4003,3,14,0,'2026-06-01 10:00:00'),
(4004,3,15,1,'2026-06-01 10:00:00'),
(4005,3,16,1,'2026-06-01 10:00:00'),
(4006,3,17,1,'2026-06-01 10:00:00'),
(4007,3,18,1,'2026-06-01 10:00:00'),
(4008,3,19,1,'2026-06-01 10:00:00'),
(4009,3,20,1,'2026-06-01 10:00:00'),
(4010,3,21,1,'2026-06-01 10:00:00'),
(4001,4,13,0,'2026-06-01 10:00:00'),
(4002,4,14,0,'2026-06-01 10:00:00'),
(4003,4,15,1,'2026-06-01 10:00:00'),
(4004,4,16,1,'2026-06-01 10:00:00'),
(4005,4,17,1,'2026-06-01 10:00:00'),
(4006,4,18,1,'2026-06-01 10:00:00'),
(4007,4,19,1,'2026-06-01 10:00:00'),
(4008,4,20,1,'2026-06-01 10:00:00'),
(4009,4,21,1,'2026-06-01 10:00:00'),
(4010,4,22,1,'2026-06-01 10:00:00'),
(4001,5,14,0,'2026-06-01 10:00:00'),
(4002,5,15,1,'2026-06-01 10:00:00'),
(4003,5,16,1,'2026-06-01 10:00:00'),
(4004,5,17,1,'2026-06-01 10:00:00'),
(4005,5,18,1,'2026-06-01 10:00:00'),
(4006,5,19,1,'2026-06-01 10:00:00'),
(4007,5,20,1,'2026-06-01 10:00:00'),
(4008,5,21,1,'2026-06-01 10:00:00'),
(4009,5,22,1,'2026-06-01 10:00:00'),
(4010,5,23,1,'2026-06-01 10:00:00'),
(4001,6,15,1,'2026-06-01 10:00:00'),
(4002,6,16,1,'2026-06-01 10:00:00'),
(4003,6,17,1,'2026-06-01 10:00:00'),
(4004,6,18,1,'2026-06-01 10:00:00'),
(4005,6,19,1,'2026-06-01 10:00:00'),
(4006,6,20,1,'2026-06-01 10:00:00'),
(4007,6,21,1,'2026-06-01 10:00:00'),
(4008,6,22,1,'2026-06-01 10:00:00'),
(4009,6,23,1,'2026-06-01 10:00:00'),
(4010,6,24,1,'2026-06-01 10:00:00'),
(4001,7,16,1,'2026-06-01 10:00:00'),
(4002,7,17,1,'2026-06-01 10:00:00'),
(4003,7,18,1,'2026-06-01 10:00:00'),
(4004,7,19,1,'2026-06-01 10:00:00'),
(4005,7,20,1,'2026-06-01 10:00:00'),
(4006,7,21,1,'2026-06-01 10:00:00'),
(4007,7,22,1,'2026-06-01 10:00:00'),
(4008,7,23,1,'2026-06-01 10:00:00'),
(4009,7,24,1,'2026-06-01 10:00:00'),
(4010,7,25,1,'2026-06-01 10:00:00'),
(4001,8,17,1,'2026-06-01 10:00:00'),
(4002,8,18,1,'2026-06-01 10:00:00'),
(4003,8,19,1,'2026-06-01 10:00:00'),
(4004,8,20,1,'2026-06-01 10:00:00'),
(4005,8,21,1,'2026-06-01 10:00:00'),
(4006,8,22,1,'2026-06-01 10:00:00'),
(4007,8,23,1,'2026-06-01 10:00:00'),
(4008,8,24,1,'2026-06-01 10:00:00'),
(4009,8,25,1,'2026-06-01 10:00:00'),
(4010,8,12,0,'2026-06-01 10:00:00'),
(4001,9,18,1,'2026-06-01 10:00:00'),
(4002,9,19,1,'2026-06-01 10:00:00'),
(4003,9,20,1,'2026-06-01 10:00:00'),
(4004,9,21,1,'2026-06-01 10:00:00'),
(4005,9,22,1,'2026-06-01 10:00:00'),
(4006,9,23,1,'2026-06-01 10:00:00'),
(4007,9,24,1,'2026-06-01 10:00:00'),
(4008,9,25,1,'2026-06-01 10:00:00'),
(4009,9,12,0,'2026-06-01 10:00:00'),
(4010,9,13,0,'2026-06-01 10:00:00'),
(4001,10,19,1,'2026-06-01 10:00:00'),
(4002,10,20,1,'2026-06-01 10:00:00'),
(4003,10,21,1,'2026-06-01 10:00:00'),
(4004,10,22,1,'2026-06-01 10:00:00'),
(4005,10,23,1,'2026-06-01 10:00:00'),
(4006,10,24,1,'2026-06-01 10:00:00'),
(4007,10,25,1,'2026-06-01 10:00:00'),
(4008,10,12,0,'2026-06-01 10:00:00'),
(4009,10,13,0,'2026-06-01 10:00:00'),
(4010,10,14,0,'2026-06-01 10:00:00'),
(4001,11,20,1,'2026-06-01 10:00:00'),
(4002,11,21,1,'2026-06-01 10:00:00'),
(4003,11,22,1,'2026-06-01 10:00:00'),
(4004,11,23,1,'2026-06-01 10:00:00'),
(4005,11,24,1,'2026-06-01 10:00:00'),
(4006,11,25,1,'2026-06-01 10:00:00'),
(4007,11,12,0,'2026-06-01 10:00:00'),
(4008,11,13,0,'2026-06-01 10:00:00'),
(4009,11,14,0,'2026-06-01 10:00:00'),
(4010,11,15,1,'2026-06-01 10:00:00'),
(4001,12,19,1,'2026-06-01 11:00:00'),
(4002,12,20,1,'2026-06-01 11:00:00'),
(4003,12,21,1,'2026-06-01 11:00:00'),
(4004,12,22,1,'2026-06-01 11:00:00'),
(4005,12,23,1,'2026-06-01 11:00:00'),
(4001,13,21,1,'2026-06-01 11:00:00'),
(4002,13,22,1,'2026-06-01 11:00:00'),
(4003,13,23,1,'2026-06-01 11:00:00'),
(4004,13,24,1,'2026-06-01 11:00:00'),
(4005,13,25,1,'2026-06-01 11:00:00'),
(4001,14,23,1,'2026-06-01 11:00:00'),
(4002,14,24,1,'2026-06-01 11:00:00'),
(4003,14,25,1,'2026-06-01 11:00:00'),
(4004,14,10,0,'2026-06-01 11:00:00'),
(4005,14,11,0,'2026-06-01 11:00:00'),
(4001,15,25,1,'2026-06-01 11:00:00'),
(4002,15,10,0,'2026-06-01 11:00:00'),
(4003,15,11,0,'2026-06-01 11:00:00'),
(4004,15,12,0,'2026-06-01 11:00:00'),
(4005,15,13,0,'2026-06-01 11:00:00'),
(4001,16,11,0,'2026-06-01 11:00:00'),
(4002,16,12,0,'2026-06-01 11:00:00'),
(4003,16,13,0,'2026-06-01 11:00:00'),
(4004,16,14,0,'2026-06-01 11:00:00'),
(4005,16,15,1,'2026-06-01 11:00:00'),
(4001,17,13,0,'2026-06-01 11:00:00'),
(4002,17,14,0,'2026-06-01 11:00:00'),
(4003,17,15,1,'2026-06-01 11:00:00'),
(4004,17,16,1,'2026-06-01 11:00:00'),
(4005,17,17,1,'2026-06-01 11:00:00'),
(4001,18,15,1,'2026-06-01 11:00:00'),
(4002,18,16,1,'2026-06-01 11:00:00'),
(4003,18,17,1,'2026-06-01 11:00:00'),
(4004,18,18,1,'2026-06-01 11:00:00'),
(4005,18,19,1,'2026-06-01 11:00:00'),
(4001,19,17,1,'2026-06-01 11:00:00'),
(4002,19,18,1,'2026-06-01 11:00:00'),
(4003,19,19,1,'2026-06-01 11:00:00'),
(4004,19,20,1,'2026-06-01 11:00:00'),
(4005,19,21,1,'2026-06-01 11:00:00'),
(4001,20,19,1,'2026-06-01 11:00:00'),
(4002,20,20,1,'2026-06-01 11:00:00'),
(4003,20,21,1,'2026-06-01 11:00:00'),
(4004,20,22,1,'2026-06-01 11:00:00'),
(4005,20,23,1,'2026-06-01 11:00:00'),
(4001,21,21,1,'2026-06-01 11:00:00'),
(4002,21,22,1,'2026-06-01 11:00:00'),
(4003,21,23,1,'2026-06-01 11:00:00'),
(4004,21,24,1,'2026-06-01 11:00:00'),
(4005,21,25,1,'2026-06-01 11:00:00'),
(4101,2,33,1,'2026-06-15 09:00:00'),
(4102,2,36,1,'2026-06-15 09:00:00'),
(4103,2,39,1,'2026-06-15 09:00:00'),
(4104,2,42,1,'2026-06-15 09:00:00'),
(4105,2,45,1,'2026-06-15 09:00:00'),
(4101,3,34,1,'2026-06-15 09:00:00'),
(4102,3,37,1,'2026-06-15 09:00:00'),
(4103,3,40,1,'2026-06-15 09:00:00'),
(4104,3,43,1,'2026-06-15 09:00:00'),
(4105,3,46,1,'2026-06-15 09:00:00'),
(4101,4,35,1,'2026-06-15 09:00:00'),
(4102,4,38,1,'2026-06-15 09:00:00'),
(4103,4,41,1,'2026-06-15 09:00:00'),
(4104,4,44,1,'2026-06-15 09:00:00'),
(4105,4,47,1,'2026-06-15 09:00:00'),
(4101,5,36,1,'2026-06-15 09:00:00'),
(4102,5,39,1,'2026-06-15 09:00:00'),
(4103,5,42,1,'2026-06-15 09:00:00'),
(4104,5,45,1,'2026-06-15 09:00:00'),
(4105,5,48,1,'2026-06-15 09:00:00'),
(4101,6,37,1,'2026-06-15 09:00:00'),
(4102,6,40,1,'2026-06-15 09:00:00'),
(4103,6,43,1,'2026-06-15 09:00:00'),
(4104,6,46,1,'2026-06-15 09:00:00'),
(4105,6,49,1,'2026-06-15 09:00:00'),
(4101,7,38,1,'2026-06-15 09:00:00'),
(4102,7,41,1,'2026-06-15 09:00:00'),
(4103,7,44,1,'2026-06-15 09:00:00'),
(4104,7,47,1,'2026-06-15 09:00:00'),
(4105,7,50,1,'2026-06-15 09:00:00'),
(4101,8,39,1,'2026-06-15 09:00:00'),
(4102,8,42,1,'2026-06-15 09:00:00'),
(4103,8,45,1,'2026-06-15 09:00:00'),
(4104,8,48,1,'2026-06-15 09:00:00'),
(4105,8,28,0,'2026-06-15 09:00:00'),
(4101,9,40,1,'2026-06-15 09:00:00'),
(4102,9,43,1,'2026-06-15 09:00:00'),
(4103,9,46,1,'2026-06-15 09:00:00'),
(4104,9,49,1,'2026-06-15 09:00:00'),
(4105,9,29,0,'2026-06-15 09:00:00'),
(4101,10,41,1,'2026-06-15 09:00:00'),
(4102,10,44,1,'2026-06-15 09:00:00'),
(4103,10,47,1,'2026-06-15 09:00:00'),
(4104,10,50,1,'2026-06-15 09:00:00'),
(4105,10,30,1,'2026-06-15 09:00:00'),
(4101,11,42,1,'2026-06-15 09:00:00'),
(4102,11,45,1,'2026-06-15 09:00:00'),
(4103,11,48,1,'2026-06-15 09:00:00'),
(4104,11,28,0,'2026-06-15 09:00:00'),
(4105,11,31,1,'2026-06-15 09:00:00'),
(4101,12,43,1,'2026-06-15 09:00:00'),
(4102,12,46,1,'2026-06-15 09:00:00'),
(4103,12,49,1,'2026-06-15 09:00:00'),
(4104,12,29,0,'2026-06-15 09:00:00'),
(4105,12,32,1,'2026-06-15 09:00:00'),
(4101,13,44,1,'2026-06-15 09:00:00'),
(4102,13,47,1,'2026-06-15 09:00:00'),
(4103,13,50,1,'2026-06-15 09:00:00'),
(4104,13,30,1,'2026-06-15 09:00:00'),
(4105,13,33,1,'2026-06-15 09:00:00'),
(4101,14,45,1,'2026-06-15 09:00:00'),
(4102,14,48,1,'2026-06-15 09:00:00'),
(4103,14,28,0,'2026-06-15 09:00:00'),
(4104,14,31,1,'2026-06-15 09:00:00'),
(4105,14,34,1,'2026-06-15 09:00:00'),
(4101,15,46,1,'2026-06-15 09:00:00'),
(4102,15,49,1,'2026-06-15 09:00:00'),
(4103,15,29,0,'2026-06-15 09:00:00'),
(4104,15,32,1,'2026-06-15 09:00:00'),
(4105,15,35,1,'2026-06-15 09:00:00'),
(4101,16,47,1,'2026-06-15 09:00:00'),
(4102,16,50,1,'2026-06-15 09:00:00'),
(4103,16,30,1,'2026-06-15 09:00:00'),
(4104,16,33,1,'2026-06-15 09:00:00'),
(4105,16,36,1,'2026-06-15 09:00:00'),
(4101,17,48,1,'2026-06-15 09:00:00'),
(4102,17,28,0,'2026-06-15 09:00:00'),
(4103,17,31,1,'2026-06-15 09:00:00'),
(4104,17,34,1,'2026-06-15 09:00:00'),
(4105,17,37,1,'2026-06-15 09:00:00'),
(4101,18,49,1,'2026-06-15 09:00:00'),
(4102,18,29,0,'2026-06-15 09:00:00'),
(4103,18,32,1,'2026-06-15 09:00:00'),
(4104,18,35,1,'2026-06-15 09:00:00'),
(4105,18,38,1,'2026-06-15 09:00:00'),
(4101,19,50,1,'2026-06-15 09:00:00'),
(4102,19,30,1,'2026-06-15 09:00:00'),
(4103,19,33,1,'2026-06-15 09:00:00'),
(4104,19,36,1,'2026-06-15 09:00:00'),
(4105,19,39,1,'2026-06-15 09:00:00'),
(4101,20,28,0,'2026-06-15 09:00:00'),
(4102,20,31,1,'2026-06-15 09:00:00'),
(4103,20,34,1,'2026-06-15 09:00:00'),
(4104,20,37,1,'2026-06-15 09:00:00'),
(4105,20,40,1,'2026-06-15 09:00:00'),
(4101,21,29,0,'2026-06-15 09:00:00'),
(4102,21,32,1,'2026-06-15 09:00:00'),
(4103,21,35,1,'2026-06-15 09:00:00'),
(4104,21,38,1,'2026-06-15 09:00:00'),
(4105,21,41,1,'2026-06-15 09:00:00');

INSERT INTO student_answer_record(exam_record_id, question_id, selected_option, is_correct)
SELECT r.id, eq.question_id,
       CASE WHEN r.is_passed=1 THEN q.correct_option WHEN q.correct_option='A' THEN 'B' ELSE 'A' END AS selected_option,
       CASE WHEN r.is_passed=1 THEN 1 ELSE 0 END AS is_correct
FROM student_exam_record r
JOIN exam_question eq ON eq.exam_id=r.exam_id
JOIN question_bank q ON q.id=eq.question_id;

-- 初始化一次 GPA，后续学生手动补做课后测验后会通过提交流程重新计算并更新
INSERT INTO student_gpa(student_id,total_credits,total_grade_point,gpa,risk_level)
SELECT t.student_id,
       SUM(s.credit) AS total_credits,
       ROUND(SUM(t.point * s.credit), 2) AS total_grade_point,
       ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) AS gpa,
       CASE
         WHEN ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) < 1.5 THEN 'RED'
         WHEN ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) < 2.0 THEN 'ORANGE'
         WHEN ROUND(SUM(t.point * s.credit) / NULLIF(SUM(s.credit), 0), 1) < 2.5 THEN 'YELLOW'
         ELSE 'GREEN'
       END AS risk_level
FROM (
  SELECT r.student_id, e.subject_id,
         CASE
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 90 THEN 4.0
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 85 THEN 3.7
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 82 THEN 3.3
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 78 THEN 3.0
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 75 THEN 2.7
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 72 THEN 2.3
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 69 THEN 2.0
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 65 THEN 1.7
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) >= 61 THEN 1.3
           WHEN MAX((r.score * 100.0) / NULLIF(e.total_score,0)) = 60 THEN 1.0
           ELSE 0
         END AS point
  FROM student_exam_record r
  JOIN exams e ON r.exam_id=e.id
  WHERE e.exam_type='FINAL'
  GROUP BY r.student_id, e.subject_id
) t
JOIN subjects s ON s.id=t.subject_id
GROUP BY t.student_id
ON DUPLICATE KEY UPDATE
  total_credits=VALUES(total_credits),
  total_grade_point=VALUES(total_grade_point),
  gpa=VALUES(gpa),
  risk_level=VALUES(risk_level);
