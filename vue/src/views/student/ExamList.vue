<template>
  <el-card>
    <template #header><b>可参加考试</b></template>
    <el-table :data="exams" border>
      <el-table-column prop="name" label="考试名称"/>
      <el-table-column prop="subjectName" label="课程"/>
      <el-table-column label="出勤门槛">
        <template #default="scope">
          <el-tag :type="scope.row.canAttend ? 'success' : 'danger'">
            {{scope.row.attendance}} / {{scope.row.requiredAttendance}} ({{ scope.row.canAttend ? '达标' : '不达标' }})
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope"><el-button :disabled="!scope.row.canAttend" type="primary" @click="go(scope.row.id)">参加考试</el-button></template>
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
const load = async()=> {
  const list = (await request.get('/exam/list')).data
  const merged = []
  for (const exam of list) {
    const rule = (await request.get(`/exam/${exam.id}/can-attend/${user.id}`)).data
    merged.push({ ...exam, ...rule })
  }
  exams.value = merged
}
const go = (id)=> router.push(`/student/exam/${id}`)
onMounted(load)
</script>
