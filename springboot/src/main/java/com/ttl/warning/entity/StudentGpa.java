package com.ttl.warning.entity;

public class StudentGpa {
    private Long studentId;
    private Integer totalCredits;
    private Double totalGradePoint;
    private Double gpa;
    private String riskLevel;
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    public Integer getTotalCredits() { return totalCredits; }
    public void setTotalCredits(Integer totalCredits) { this.totalCredits = totalCredits; }
    public Double getTotalGradePoint() { return totalGradePoint; }
    public void setTotalGradePoint(Double totalGradePoint) { this.totalGradePoint = totalGradePoint; }
    public Double getGpa() { return gpa; }
    public void setGpa(Double gpa) { this.gpa = gpa; }
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
}
