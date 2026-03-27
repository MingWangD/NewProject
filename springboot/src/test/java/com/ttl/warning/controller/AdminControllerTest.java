package com.ttl.warning.controller;

import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.mapper.SubjectMapper;
import com.ttl.warning.mapper.UserMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AdminController.class)
class AdminControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AttendanceMapper attendanceMapper;

    @MockBean
    private UserMapper userMapper;

    @MockBean
    private SubjectMapper subjectMapper;

    @MockBean
    private GpaMapper gpaMapper;

    @MockBean
    private ExamRecordMapper examRecordMapper;

    @Test
    void adminEndpointsShouldReturnSuccess() throws Exception {
        User student = new User();
        student.setId(2L);
        student.setRole("STUDENT");

        when(attendanceMapper.countAll()).thenReturn(List.of(Map.of("studentId", 2, "attendance", 20)));
        when(gpaMapper.riskStats()).thenReturn(List.of(Map.of("risk", "GREEN", "count", 1)));
        when(examRecordMapper.averageScore()).thenReturn(80.0);
        when(gpaMapper.avgGpa()).thenReturn(3.2);
        when(userMapper.findStudents()).thenReturn(List.of(student));
        when(subjectMapper.maxTotalHours()).thenReturn(100);
        when(attendanceMapper.totalLoginRecords()).thenReturn(80);
        when(examRecordMapper.passRate()).thenReturn(0.9);

        mockMvc.perform(get("/api/admin/attendance"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/admin/dashboard"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.avgGpa").value(3.2));
    }
}
