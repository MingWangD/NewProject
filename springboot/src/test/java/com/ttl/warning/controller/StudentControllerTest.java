package com.ttl.warning.controller;

import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.mapper.GpaMapper;
import com.ttl.warning.entity.StudentGpa;
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

@WebMvcTest(StudentController.class)
class StudentControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private GpaMapper gpaMapper;

    @MockBean
    private AttendanceMapper attendanceMapper;

    @MockBean
    private ExamRecordMapper examRecordMapper;

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
}
