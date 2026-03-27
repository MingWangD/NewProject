package com.ttl.warning.mapper;

import org.apache.ibatis.annotations.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface AttendanceMapper {
    @Insert("insert ignore into login_attendance(student_id, login_date) values(#{studentId}, #{day})")
    int record(@Param("studentId") Long studentId, @Param("day") LocalDate day);

    @Select("select count(*) from login_attendance where student_id=#{studentId}")
    int countByStudent(Long studentId);

    @Select("select student_id as studentId, count(*) as attendanceCount from login_attendance group by student_id")
    List<Map<String, Object>> countAll();

    @Select("select count(*) from login_attendance")
    int totalLoginRecords();
}
