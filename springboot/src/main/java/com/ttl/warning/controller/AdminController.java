package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.SubjectMapper;
import com.ttl.warning.mapper.UserMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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

    public AdminController(AttendanceMapper attendanceMapper, UserMapper userMapper, SubjectMapper subjectMapper,
                           GpaMapper gpaMapper, ExamRecordMapper examRecordMapper) {
        this.attendanceMapper = attendanceMapper;
        this.userMapper = userMapper;
        this.subjectMapper = subjectMapper;
        this.gpaMapper = gpaMapper;
        this.examRecordMapper = examRecordMapper;
    }

    @GetMapping("/attendance")
    public ApiResponse<?> attendanceStats() {
        return ApiResponse.ok(attendanceMapper.countAll());
    }

    @GetMapping("/dashboard")
    public ApiResponse<?> dashboard() {
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
