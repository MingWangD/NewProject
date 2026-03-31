<template>
  <el-card>
    <template #header><b>各课程 GPA 结果</b></template>
    <el-table :data="rows" border>
      <el-table-column prop="subjectName" label="课程"/>
      <el-table-column prop="regularAvg" label="课后测验均分"/>
      <el-table-column prop="finalAvg" label="期末分数"/>
      <el-table-column label="课程GPA">
        <template #default="scope">
          {{ scope.row.status === 'FAILED' ? '-' : (scope.row.subjectGpa ?? '-') }}
        </template>
      </el-table-column>
      <el-table-column label="结果">
        <template #default="scope">
          <el-tag v-if="scope.row.status === 'FAILED'" type="danger">挂科</el-tag>
          <el-tag v-else-if="scope.row.status === 'PASSED'" type="success">通过</el-tag>
          <el-tag v-else type="info">未完成</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="remark" label="说明"/>
    </el-table>
  </el-card>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import request from '@/utils/request'

const user = JSON.parse(localStorage.getItem('user') || '{}')
const rows = ref([])

onMounted(async () => {
  rows.value = (await request.get(`/student/${user.id}/subject-gpa`)).data || []
})
</script>
