package com.ttl.warning.controller;

import com.ttl.warning.common.ApiResponse;
import com.ttl.warning.dto.CreateExamRequest;
import com.ttl.warning.dto.SubmitExamRequest;
import com.ttl.warning.mapper.ExamMapper;
import com.ttl.warning.mapper.ExamRecordMapper;
import com.ttl.warning.service.ExamService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/exam")
public class ExamController {
    private final ExamService examService;
    private final ExamMapper examMapper;
    private final ExamRecordMapper examRecordMapper;

    public ExamController(ExamService examService, ExamMapper examMapper, ExamRecordMapper examRecordMapper) {
        this.examService = examService;
        this.examMapper = examMapper;
        this.examRecordMapper = examRecordMapper;
    }

    @PostMapping("/create")
    public ApiResponse<?> create(@RequestBody CreateExamRequest request) {
        try {
            return ApiResponse.ok(examService.createExam(request));
        } catch (Exception e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    @GetMapping("/list")
    public ApiResponse<?> list() {
        return ApiResponse.ok(examMapper.findAllWithSubject());
    }

    @GetMapping("/{examId}/questions")
    public ApiResponse<?> questions(@PathVariable Long examId) {
        return ApiResponse.ok(examMapper.findQuestionsByExam(examId));
    }

    @GetMapping("/{examId}/can-attend/{studentId}")
    public ApiResponse<?> canAttend(@PathVariable Long examId, @PathVariable Long studentId) {
        return ApiResponse.ok(examService.canAttendDetail(examId, studentId));
    }

    @PostMapping("/submit")
    public ApiResponse<?> submit(@RequestBody SubmitExamRequest request) {
        try {
            return ApiResponse.ok(examService.submit(request));
        } catch (Exception e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    @GetMapping("/{examId}/scores")
    public ApiResponse<?> scores(@PathVariable Long examId) {
        return ApiResponse.ok(examRecordMapper.findScoresByExam(examId));
    }

    @GetMapping("/record/{recordId}/answers")
    public ApiResponse<?> answers(@PathVariable Long recordId) {
        return ApiResponse.ok(examRecordMapper.findAnswerDetails(recordId));
    }
}
