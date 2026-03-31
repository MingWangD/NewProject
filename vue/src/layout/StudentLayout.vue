<template>
  <el-container style="height:100vh">
    <el-aside width="220px">
      <el-menu router>
        <el-menu-item index="/student/exams">考试列表</el-menu-item>
        <el-menu-item index="/student/score">成绩页</el-menu-item>
        <el-menu-item index="/student/state">学习状态</el-menu-item>
        <el-menu-item index="/student/timetable">课程表</el-menu-item>
        <el-menu-item index="/student/profile">个人资料</el-menu-item>
      </el-menu>
    </el-aside>
    <el-main><router-view /></el-main>
  </el-container>
</template>
