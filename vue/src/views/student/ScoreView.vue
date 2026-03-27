<template><el-card><el-table :data="records"><el-table-column prop="examId" label="考试ID"/><el-table-column prop="score" label="成绩"/><el-table-column prop="isPassed" label="通过"/></el-table></el-card></template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
const user=JSON.parse(localStorage.getItem('user')||'{}'); const records=ref([])
onMounted(async()=>records.value=(await request.get(`/student/${user.id}/state`)).data.records)
</script>
