package com.ttl.warning.service;

import com.ttl.warning.entity.StudentGpa;
import com.ttl.warning.entity.Subject;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.SubjectMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GpaService {
    private final ExamRecordMapper examRecordMapper;
    private final SubjectMapper subjectMapper;
    private final GpaMapper gpaMapper;

    public GpaService(ExamRecordMapper examRecordMapper, SubjectMapper subjectMapper, GpaMapper gpaMapper) {
        this.examRecordMapper = examRecordMapper;
        this.subjectMapper = subjectMapper;
        this.gpaMapper = gpaMapper;
    }

    public void recalculateAllStudents() {
        List<Map<String, Object>> scores = examRecordMapper.bestScoresBySubjectAndStudent();
        List<Subject> subjects = subjectMapper.findAll();
        Map<Long, Integer> creditMap = new HashMap<>();
        for (Subject s : subjects) {
            creditMap.put(s.getId(), s.getCredit());
        }

        Map<Long, StudentGpa> result = new HashMap<>();
        for (Map<String, Object> item : scores) {
            Long studentId = ((Number) item.get("studentId")).longValue();
            Long subjectId = ((Number) item.get("subjectId")).longValue();
            Integer score = ((Number) item.get("score")).intValue();
            int credit = creditMap.getOrDefault(subjectId, 0);
            double point = scoreToPoint(score);
            StudentGpa gpa = result.computeIfAbsent(studentId, k -> {
                StudentGpa x = new StudentGpa();
                x.setStudentId(k);
                x.setTotalCredits(0);
                x.setTotalGradePoint(0.0);
                x.setGpa(0.0);
                x.setRiskLevel("HIGH");
                return x;
            });
            gpa.setTotalCredits(gpa.getTotalCredits() + credit);
            gpa.setTotalGradePoint(gpa.getTotalGradePoint() + point * credit);
        }

        for (StudentGpa gpa : result.values()) {
            double value = gpa.getTotalCredits() == 0 ? 0 : gpa.getTotalGradePoint() / gpa.getTotalCredits();
            value = Math.round(value * 10.0) / 10.0;
            gpa.setGpa(value);
            gpa.setRiskLevel(value < 2.0 ? "HIGH" : (value <= 3.0 ? "MEDIUM" : "LOW"));
            gpaMapper.upsert(gpa);
        }
    }

    public double scoreToPoint(Integer score) {
        if (score >= 90) return 4.0;
        if (score >= 85) return 3.7;
        if (score >= 82) return 3.3;
        if (score >= 78) return 3.0;
        if (score >= 75) return 2.7;
        if (score >= 72) return 2.3;
        if (score >= 69) return 2.0;
        if (score >= 65) return 1.7;
        if (score >= 61) return 1.3;
        if (score == 60) return 1.0;
        return 0;
    }
}
