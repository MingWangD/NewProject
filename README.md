# 基于逻辑回归算法的学情智能预警系统（全栈）

## 1. 技术栈
- 后端：Spring Boot 3 + MyBatis + MySQL 5.7
- 前端：Vue3 + Vite + Element Plus + Echarts

## 2. 固定课程（本学期）
- 高等数学（4学分，64学时）
- 数据结构（4学分，48学时）
- 操作系统（4学分，48学时）
- 计算机网络（4学分，32学时）
- Java程序设计（4学分，64学时）

> 业务上改为“在固定课程下发布考试”，不再在创建考试时设置课程学时。

## 3. 考试分类
- 课后测验（`REGULAR`）
- 期末考试（`FINAL`）

> 仅期末考试要求出勤达到课程学时的 2/3，课后测验不受出勤门槛限制。

## 4. 风险预警规则（按 GPA 颜色）
- 红色预警：GPA < 1.5
- 橙色预警：1.5 ≤ GPA < 2.0
- 黄色预警：2.0 ≤ GPA < 2.5
- 正常：GPA ≥ 2.5

> `student_gpa.risk_level` 已改为 `VARCHAR(20)`，统一保存 `RED / ORANGE / YELLOW / GREEN`，不再使用 `HIGH / MEDIUM / LOW`。

## 5. GPA 计分说明（已改为百分制换算）
- 学生提交考试后先得到该场考试原始分（按所选题目分值累加）。
- 系统再自动换算为百分制：`百分制成绩 = 原始分 / 试卷总分 * 100`。
- GPA 计算使用上述百分制成绩，并按既定绩点规则换算。

## 6. 目录结构
- `springboot/`：后端
- `vue/`：前端
- `springboot/src/main/resources/sql/schema.sql`：完整建表 SQL + 初始化数据

## 7. 启动说明
### 数据库
1. 创建 MySQL 数据库并执行：`springboot/src/main/resources/sql/schema.sql`
2. 脚本已初始化：管理员、多个学生、固定课程、每门课程20题（共100题）、以及“部分出勤达标/不达标”的登录记录。
3. 如果你是从旧版本升级（`risk_level` 仍是 ENUM 或旧值），请额外执行：
   `springboot/src/main/resources/sql/migrations/20260327_alter_student_gpa_risk_level.sql`
4. 如果你的题库历史数据出现重复（例如同题带“第N题”后缀），请执行：
   `springboot/src/main/resources/sql/migrations/20260327_deduplicate_question_bank.sql`
5. 本次新增学生邮箱字段与历史考试样本（10名学生、每科7次），旧库升级请执行：
   `springboot/src/main/resources/sql/migrations/20260331_add_user_email_and_seed_history.sql`

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

## 8. 关键接口
### 认证
- `POST /api/auth/login`：登录（学生登录自动记1次出勤/天）

### 公共数据
- `GET /api/common/subjects`：固定课程列表（含学分、学时）
- `GET /api/common/questions/{subjectId}`：按课程拉题库

### 考试
- `POST /api/exam/create`：管理员在课程下发布考试（支持课后测验/期末考试）
- `GET /api/exam/list`：考试列表
- `DELETE /api/exam/{examId}/revoke`：撤销未被任何学生完成的考试（会删除考试与组卷关联）
- `GET /api/exam/{examId}/questions`：考试题目
- `GET /api/exam/{examId}/can-attend/{studentId}`：校验出勤门槛（返回当前出勤、要求出勤）
- `POST /api/exam/submit`：提交考试并自动判题/算分/GPA刷新
- `GET /api/exam/{examId}/scores`：管理员查看某场考试成绩
- `GET /api/exam/record/{recordId}/answers`：查看答题详情

### 学生
- `GET /api/student/{studentId}/state`：学习状态（成绩/GPA/风险/出勤）
- `GET /api/student/{studentId}/profile`：个人资料
- `PUT /api/student/{studentId}/profile`：更新姓名/学号ID/邮箱
- `GET /api/student/{studentId}/pending-exams`：未完成考试数量
- `GET /api/student/{studentId}/timetable?weekStart=YYYY-MM-DD`：按周查看课程表（2026年3月-6月）

### 管理员
- `GET /api/admin/attendance`：学生出勤统计
- `GET /api/admin/dashboard`：风险统计、均分、平均GPA、出勤率、通过率

## 9. 需求实现核对（对照原始 Prompt）
- ✅ 两个角色（STUDENT / ADMIN）已实现。
- ✅ 管理员端：考试创建、题库可视化组卷、成绩列表、答题详情、出勤统计、风险看板已实现。
- ✅ 学生端：登录记出勤、可参加考试列表、考试作答提交自动判题、成绩/学习状态查看已实现。
- ✅ 数据库：用户、科目、题库、考试、考试题关联、考试记录、答题记录、登录记录、GPA表全部包含，且登录记录有 `(student_id, login_date)` 唯一约束。
- ✅ 核心后端逻辑：统一返回结构、自动判题、GPA映射计算、出勤门槛限制考试都已落地。
- ✅ 看板图表已使用 Echarts（风险分布饼图 + 核心指标柱状图）。
- ℹ️ 原始 Prompt 中“HIGH/MEDIUM/LOW”规则，已按你的新规则替换为“红/橙/黄/绿（基于 GPA 分段）”。
