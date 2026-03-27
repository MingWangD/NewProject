# 基于逻辑回归算法的学情智能预警系统（全栈）

## 1. 技术栈
- 后端：Spring Boot 3 + MyBatis + MySQL 5.7
- 前端：Vue3 + Vite + Element Plus

## 2. 固定课程（本学期）
- 高等数学（4学分，64学时）
- 数据结构（4学分，48学时）
- 操作系统（3学分，48学时）
- 计算机网络（3学分，32学时）
- Java程序设计（4学分，64学时）

> 业务上改为“在固定课程下发布考试”，不再在创建考试时设置课程学时。

## 3. 风险预警规则（按 GPA 颜色）
- 红色预警：GPA < 1.5
- 橙色预警：1.5 ≤ GPA < 2.0
- 黄色预警：2.0 ≤ GPA ≤ 2.5
- 正常：GPA > 2.5

## 4. 目录结构
- `springboot/`：后端
- `vue/`：前端
- `springboot/src/main/resources/sql/schema.sql`：完整建表 SQL + 初始化数据

## 5. 启动说明
### 数据库
1. 创建 MySQL 数据库并执行：`springboot/src/main/resources/sql/schema.sql`
2. 脚本已初始化：管理员、多个学生、固定课程、每门课程20题（共100题）、以及“部分出勤达标/不达标”的登录记录。

### 后端
```bash
cd springboot
mvn spring-boot:run
```

### 前端
```bash
cd vue
npm install
npm run dev
```

## 6. 关键接口
### 认证
- `POST /api/auth/login`：登录（学生登录自动记1次出勤/天）

### 公共数据
- `GET /api/common/subjects`：固定课程列表（含学分、学时）
- `GET /api/common/questions/{subjectId}`：按课程拉题库

### 考试
- `POST /api/exam/create`：管理员在课程下发布考试（题库勾选组卷）
- `GET /api/exam/list`：考试列表
- `GET /api/exam/{examId}/questions`：考试题目
- `GET /api/exam/{examId}/can-attend/{studentId}`：校验出勤门槛（返回当前出勤、要求出勤）
- `POST /api/exam/submit`：提交考试并自动判题/算分/GPA刷新
- `GET /api/exam/{examId}/scores`：管理员查看某场考试成绩
- `GET /api/exam/record/{recordId}/answers`：查看答题详情

### 学生
- `GET /api/student/{studentId}/state`：学习状态（成绩/GPA/风险/出勤）

### 管理员
- `GET /api/admin/attendance`：学生出勤统计
- `GET /api/admin/dashboard`：风险统计、均分、平均GPA、出勤率、通过率
