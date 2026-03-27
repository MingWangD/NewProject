<template>
  <el-card>
    <template #header><b>出勤统计（总登录次数）</b></template>
    <el-table :data="rows" border>
      <el-table-column prop="studentId" label="学生ID" width="100"/>
      <el-table-column prop="studentName" label="姓名" width="120"/>
      <el-table-column prop="attendanceCount" label="总出勤次数"/>
    </el-table>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
const rows = ref([])
onMounted(async()=>rows.value=(await request.get('/admin/attendance')).data)
</script>
