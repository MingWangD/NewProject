<template>
  <el-card>
    <h3>考试创建（题库可视化选择）</h3>
    <el-form :model="form" label-width="100px">
      <el-form-item label="考试名称"><el-input v-model="form.name"/></el-form-item>
      <el-form-item label="科目">
        <el-select v-model="form.subjectId" @change="loadQuestions">
          <el-option v-for="s in subjects" :key="s.id" :value="s.id" :label="s.name"/>
        </el-select>
      </el-form-item>
      <el-form-item label="及格分"><el-input-number v-model="form.passScore"/></el-form-item>
      <el-form-item label="课程学时"><el-input-number v-model="form.courseHours"/></el-form-item>
      <el-form-item label="开始时间"><el-date-picker v-model="form.startTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss"/></el-form-item>
      <el-form-item label="结束时间"><el-date-picker v-model="form.endTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss"/></el-form-item>
      <el-form-item label="题目选择">
        <el-table :data="questions" @selection-change="(rows)=>form.questionIds=rows.map(i=>i.id)">
          <el-table-column type="selection" width="50"/>
          <el-table-column prop="content" label="题目"/>
          <el-table-column prop="score" label="分值" width="80"/>
        </el-table>
      </el-form-item>
      <el-button type="primary" @click="submit">创建考试</el-button>
    </el-form>
  </el-card>
</template>
<script setup>
import { reactive, ref, onMounted } from 'vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'

const subjects = ref([])
const questions = ref([])
const form = reactive({ name: '', subjectId: null, passScore: 60, courseHours: 48, startTime: '', endTime: '', questionIds: [] })

const loadSubjects = async () => subjects.value = (await request.get('/common/subjects')).data
const loadQuestions = async () => questions.value = (await request.get(`/common/questions/${form.subjectId}`)).data
const submit = async () => {
  const res = await request.post('/exam/create', form)
  res.code === '200' ? ElMessage.success('创建成功') : ElMessage.error(res.message)
}
onMounted(loadSubjects)
</script>
