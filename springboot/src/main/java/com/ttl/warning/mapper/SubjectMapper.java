package com.ttl.warning.mapper;

import com.ttl.warning.entity.Subject;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SubjectMapper {
    @Select("select * from subjects order by id")
    List<Subject> findAll();
}
