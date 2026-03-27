package com.ttl.warning.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ttl.warning.mapper.ExamMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.service.ExamService;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ExamController.class)
class ExamControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private ExamService examService;

    @MockBean
    private ExamMapper examMapper;

    @MockBean
    private ExamRecordMapper examRecordMapper;

    @Test
    void allExamEndpointsShouldReturnSuccess() throws Exception {
        when(examService.createExam(any())).thenReturn(1L);
        when(examMapper.findAllWithSubject()).thenReturn(List.of(Map.of("id", 1, "name", "期中考试")));
        when(examMapper.findQuestionsByExam(1L)).thenReturn(List.of(Map.of("id", 11, "content", "Q")));
        when(examService.canAttendDetail(1L, 2L)).thenReturn(Map.of("canAttend", true));
        when(examService.submit(any())).thenReturn(Map.of("score", 95));
        when(examRecordMapper.findScoresByExam(1L)).thenReturn(List.of(Map.of("studentId", 2, "score", 95)));
        when(examRecordMapper.findByExamAndStudent(1L, 2L)).thenReturn(Map.of("id", 99, "score", 95));
        when(examRecordMapper.findAnswerDetails(9L)).thenReturn(List.of(Map.of("questionId", 11, "selectedOption", "A")));
        when(examRecordMapper.findRecordMeta(9L)).thenReturn(Map.of("recordId", 9, "examName", "期中考试", "studentName", "张三"));

        mockMvc.perform(post("/api/exam/create")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(Map.of(
                                "name", "期中考试",
                                "subjectId", 1,
                                "passScore", 60,
                                "questionIds", List.of(11, 12)
                        ))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/exam/list"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/exam/1/questions"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/exam/1/can-attend/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.canAttend").value(true));

        mockMvc.perform(post("/api/exam/submit")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(Map.of(
                                "examId", 1,
                                "studentId", 2,
                                "answers", List.of(Map.of("questionId", 11, "selectedOption", "A"))
                        ))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/exam/1/scores"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/exam/1/record/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.id").value(99));

        mockMvc.perform(get("/api/exam/record/9/answers"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/exam/record/9/meta"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.studentName").value("张三"));
    }
}
