<template>
  <el-card>
    <p>出勤次数：{{state.attendanceCount}}</p>
    <p>当前GPA：{{state.gpa?.gpa}}</p>
    <p>总学分：{{state.gpa?.totalCredits}}</p>
    <p>学分绩点：{{state.gpa?.totalGradePoint}}</p>
    <p>风险等级：
      <el-tag :type="tagType(state.gpa?.riskLevel)">{{ label(state.gpa?.riskLevel) }}</el-tag>
    </p>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
const user=JSON.parse(localStorage.getItem('user')||'{}'); const state=ref({})
const label = (r)=> ({RED:'红色预警', ORANGE:'橙色预警', YELLOW:'黄色预警', GREEN:'正常'}[r] || '-')
const tagType = (r)=> ({RED:'danger', ORANGE:'warning', YELLOW:'warning', GREEN:'success'}[r] || 'info')
onMounted(async()=>state.value=(await request.get(`/student/${user.id}/state`)).data)
</script>
