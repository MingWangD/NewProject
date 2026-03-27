<template>
  <el-card>
    <template #header><b>学生成绩列表</b></template>
    <el-select v-model="examId" placeholder="选择考试" @change="loadScores" style="width: 300px">
      <el-option v-for="e in exams" :key="e.id" :value="e.id" :label="`${e.name} - ${e.subjectName}`"/>
    </el-select>
    <el-table :data="scores" border style="margin-top:10px">
      <el-table-column prop="studentName" label="学生"/>
      <el-table-column prop="score" label="成绩"/>
      <el-table-column prop="isPassed" label="是否通过">
        <template #default="scope">
          <el-tag :type="scope.row.isPassed===1 ? 'success' : 'danger'">{{ scope.row.isPassed===1 ? '通过' : '未通过' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope"><el-button @click="go(scope.row.id)">答题详情</el-button></template>
      </el-table-column>
    </el-table>
  </el-card>
</template>
<script setup>
import { ref, onMounted } from 'vue';
import request from '@/utils/request';
import router from '@/router';
const exams = ref([]); const scores = ref([]); const examId = ref(null)
const loadExams = async ()=> exams.value = (await request.get('/exam/list')).data
const loadScores = async ()=> scores.value = (await request.get(`/exam/${examId.value}/scores`)).data
const go = (id)=> router.push(`/admin/answers/${id}`)
onMounted(loadExams)
</script>
