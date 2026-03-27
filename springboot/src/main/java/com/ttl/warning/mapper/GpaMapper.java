package com.ttl.warning.mapper;

import com.ttl.warning.entity.StudentGpa;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface GpaMapper {
    @Insert("insert into student_gpa(student_id,total_credits,total_grade_point,gpa,risk_level) values(#{studentId},#{totalCredits},#{totalGradePoint},#{gpa},#{riskLevel}) on duplicate key update total_credits=values(total_credits), total_grade_point=values(total_grade_point), gpa=values(gpa), risk_level=values(risk_level)")
    int upsert(StudentGpa gpa);

    @Select("select * from student_gpa where student_id=#{studentId}")
    StudentGpa findByStudent(Long studentId);

    @Select("select risk_level as riskLevel, count(*) as count from student_gpa group by risk_level")
    List<Map<String, Object>> riskStats();

    @Select("select avg(gpa) from student_gpa")
    Double avgGpa();
}
