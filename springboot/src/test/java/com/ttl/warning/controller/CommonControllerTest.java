package com.ttl.warning.controller;

import com.ttl.warning.mapper.QuestionMapper;
import com.ttl.warning.mapper.SubjectMapper;
import com.ttl.warning.entity.Question;
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

@WebMvcTest(CommonController.class)
class CommonControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SubjectMapper subjectMapper;

    @MockBean
    private QuestionMapper questionMapper;

    @Test
    void subjectsAndQuestionsEndpointsShouldReturnSuccess() throws Exception {
        when(subjectMapper.findAll()).thenReturn(List.of());
        Question q = new Question();
        q.setId(1001L);
        q.setContent("Q1");
        when(questionMapper.findBySubject(1L)).thenReturn(List.of(q));

        mockMvc.perform(get("/api/common/subjects"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"));

        mockMvc.perform(get("/api/common/questions/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data[0].id").value(1001));
    }
}
