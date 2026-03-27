package com.ttl.warning.dto;

import java.time.LocalDateTime;
import java.util.List;

public class CreateExamRequest {
    private String name;
    private Long subjectId;
    private Integer passScore;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private List<Long> questionIds;
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }
    public Integer getPassScore() { return passScore; }
    public void setPassScore(Integer passScore) { this.passScore = passScore; }
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    public List<Long> getQuestionIds() { return questionIds; }
    public void setQuestionIds(List<Long> questionIds) { this.questionIds = questionIds; }
}
