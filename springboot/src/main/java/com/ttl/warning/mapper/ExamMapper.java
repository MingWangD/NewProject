package com.ttl.warning.mapper;

import com.ttl.warning.entity.Exam;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface ExamMapper {
    @Insert("insert into exams(name, subject_id, total_score, pass_score, course_hours, start_time, end_time) values(#{name},#{subjectId},#{totalScore},#{passScore},#{courseHours},#{startTime},#{endTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Exam exam);

    @Insert("insert into exam_question(exam_id, question_id) values(#{examId}, #{questionId})")
    int insertExamQuestion(@Param("examId") Long examId, @Param("questionId") Long questionId);

    @Select("select e.*, s.name as subject_name from exams e left join subjects s on e.subject_id=s.id order by e.id desc")
    List<Map<String, Object>> findAllWithSubject();

    @Select("select * from exams where id=#{id}")
    Exam findById(Long id);

    @Select("select q.* from question_bank q join exam_question eq on q.id=eq.question_id where eq.exam_id=#{examId}")
    List<Map<String, Object>> findQuestionsByExam(Long examId);
}
