<template>
  <el-card>
    <template #header><b>考试创建（课程固定，按课程题库组卷）</b></template>
    <el-form :model="form" label-width="120px">
      <el-form-item label="考试名称"><el-input v-model="form.name"/></el-form-item>
      <el-form-item label="课程">
        <el-select v-model="form.subjectId" @change="onSubjectChange" style="width: 300px">
          <el-option v-for="s in subjects" :key="s.id" :value="s.id" :label="`${s.name}（${s.totalHours}学时）`"/>
        </el-select>
      </el-form-item>
      <el-form-item label="及格分"><el-input-number v-model="form.passScore" :min="1"/></el-form-item>
      <el-form-item label="开始时间"><el-date-picker v-model="form.startTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss"/></el-form-item>
      <el-form-item label="结束时间"><el-date-picker v-model="form.endTime" type="datetime" value-format="YYYY-MM-DDTHH:mm:ss"/></el-form-item>
      <el-form-item label="题库可视化选择">
        <el-table :data="questions" border @selection-change="(rows)=>form.questionIds=rows.map(i=>i.id)">
          <el-table-column type="selection" width="50"/>
          <el-table-column type="index" width="60" label="#"/>
          <el-table-column prop="content" label="题目内容" min-width="400"/>
          <el-table-column prop="score" label="分值" width="80"/>
          <el-table-column prop="correctOption" label="答案" width="80"/>
        </el-table>
      </el-form-item>
      <el-button type="primary" @click="submit">发布考试</el-button>
    </el-form>
  </el-card>
</template>
<script setup>
import { reactive, ref, onMounted } from 'vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'

const subjects = ref([])
const questions = ref([])
const form = reactive({ name: '', subjectId: null, passScore: 60, startTime: '', endTime: '', questionIds: [] })

const loadSubjects = async () => subjects.value = (await request.get('/common/subjects')).data
const onSubjectChange = async () => {
  questions.value = (await request.get(`/common/questions/${form.subjectId}`)).data
  form.questionIds = []
}
const submit = async () => {
  if (!form.questionIds.length) return ElMessage.warning('请至少选择1道题')
  const res = await request.post('/exam/create', form)
  res.code === '200' ? ElMessage.success('发布成功') : ElMessage.error(res.message)
}
onMounted(loadSubjects)
</script>
