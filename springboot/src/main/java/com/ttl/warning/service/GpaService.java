package com.ttl.warning.service;

import com.ttl.warning.entity.StudentGpa;
import com.ttl.warning.entity.Subject;
import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.SubjectMapper;
import com.ttl.warning.mapper.UserMapper;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class GpaService {
    private final ExamRecordMapper examRecordMapper;
    private final SubjectMapper subjectMapper;
    private final GpaMapper gpaMapper;
    private final UserMapper userMapper;
    private final AttendanceMapper attendanceMapper;

    public GpaService(ExamRecordMapper examRecordMapper, SubjectMapper subjectMapper, GpaMapper gpaMapper,
                      UserMapper userMapper, AttendanceMapper attendanceMapper) {
        this.examRecordMapper = examRecordMapper;
        this.subjectMapper = subjectMapper;
        this.gpaMapper = gpaMapper;
        this.userMapper = userMapper;
        this.attendanceMapper = attendanceMapper;
    }

    public void recalculateAllStudents() {
        List<Map<String, Object>> rows = examRecordMapper.findAllForRiskModel();
        if (rows == null || rows.isEmpty()) {
            return;
        }
        List<Subject> subjects = subjectMapper.findAll();
        Map<Long, Integer> creditMap = new HashMap<>();
        int maxHours = 0;
        for (Subject s : subjects) {
            creditMap.put(s.getId(), s.getCredit());
            maxHours = Math.max(maxHours, s.getTotalHours());
        }

        Map<Long, Map<Long, SubjectScores>> byStudentSubject = new HashMap<>();
        Map<Long, List<Double>> regularScores = new HashMap<>();
        Map<Long, List<Double>> finalScores = new HashMap<>();
        Map<Long, Integer> passCount = new HashMap<>();
        Map<Long, Integer> totalCount = new HashMap<>();

        for (Map<String, Object> row : rows) {
            Long studentId = ((Number) row.get("studentId")).longValue();
            Long subjectId = ((Number) row.get("subjectId")).longValue();
            String examType = String.valueOf(row.get("examType"));
            double percentScore = ((Number) row.get("percentScore")).doubleValue();
            int isPassed = ((Number) row.get("isPassed")).intValue();

            byStudentSubject
                    .computeIfAbsent(studentId, k -> new HashMap<>())
                    .computeIfAbsent(subjectId, k -> new SubjectScores())
                    .add(examType, percentScore);

            if ("FINAL".equalsIgnoreCase(examType)) {
                finalScores.computeIfAbsent(studentId, k -> new ArrayList<>()).add(percentScore);
            } else {
                regularScores.computeIfAbsent(studentId, k -> new ArrayList<>()).add(percentScore);
            }
            passCount.put(studentId, passCount.getOrDefault(studentId, 0) + (isPassed == 1 ? 1 : 0));
            totalCount.put(studentId, totalCount.getOrDefault(studentId, 0) + 1);
        }

        for (User student : userMapper.findStudents()) {
            Long studentId = student.getId();
            Map<Long, SubjectScores> subjectScores = byStudentSubject.getOrDefault(studentId, Collections.emptyMap());
            if (subjectScores.isEmpty()) {
                continue;
            }
            int totalCredits = 0;
            double totalGradePoint = 0;

            for (Map.Entry<Long, SubjectScores> entry : subjectScores.entrySet()) {
                Long subjectId = entry.getKey();
                int credit = creditMap.getOrDefault(subjectId, 0);
                SubjectScores ss = entry.getValue();
                Double weightedPercent = ss.weightedPercent();
                Double finalAvgBySubject = ss.finalAvg();
                if (weightedPercent == null) continue;
                if (finalAvgBySubject != null && finalAvgBySubject < 60) continue;
                double point = scoreToPoint((int) Math.round(weightedPercent));
                totalCredits += credit;
                totalGradePoint += point * credit;
            }

            double gpa = totalCredits == 0 ? 0 : Math.round((totalGradePoint / totalCredits) * 10.0) / 10.0;

            double regularAvg = avg(regularScores.get(studentId), 55);
            double finalAvg = avg(finalScores.get(studentId), regularAvg);
            double passRate = totalCount.getOrDefault(studentId, 0) == 0 ? 0
                    : passCount.getOrDefault(studentId, 0) * 1.0 / totalCount.get(studentId);
            double attendanceRate = maxHours == 0 ? 0
                    : Math.min(attendanceMapper.countByStudent(studentId) * 1.0 / maxHours, 1.0);

            double riskProb = logisticRisk(regularAvg, finalAvg, attendanceRate, passRate);

            StudentGpa gpaRow = new StudentGpa();
            gpaRow.setStudentId(studentId);
            gpaRow.setTotalCredits(totalCredits);
            gpaRow.setTotalGradePoint(Math.round(totalGradePoint * 100.0) / 100.0);
            gpaRow.setGpa(gpa);
            gpaRow.setRiskLevel(riskColor(riskProb));
            gpaMapper.upsert(gpaRow);
        }
    }


    public List<Map<String, Object>> subjectGpaDetails(Long studentId) {
        List<Map<String, Object>> rows = examRecordMapper.findRiskRowsByStudent(studentId);
        List<Subject> subjects = subjectMapper.findAll();

        Map<Long, SubjectScores> map = new HashMap<>();
        for (Map<String, Object> row : rows) {
            Long subjectId = ((Number) row.get("subjectId")).longValue();
            String examType = String.valueOf(row.get("examType"));
            double percentScore = ((Number) row.get("percentScore")).doubleValue();
            map.computeIfAbsent(subjectId, k -> new SubjectScores()).add(examType, percentScore);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Subject subject : subjects) {
            SubjectScores ss = map.getOrDefault(subject.getId(), new SubjectScores());
            Double regAvg = ss.regularAvg();
            Double finalAvg = ss.finalAvg();
            Double weighted = ss.weightedPercent();

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("subjectId", subject.getId());
            item.put("subjectName", subject.getName());
            item.put("regularAvg", regAvg == null ? null : Math.round(regAvg * 10.0) / 10.0);
            item.put("finalAvg", finalAvg == null ? null : Math.round(finalAvg * 10.0) / 10.0);

            if (finalAvg == null) {
                item.put("status", "NO_FINAL");
                item.put("subjectGpa", null);
                item.put("remark", "未参加期末考试");
            } else if (finalAvg < 60) {
                item.put("status", "FAILED");
                item.put("subjectGpa", null);
                item.put("remark", "期末考试未及格，挂科");
            } else {
                double point = scoreToPoint((int) Math.round(weighted == null ? finalAvg : weighted));
                item.put("status", "PASSED");
                item.put("subjectGpa", Math.round(point * 10.0) / 10.0);
                item.put("remark", "有效");
            }
            result.add(item);
        }
        return result;
    }

    private double avg(List<Double> values, double fallback) {
        if (values == null || values.isEmpty()) return fallback;
        return values.stream().mapToDouble(Double::doubleValue).average().orElse(fallback);
    }

    private double logisticRisk(double regularAvg, double finalAvg, double attendanceRate, double passRate) {
        double z = 3.2
                - 0.035 * regularAvg
                - 0.045 * finalAvg
                - 2.2 * attendanceRate
                - 1.8 * passRate;
        return 1.0 / (1.0 + Math.exp(-z));
    }

    private String riskColor(double riskProbability) {
        if (riskProbability >= 0.75) return "RED";
        if (riskProbability >= 0.55) return "ORANGE";
        if (riskProbability >= 0.35) return "YELLOW";
        return "GREEN";
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

    private static class SubjectScores {
        private final List<Double> regular = new ArrayList<>();
        private final List<Double> fin = new ArrayList<>();

        void add(String type, double score) {
            if ("FINAL".equalsIgnoreCase(type)) fin.add(score);
            else regular.add(score);
        }

        Double regularAvg() {
            return regular.isEmpty() ? null : regular.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        }

        Double finalAvg() {
            return fin.isEmpty() ? null : fin.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        }

        Double weightedPercent() {
            Double regAvg = regularAvg();
            Double finAvg = finalAvg();
            if (regAvg == null && finAvg == null) return null;
            if (regAvg == null) return finAvg;
            if (finAvg == null) return regAvg;
            return regAvg * 0.3 + finAvg * 0.7;
        }
    }
}
