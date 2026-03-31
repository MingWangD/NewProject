package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.UserMapper;
import com.ttl.warning.service.StudentService;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/student")
public class StudentController {
    private final GpaMapper gpaMapper;
    private final AttendanceMapper attendanceMapper;
    private final ExamRecordMapper examRecordMapper;
    private final UserMapper userMapper;
    private final StudentService studentService;

    public StudentController(GpaMapper gpaMapper, AttendanceMapper attendanceMapper, ExamRecordMapper examRecordMapper,
                             UserMapper userMapper, StudentService studentService) {
        this.gpaMapper = gpaMapper;
        this.attendanceMapper = attendanceMapper;
        this.examRecordMapper = examRecordMapper;
        this.userMapper = userMapper;
        this.studentService = studentService;
    }

    @GetMapping("/{studentId}/state")
    public ApiResponse<?> state(@PathVariable Long studentId) {
        Map<String, Object> map = new HashMap<>();
        map.put("gpa", gpaMapper.findByStudent(studentId));
        map.put("attendanceCount", attendanceMapper.countByStudent(studentId));
        map.put("records", examRecordMapper.findByStudent(studentId));
        return ApiResponse.ok(map);
    }

    @GetMapping("/{studentId}/profile")
    public ApiResponse<?> profile(@PathVariable Long studentId) {
        User user = userMapper.findById(studentId);
        if (user == null || !"STUDENT".equals(user.getRole())) return ApiResponse.fail("学生不存在");
        user.setPassword(null);
        return ApiResponse.ok(user);
    }

    @PutMapping("/{studentId}/profile")
    public ApiResponse<?> updateProfile(@PathVariable Long studentId, @RequestBody User user) {
        try {
            return ApiResponse.ok(studentService.updateProfile(studentId, user));
        } catch (Exception e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    @GetMapping("/{studentId}/pending-exams")
    public ApiResponse<?> pendingExams(@PathVariable Long studentId) {
        return ApiResponse.ok(studentService.pendingExamSummary(studentId));
    }

    @GetMapping("/{studentId}/timetable")
    public ApiResponse<?> timetable(@PathVariable Long studentId, @RequestParam(required = false) String weekStart) {
        LocalDate date = weekStart == null ? LocalDate.now() : LocalDate.parse(weekStart);
        return ApiResponse.ok(studentService.weeklyTimetable(date));
    }
}
