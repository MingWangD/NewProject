<template><el-card><el-table :data="rows"><el-table-column prop="studentId" label="学生ID"/><el-table-column prop="attendanceCount" label="总出勤次数"/></el-table></el-card></template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
const rows = ref([])
onMounted(async()=>rows.value=(await request.get('/admin/attendance')).data)
</script>
