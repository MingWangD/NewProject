# 基于逻辑回归算法的学情智能预警系统（全栈）

## 1. 技术栈
- 后端：Spring Boot 3 + MyBatis + MySQL 5.7
- 前端：Vue3 + Vite + Element Plus + ECharts

## 2. 目录结构
- `springboot/`：后端
- `vue/`：前端
- `springboot/src/main/resources/sql/schema.sql`：完整建表 SQL

## 3. 启动说明
### 数据库
1. 创建 MySQL 数据库并执行：
   `springboot/src/main/resources/sql/schema.sql`

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

## 4. 关键接口
### 认证
- `POST /api/auth/login`：登录（学生登录自动记1次出勤/天）

### 公共数据
- `GET /api/common/subjects`：固定5科目
- `GET /api/common/questions/{subjectId}`：按科目拉题库

### 考试
- `POST /api/exam/create`：管理员创建考试（题库勾选组卷）
- `GET /api/exam/list`：考试列表
- `GET /api/exam/{examId}/questions`：考试题目
- `GET /api/exam/{examId}/can-attend/{studentId}`：校验出勤是否可考试
- `POST /api/exam/submit`：提交考试并自动判题/算分/GPA刷新
- `GET /api/exam/{examId}/scores`：管理员查看某场考试成绩
- `GET /api/exam/record/{recordId}/answers`：查看某条考试答题详情

### 学生
- `GET /api/student/{studentId}/state`：学习状态（成绩/GPA/风险/出勤）

### 管理员
- `GET /api/admin/attendance`：学生总出勤
- `GET /api/admin/dashboard`：风险统计、均分、平均GPA、出勤率、通过率
