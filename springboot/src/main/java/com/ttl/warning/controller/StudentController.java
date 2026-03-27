package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/student")
public class StudentController {
    private final GpaMapper gpaMapper;
    private final AttendanceMapper attendanceMapper;
    private final ExamRecordMapper examRecordMapper;

    public StudentController(GpaMapper gpaMapper, AttendanceMapper attendanceMapper, ExamRecordMapper examRecordMapper) {
        this.gpaMapper = gpaMapper;
        this.attendanceMapper = attendanceMapper;
        this.examRecordMapper = examRecordMapper;
    }

    @GetMapping("/{studentId}/state")
    public ApiResponse<?> state(@PathVariable Long studentId) {
        Map<String, Object> map = new HashMap<>();
        map.put("gpa", gpaMapper.findByStudent(studentId));
        map.put("attendanceCount", attendanceMapper.countByStudent(studentId));
        map.put("records", examRecordMapper.findByStudent(studentId));
        return ApiResponse.ok(map);
    }
}
