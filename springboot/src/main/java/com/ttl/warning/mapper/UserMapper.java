package com.ttl.warning.mapper;

import com.ttl.warning.entity.User;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserMapper {
    @Select("select * from users where username=#{username} and role=#{role}")
    User findByUsernameAndRole(@Param("username") String username, @Param("role") String role);

    @Select("select * from users where id=#{id}")
    User findById(Long id);

    @Select("select * from users where role='STUDENT'")
    List<User> findStudents();
}
