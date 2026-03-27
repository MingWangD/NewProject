package com.ttl.warning.service;

import com.ttl.warning.dto.LoginRequest;
import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.AttendanceMapper;
import com.ttl.warning.mapper.UserMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class AuthService {
    private final UserMapper userMapper;
    private final AttendanceMapper attendanceMapper;

    public AuthService(UserMapper userMapper, AttendanceMapper attendanceMapper) {
        this.userMapper = userMapper;
        this.attendanceMapper = attendanceMapper;
    }

    public User login(LoginRequest request) {
        User user = userMapper.findByUsernameAndRole(request.getUsername(), request.getRole());
        if (user == null || !user.getPassword().equals(request.getPassword())) {
            return null;
        }
        if ("STUDENT".equals(user.getRole())) {
            attendanceMapper.record(user.getId(), LocalDate.now());
        }
        return user;
    }
}
