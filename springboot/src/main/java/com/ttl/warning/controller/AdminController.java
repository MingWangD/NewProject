package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.entity.Subject;
import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.SubjectMapper;
import com.ttl.warning.mapper.UserMapper;
import com.ttl.warning.service.GpaService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminController {
    private final AttendanceMapper attendanceMapper;
    private final UserMapper userMapper;
    private final SubjectMapper subjectMapper;
    private final GpaMapper gpaMapper;
    private final ExamRecordMapper examRecordMapper;
    private final GpaService gpaService;

    public AdminController(AttendanceMapper attendanceMapper, UserMapper userMapper, SubjectMapper subjectMapper,
                           GpaMapper gpaMapper, ExamRecordMapper examRecordMapper, GpaService gpaService) {
        this.attendanceMapper = attendanceMapper;
        this.userMapper = userMapper;
        this.subjectMapper = subjectMapper;
        this.gpaMapper = gpaMapper;
        this.examRecordMapper = examRecordMapper;
        this.gpaService = gpaService;
    }

    @GetMapping("/attendance")
    public ApiResponse<?> attendanceStats() {
        return ApiResponse.ok(attendanceMapper.countAll());
    }

    @GetMapping("/students")
    public ApiResponse<?> students() {
        List<User> students = userMapper.findStudents();
        students.forEach(s -> s.setPassword(null));
        return ApiResponse.ok(students);
    }

    @GetMapping("/student-course-query")
    public ApiResponse<?> studentCourseQuery(@RequestParam Long studentId, @RequestParam Long subjectId) {
        gpaService.recalculateAllStudents();
        Map<String, Object> resp = new HashMap<>();
        User student = userMapper.findById(studentId);
        Subject subject = subjectMapper.findById(subjectId);

        resp.put("student", student);
        resp.put("subject", subject);
        resp.put("attendanceCount", attendanceMapper.countByStudent(studentId));
        resp.put("overallGpa", gpaMapper.findByStudent(studentId));
        resp.put("regularRecords", examRecordMapper.findRegularRecordsByStudentAndSubject(studentId, subjectId));

        List<Map<String, Object>> subjectRows = gpaService.subjectGpaDetails(studentId);
        Map<String, Object> target = subjectRows.stream()
                .filter(i -> subjectId.equals(((Number) i.get("subjectId")).longValue()))
                .findFirst()
                .orElse(new HashMap<>());
        resp.put("subjectGpa", target);
        return ApiResponse.ok(resp);
    }

    @GetMapping("/dashboard")
    public ApiResponse<?> dashboard() {
        gpaService.recalculateAllStudents();
        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> risk = gpaMapper.riskStats();
        map.put("risk", risk);
        map.put("avgScore", examRecordMapper.averageScore());
        map.put("avgGpa", gpaMapper.avgGpa());

        int students = userMapper.findStudents().size();
        int maxHours = subjectMapper.maxTotalHours() == null ? 0 : subjectMapper.maxTotalHours();
        double attendanceRate = (students == 0 || maxHours == 0) ? 0 : attendanceMapper.totalLoginRecords() * 1.0 / (students * maxHours);
        map.put("attendanceRate", Math.min(attendanceRate, 1.0));
        map.put("passRate", examRecordMapper.passRate());
        return ApiResponse.ok(map);
    }
}
