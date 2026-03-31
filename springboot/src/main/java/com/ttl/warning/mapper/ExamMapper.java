package com.ttl.warning.mapper;

import com.ttl.warning.entity.Exam;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface ExamMapper {
    @Insert("insert into exams(name, subject_id, total_score, pass_score, start_time, end_time, exam_type) values(#{name},#{subjectId},#{totalScore},#{passScore},#{startTime},#{endTime},#{examType})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Exam exam);

    @Insert("insert into exam_question(exam_id, question_id) values(#{examId}, #{questionId})")
    int insertExamQuestion(@Param("examId") Long examId, @Param("questionId") Long questionId);

    @Select("select e.*, s.name as subject_name from exams e left join subjects s on e.subject_id=s.id order by e.id desc")
    List<Map<String, Object>> findAllWithSubject();

    @Select("select count(*) from exams e left join student_exam_record r on e.id=r.exam_id and r.student_id=#{studentId} where r.id is null")
    int countPendingByStudent(Long studentId);

    @Delete("delete from exam_question where exam_id=#{examId}")
    int deleteQuestionsByExam(Long examId);

    @Delete("delete from exams where id=#{examId}")
    int deleteExam(Long examId);

    @Select("select * from exams where id=#{id}")
    Exam findById(Long id);

    @Select("select q.id, q.subject_id as subjectId, q.content, q.option_a as optionA, q.option_b as optionB, q.option_c as optionC, q.option_d as optionD, q.correct_option as correctOption, q.score " +
            "from question_bank q join exam_question eq on q.id=eq.question_id where eq.exam_id=#{examId}")
    List<Map<String, Object>> findQuestionsByExam(Long examId);
}
