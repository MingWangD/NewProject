package com.ttl.warning.service;

import com.ttl.warning.dto.CreateExamRequest;
import com.ttl.warning.dto.SubmitExamRequest;
import com.ttl.warning.entity.Exam;
import com.ttl.warning.entity.Question;
import com.ttl.warning.entity.Subject;
import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class ExamService {
    private final ExamMapper examMapper;
    private final QuestionMapper questionMapper;
    private final ExamRecordMapper examRecordMapper;
    private final AttendanceMapper attendanceMapper;
    private final SubjectMapper subjectMapper;
    private final GpaService gpaService;
    private final GpaMapper gpaMapper;
    private final UserMapper userMapper;

    public ExamService(ExamMapper examMapper, QuestionMapper questionMapper, ExamRecordMapper examRecordMapper,
                       AttendanceMapper attendanceMapper, SubjectMapper subjectMapper,
                       GpaService gpaService, GpaMapper gpaMapper, UserMapper userMapper) {
        this.examMapper = examMapper;
        this.questionMapper = questionMapper;
        this.examRecordMapper = examRecordMapper;
        this.attendanceMapper = attendanceMapper;
        this.subjectMapper = subjectMapper;
        this.gpaService = gpaService;
        this.gpaMapper = gpaMapper;
        this.userMapper = userMapper;
    }

    @Transactional
    public Long createExam(CreateExamRequest req) {
        if (req == null) {
            throw new RuntimeException("请求参数不能为空");
        }
        if (req.getName() == null || req.getName().trim().isEmpty()) {
            throw new RuntimeException("考试名称不能为空");
        }
        if (req.getSubjectId() == null) {
            throw new RuntimeException("课程不能为空");
        }
        if (req.getPassScore() == null || req.getPassScore() <= 0) {
            throw new RuntimeException("及格分必须大于0");
        }
        if (req.getStartTime() == null || req.getEndTime() == null) {
            throw new RuntimeException("开始时间和结束时间不能为空");
        }
        if (!req.getStartTime().isBefore(req.getEndTime())) {
            throw new RuntimeException("开始时间必须早于结束时间");
        }
        String examType = req.getExamType() == null ? "REGULAR" : req.getExamType().trim().toUpperCase();
        if (!"REGULAR".equals(examType) && !"FINAL".equals(examType)) {
            throw new RuntimeException("考试类型仅支持 REGULAR 或 FINAL");
        }
        if (req.getQuestionIds() == null || req.getQuestionIds().isEmpty()) {
            throw new RuntimeException("题目列表不能为空");
        }
        int totalScore = 0;
        for (Long qid : req.getQuestionIds()) {
            Question q = questionMapper.findById(qid);
            if (q == null || !q.getSubjectId().equals(req.getSubjectId())) {
                throw new RuntimeException("题目必须属于已选课程");
            }
            totalScore += q.getScore();
        }
        if (req.getPassScore() > totalScore) {
            throw new RuntimeException("及格分不能大于试卷总分");
        }
        Exam exam = new Exam();
        exam.setName(req.getName().trim());
        exam.setSubjectId(req.getSubjectId());
        exam.setPassScore(req.getPassScore());
        exam.setStartTime(req.getStartTime());
        exam.setEndTime(req.getEndTime());
        exam.setExamType(examType);
        exam.setTotalScore(totalScore);
        examMapper.insert(exam);
        for (Long qid : req.getQuestionIds()) {
            examMapper.insertExamQuestion(exam.getId(), qid);
        }
        return exam.getId();
    }

    public Map<String, Object> canAttendDetail(Long examId, Long studentId) {
        Exam exam = examMapper.findById(examId);
        if (exam == null) {
            throw new RuntimeException("考试不存在");
        }
        Subject subject = subjectMapper.findById(exam.getSubjectId());
        if (subject == null) {
            throw new RuntimeException("考试所属课程不存在");
        }
        int attendance = attendanceMapper.countByStudent(studentId);
        boolean isFinal = "FINAL".equalsIgnoreCase(exam.getExamType());
        int required = isFinal ? (int) Math.ceil(subject.getTotalHours() * 2.0 / 3.0) : 0;
        Map<String, Object> result = new HashMap<>();
        result.put("canAttend", !isFinal || attendance >= required);
        result.put("attendance", attendance);
        result.put("requiredAttendance", required);
        result.put("subjectHours", subject.getTotalHours());
        result.put("attendanceRule", isFinal ? "FINAL_REQUIRED" : "NONE");
        result.put("attendanceRuleText", isFinal
                ? "期末考试需满足累计登录次数门槛"
                : "课后测验不受累计登录次数门槛限制");
        return result;
    }

    public boolean canAttend(Long examId, Long studentId) {
        return (boolean) canAttendDetail(examId, studentId).get("canAttend");
    }

    @Transactional
    public Map<String, Object> submit(SubmitExamRequest req) {
        if (req == null || req.getExamId() == null || req.getStudentId() == null) {
            throw new RuntimeException("提交参数不完整");
        }
        User user = userMapper.findById(req.getStudentId());
        if (user == null) {
            throw new RuntimeException("学生不存在");
        }
        User student = userMapper.findStudentById(req.getStudentId());
        if (student == null) {
            throw new RuntimeException("仅学生允许提交考试");
        }
        if (req.getAnswers() == null) {
            throw new RuntimeException("答题内容不能为空");
        }
        if (!canAttend(req.getExamId(), req.getStudentId())) {
            throw new RuntimeException("累计登录次数未达门槛，禁止参加考试");
        }
        Exam exam = examMapper.findById(req.getExamId());
        if (exam == null) {
            throw new RuntimeException("考试不存在");
        }
        if (LocalDateTime.now().isBefore(exam.getStartTime()) || LocalDateTime.now().isAfter(exam.getEndTime())) {
            throw new RuntimeException("当前不在考试开放时间内");
        }
        if (examRecordMapper.countByExamAndStudent(req.getExamId(), req.getStudentId()) > 0) {
            throw new RuntimeException("该考试仅允许提交一次");
        }

        int score = 0;
        Map<Long, Question> questionMap = new HashMap<>();
        for (Map<String, Object> item : examMapper.findQuestionsByExam(req.getExamId())) {
            Question q = new Question();
            q.setId(((Number) item.get("id")).longValue());
            q.setCorrectOption((String) item.get("correctOption"));
            q.setScore(((Number) item.get("score")).intValue());
            questionMap.put(q.getId(), q);
        }

        for (SubmitExamRequest.AnswerItem ans : req.getAnswers()) {
            if (ans == null || ans.getQuestionId() == null || ans.getSelectedOption() == null) {
                throw new RuntimeException("答题内容不完整");
            }
            Question q = questionMap.get(ans.getQuestionId());
            if (q == null) {
                throw new RuntimeException("存在不属于该考试的题目");
            }
            if (q.getCorrectOption() != null && q.getCorrectOption().equalsIgnoreCase(ans.getSelectedOption())) {
                score += q.getScore();
            }
        }
        int passed = score >= exam.getPassScore() ? 1 : 0;

        Map<String, Object> recordRow = new HashMap<>();
        recordRow.put("examId", req.getExamId());
        recordRow.put("studentId", req.getStudentId());
        recordRow.put("score", score);
        recordRow.put("isPassed", passed);
        examRecordMapper.insert(recordRow);
        Long recordId = ((Number) recordRow.get("id")).longValue();

        for (SubmitExamRequest.AnswerItem ans : req.getAnswers()) {
            Question q = questionMap.get(ans.getQuestionId());
            int correct = q != null && q.getCorrectOption() != null && q.getCorrectOption().equalsIgnoreCase(ans.getSelectedOption()) ? 1 : 0;
            examRecordMapper.insertAnswer(recordId, ans.getQuestionId(), ans.getSelectedOption(), correct);
        }

        gpaService.recalculateStudent(req.getStudentId());

        Map<String, Object> resp = new HashMap<>();
        resp.put("recordId", recordId);
        resp.put("score", score);
        resp.put("passed", passed == 1);
        resp.put("gpa", gpaMapper.findByStudent(req.getStudentId()));
        return resp;
    }

    @Transactional
    public void revokeExam(Long examId) {
        if (examRecordMapper.countByExam(examId) > 0) {
            throw new RuntimeException("已有学生完成该考试，无法撤销");
        }
        examMapper.deleteQuestionsByExam(examId);
        if (examMapper.deleteExam(examId) == 0) {
            throw new RuntimeException("考试不存在或已删除");
        }
    }

}
