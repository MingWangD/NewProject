<template>
  <el-card>
    <el-table :data="exams">
      <el-table-column prop="name" label="考试名称"/>
      <el-table-column prop="subjectName" label="科目"/>
      <el-table-column label="操作">
        <template #default="scope"><el-button @click="go(scope.row.id)">参加考试</el-button></template>
      </el-table-column>
    </el-table>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
import router from '@/router';
const exams = ref([])
const user = JSON.parse(localStorage.getItem('user') || '{}')
const load = async()=> exams.value=(await request.get('/exam/list')).data
const go = async (id)=>{
  const can = (await request.get(`/exam/${id}/can-attend/${user.id}`)).data.canAttend
  if (!can) return alert('出勤不达标，禁止参加考试')
  router.push(`/student/exam/${id}`)
}
onMounted(load)
</script>
