package com.ttl.warning.service;

import com.ttl.warning.dto.CreateExamRequest;
import com.ttl.warning.dto.SubmitExamRequest;
import com.ttl.warning.entity.Exam;
import com.ttl.warning.entity.Question;
import com.ttl.warning.entity.Subject;
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

    public ExamService(ExamMapper examMapper, QuestionMapper questionMapper, ExamRecordMapper examRecordMapper,
                       AttendanceMapper attendanceMapper, SubjectMapper subjectMapper,
                       GpaService gpaService, GpaMapper gpaMapper) {
        this.examMapper = examMapper;
        this.questionMapper = questionMapper;
        this.examRecordMapper = examRecordMapper;
        this.attendanceMapper = attendanceMapper;
        this.subjectMapper = subjectMapper;
        this.gpaService = gpaService;
        this.gpaMapper = gpaMapper;
    }

    @Transactional
    public Long createExam(CreateExamRequest req) {
        int totalScore = 0;
        for (Long qid : req.getQuestionIds()) {
            Question q = questionMapper.findById(qid);
            if (q == null || !q.getSubjectId().equals(req.getSubjectId())) {
                throw new RuntimeException("题目必须属于已选课程");
            }
            totalScore += q.getScore();
        }
        Exam exam = new Exam();
        exam.setName(req.getName());
        exam.setSubjectId(req.getSubjectId());
        exam.setPassScore(req.getPassScore());
        exam.setStartTime(req.getStartTime());
        exam.setEndTime(req.getEndTime());
        exam.setTotalScore(totalScore);
        examMapper.insert(exam);
        for (Long qid : req.getQuestionIds()) {
            examMapper.insertExamQuestion(exam.getId(), qid);
        }
        return exam.getId();
    }

    public Map<String, Object> canAttendDetail(Long examId, Long studentId) {
        Exam exam = examMapper.findById(examId);
        Subject subject = subjectMapper.findById(exam.getSubjectId());
        int attendance = attendanceMapper.countByStudent(studentId);
        int required = (int) Math.ceil(subject.getTotalHours() * 2.0 / 3.0);
        Map<String, Object> result = new HashMap<>();
        result.put("canAttend", attendance >= required);
        result.put("attendance", attendance);
        result.put("requiredAttendance", required);
        result.put("subjectHours", subject.getTotalHours());
        return result;
    }

    public boolean canAttend(Long examId, Long studentId) {
        return (boolean) canAttendDetail(examId, studentId).get("canAttend");
    }

    @Transactional
    public Map<String, Object> submit(SubmitExamRequest req) {
        if (!canAttend(req.getExamId(), req.getStudentId())) {
            throw new RuntimeException("出勤不达标，禁止参加考试");
        }
        Exam exam = examMapper.findById(req.getExamId());
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
            Question q = questionMap.get(ans.getQuestionId());
            if (q != null && q.getCorrectOption() != null && q.getCorrectOption().equalsIgnoreCase(ans.getSelectedOption())) {
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

        gpaService.recalculateAllStudents();

        Map<String, Object> resp = new HashMap<>();
        resp.put("recordId", recordId);
        resp.put("score", score);
        resp.put("passed", passed == 1);
        resp.put("gpa", gpaMapper.findByStudent(req.getStudentId()));
        return resp;
    }
}
