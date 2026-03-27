package com.ttl.warning.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ttl.warning.entity.User;
import com.ttl.warning.service.AuthService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AuthController.class)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private AuthService authService;

    @Test
    void loginShouldReturnSuccessWhenCredentialsAreValid() throws Exception {
        User user = new User();
        user.setId(1L);
        user.setUsername("student1");
        user.setPassword("secret");
        user.setRole("STUDENT");

        when(authService.login(any())).thenReturn(user);

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(Map.of(
                                "username", "student1",
                                "password", "secret",
                                "role", "STUDENT"
                        ))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("200"))
                .andExpect(jsonPath("$.data.username").value("student1"))
                .andExpect(jsonPath("$.data.password").doesNotExist());
    }
}
