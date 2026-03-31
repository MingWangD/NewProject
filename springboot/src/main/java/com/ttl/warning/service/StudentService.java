package com.ttl.warning.service;

import com.ttl.warning.entity.User;
import com.ttl.warning.mapper.ExamMapper;
import com.ttl.warning.mapper.UserMapper;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;

@Service
public class StudentService {
    private final UserMapper userMapper;
    private final ExamMapper examMapper;
    private final GpaService gpaService;

    public StudentService(UserMapper userMapper, ExamMapper examMapper, GpaService gpaService) {
        this.userMapper = userMapper;
        this.examMapper = examMapper;
        this.gpaService = gpaService;
    }

    public User updateProfile(Long studentId, User payload) {
        User existed = userMapper.findById(studentId);
        if (existed == null || !"STUDENT".equals(existed.getRole())) {
            throw new RuntimeException("学生不存在");
        }
        existed.setUsername(payload.getUsername());
        existed.setRealName(payload.getRealName());
        existed.setEmail(payload.getEmail());
        userMapper.updateStudentProfile(existed);
        existed.setPassword(null);
        return existed;
    }

    public Map<String, Object> pendingExamSummary(Long studentId) {
        Map<String, Object> resp = new HashMap<>();
        resp.put("pendingCount", examMapper.countPendingByStudent(studentId));
        return resp;
    }

    public List<Map<String, Object>> subjectGpaDetails(Long studentId) {
        return gpaService.subjectGpaDetails(studentId);
    }

    public List<Map<String, Object>> weeklyTimetable(LocalDate weekStart) {
        // 当前返回的是本学期公共示例课表，不区分学生个体
        LocalDate semesterStart = LocalDate.of(2026, 3, 1);
        LocalDate semesterEnd = LocalDate.of(2026, 6, 30);
        LocalDate monday = weekStart.with(DayOfWeek.MONDAY);
        if (monday.isBefore(semesterStart.with(DayOfWeek.MONDAY))) {
            monday = semesterStart.with(DayOfWeek.MONDAY);
        }
        if (monday.isAfter(semesterEnd.with(DayOfWeek.MONDAY))) {
            monday = semesterEnd.with(DayOfWeek.MONDAY);
        }

        List<Map<String, Object>> slots = new ArrayList<>();
        addSlot(slots, monday.plusDays(0), "08:00-10:00", "高等数学", "博学楼A201", "李老师");
        addSlot(slots, monday.plusDays(1), "10:20-12:00", "数据结构", "博学楼B302", "王老师");
        addSlot(slots, monday.plusDays(2), "14:00-16:00", "操作系统", "博学楼C105", "赵老师");
        addSlot(slots, monday.plusDays(3), "08:00-10:00", "计算机网络", "博学楼A305", "陈老师");
        addSlot(slots, monday.plusDays(4), "14:00-16:00", "Java程序设计", "实验楼D203", "周老师");

        slots.removeIf(item -> {
            LocalDate d = LocalDate.parse((String) item.get("date"));
            return d.isBefore(semesterStart) || d.isAfter(semesterEnd);
        });
        return slots;
    }

    private void addSlot(List<Map<String, Object>> slots, LocalDate date, String time, String subject, String room, String teacher) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("date", date.toString());
        m.put("weekDay", date.getDayOfWeek().name());
        m.put("timeRange", time);
        m.put("subject", subject);
        m.put("classroom", room);
        m.put("teacher", teacher);
        slots.add(m);
    }
}
