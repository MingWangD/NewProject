package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.entity.Subject;
import com.ttl.warning.mapper.QuestionMapper;
import com.ttl.warning.mapper.SubjectMapper;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/common")
public class CommonController {
    private final SubjectMapper subjectMapper;
    private final QuestionMapper questionMapper;

    public CommonController(SubjectMapper subjectMapper, QuestionMapper questionMapper) {
        this.subjectMapper = subjectMapper;
        this.questionMapper = questionMapper;
    }

    @GetMapping("/subjects")
    public ApiResponse<List<Subject>> subjects() {
        return ApiResponse.ok(subjectMapper.findAll());
    }

    @GetMapping("/questions/{subjectId}")
    public ApiResponse<?> questions(@PathVariable Long subjectId) {
        return ApiResponse.ok(questionMapper.findBySubject(subjectId));
    }
}
