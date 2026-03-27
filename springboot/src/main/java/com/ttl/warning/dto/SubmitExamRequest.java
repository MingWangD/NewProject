package com.ttl.warning.dto;

import java.util.List;

public class SubmitExamRequest {
    private Long examId;
    private Long studentId;
    private List<AnswerItem> answers;

    public static class AnswerItem {
        private Long questionId;
        private String selectedOption;
        public Long getQuestionId() { return questionId; }
        public void setQuestionId(Long questionId) { this.questionId = questionId; }
        public String getSelectedOption() { return selectedOption; }
        public void setSelectedOption(String selectedOption) { this.selectedOption = selectedOption; }
    }

    public Long getExamId() { return examId; }
    public void setExamId(Long examId) { this.examId = examId; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public List<AnswerItem> getAnswers() { return answers; }
    public void setAnswers(List<AnswerItem> answers) { this.answers = answers; }
}
