package com.ttl.warning.entity;

import java.time.LocalDateTime;

public class ExamRecord {
    private Long id;
    private Long examId;
    private Long studentId;
    private Integer score;
    private Integer isPassed;
    private LocalDateTime submitTime;
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getExamId() { return examId; }
    public void setExamId(Long examId) { this.examId = examId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }
    public Integer getIsPassed() { return isPassed; }
    public void setIsPassed(Integer isPassed) { this.isPassed = isPassed; }
    public LocalDateTime getSubmitTime() { return submitTime; }
    public void setSubmitTime(LocalDateTime submitTime) { this.submitTime = submitTime; }
}
