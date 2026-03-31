package com.ttl.warning.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ttl.warning.entity.StudentGpa;
import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.UserMapper;
import com.ttl.warning.service.StudentService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(StudentController.class)
class StudentControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private GpaMapper gpaMapper;

    @MockBean
    private AttendanceMapper attendanceMapper;

    @MockBean
    private ExamRecordMapper examRecordMapper;

    @MockBean
    private UserMapper userMapper;

    @MockBean
    private StudentService studentService;

    @Test
    void stateEndpointShouldReturnSuccess() throws Exception {
        StudentGpa gpa = new StudentGpa();
        gpa.setStudentId(2L);
        gpa.setGpa(3.5);
        when(gpaMapper.findByStudent(2L)).thenReturn(gpa);
        when(attendanceMapper.countByStudent(2L)).thenReturn(25);
        when(examRecordMapper.findByStudent(2L)).thenReturn(List.of(Map.of("examId", 1, "score", 88)));

        mockMvc.perform(get("/api/student/2/state"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.attendanceCount").value(25));
    }

    @Test
    void profileAndPendingEndpointsShouldReturnSuccess() throws Exception {
        User u = new User();
        u.setId(2L);
        u.setUsername("stu1");
        u.setRealName("张三");
        u.setRole("STUDENT");
        u.setEmail("stu1@example.com");
        when(userMapper.findById(2L)).thenReturn(u);
        when(studentService.pendingExamSummary(2L)).thenReturn(Map.of("pendingCount", 3));
        when(studentService.subjectGpaDetails(2L)).thenReturn(List.of(Map.of("subjectId", 1, "status", "PASSED")));
        when(studentService.weeklyTimetable(any())).thenReturn(List.of(Map.of("subject", "高等数学")));
        when(studentService.updateProfile(any(), any())).thenReturn(u);

        mockMvc.perform(get("/api/student/2/profile"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.username").value("stu1"));

        mockMvc.perform(get("/api/student/2/pending-exams"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.pendingCount").value(3));

        mockMvc.perform(get("/api/student/2/timetable").param("weekStart", "2026-03-09"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/student/2/subject-gpa"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(put("/api/student/2/profile")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(Map.of("username", "stu001", "realName", "张三", "email", "a@b.com"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));
    }
}
