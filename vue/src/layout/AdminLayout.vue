<template>
  <el-container style="height:100vh">
    <el-aside width="220px">
      <el-menu router>
        <el-menu-item index="/admin/exam-create">考试创建</el-menu-item>
        <el-menu-item index="/admin/scores">成绩列表</el-menu-item>
        <el-menu-item index="/admin/attendance">出勤统计</el-menu-item>
        <el-menu-item index="/admin/dashboard">风险看板</el-menu-item>
      </el-menu>
    </el-aside>
    <el-main><router-view /></el-main>
  </el-container>
</template>
