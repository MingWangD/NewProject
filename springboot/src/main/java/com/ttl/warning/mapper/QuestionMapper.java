package com.ttl.warning.mapper;

import com.ttl.warning.entity.Question;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface QuestionMapper {
    @Select("select * from question_bank where subject_id=#{subjectId}")
    List<Question> findBySubject(Long subjectId);

    @Select("select * from question_bank where id=#{id}")
    Question findById(Long id);
}
