package com.ttl.warning.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface ExamRecordMapper {
    @Insert("insert into student_exam_record(exam_id, student_id, score, is_passed, submit_time) values(#{examId}, #{studentId}, #{score}, #{isPassed}, now())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Map<String, Object> row);

    @Insert("insert into student_answer_record(exam_record_id, question_id, selected_option, is_correct) values(#{examRecordId},#{questionId},#{selectedOption},#{isCorrect})")
    int insertAnswer(@Param("examRecordId") Long examRecordId, @Param("questionId") Long questionId,
                     @Param("selectedOption") String selectedOption, @Param("isCorrect") Integer isCorrect);

    @Select("select count(*) from student_exam_record where exam_id=#{examId} and student_id=#{studentId}")
    int countByExamAndStudent(@Param("examId") Long examId, @Param("studentId") Long studentId);

    @Select("select r.id, r.score, r.is_passed as isPassed, r.submit_time, u.real_name as studentName from student_exam_record r join users u on r.student_id=u.id where r.exam_id=#{examId} order by r.submit_time desc")
    List<Map<String, Object>> findScoresByExam(Long examId);

    @Select("select a.*, q.content, q.correct_option as correctOption from student_answer_record a join question_bank q on a.question_id=q.id where a.exam_record_id=#{recordId}")
    List<Map<String, Object>> findAnswerDetails(Long recordId);

    @Select("select avg(score) from student_exam_record")
    Double averageScore();

    @Select("select sum(case when is_passed=1 then 1 else 0 end)*1.0/nullif(count(*),0) from student_exam_record")
    Double passRate();

    @Select("select e.subject_id as subjectId, r.student_id as studentId, max(r.score) as score from student_exam_record r join exams e on r.exam_id=e.id group by e.subject_id, r.student_id")
    List<Map<String, Object>> bestScoresBySubjectAndStudent();

    @Select("select r.exam_id as examId, e.name as examName, r.score, r.is_passed as isPassed, r.submit_time as submitTime from student_exam_record r join exams e on r.exam_id=e.id where r.student_id=#{studentId} order by r.submit_time desc")
    List<Map<String, Object>> findByStudent(Long studentId);
}
