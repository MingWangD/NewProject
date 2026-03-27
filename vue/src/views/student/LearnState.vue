<template>
  <el-card>
    <p>出勤次数：{{state.attendanceCount}}</p>
    <p>当前GPA：{{state.gpa?.gpa}}</p>
    <p>总学分：{{state.gpa?.totalCredits}}</p>
    <p>学分绩点：{{state.gpa?.totalGradePoint}}</p>
    <p>风险等级：{{state.gpa?.riskLevel}}</p>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
const user=JSON.parse(localStorage.getItem('user')||'{}'); const state=ref({})
onMounted(async()=>state.value=(await request.get(`/student/${user.id}/state`)).data)
</script>
