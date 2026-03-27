<template>
  <el-card>
    <el-table :data="records" border>
      <el-table-column prop="examName" label="考试名称"/>
      <el-table-column prop="score" label="成绩"/>
      <el-table-column prop="isPassed" label="通过">
        <template #default="scope">
          <el-tag :type="scope.row.isPassed===1 ? 'success':'danger'">{{ scope.row.isPassed===1 ? '通过' : '未通过' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="submitTime" label="提交时间"/>
      <el-table-column label="操作" width="120">
        <template #default="scope"><el-button @click="view(scope.row.id)">详情</el-button></template>
      </el-table-column>
    </el-table>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import router from '@/router';
import request from '@/utils/request';
const user=JSON.parse(localStorage.getItem('user')||'{}'); const records=ref([])
onMounted(async()=>records.value=(await request.get(`/student/${user.id}/state`)).data.records)
const view = (recordId)=> router.push(`/student/result/${recordId}`)
</script>
