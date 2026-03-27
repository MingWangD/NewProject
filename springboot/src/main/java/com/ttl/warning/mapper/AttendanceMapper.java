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

    @Select("select u.id as studentId, u.real_name as studentName, count(a.id) as attendanceCount from users u left join login_attendance a on u.id=a.student_id where u.role='STUDENT' group by u.id, u.real_name order by u.id")
    List<Map<String, Object>> countAll();

    @Select("select count(*) from login_attendance")
    int totalLoginRecords();
}
