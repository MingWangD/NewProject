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
        <el-table
            ref="tableRef"
            :data="pagedQuestions"
            row-key="id"
            border
            @selection-change="onSelectionChange"
        >
          <el-table-column type="selection" width="50"/>
          <el-table-column type="index" width="60" label="#"/>
          <el-table-column prop="content" label="题目内容" min-width="400"/>
          <el-table-column prop="score" label="分值" width="80"/>
          <el-table-column prop="correctOption" label="答案" width="80"/>
        </el-table>
        <el-pagination
            style="margin-top: 12px"
            background
            layout="prev, pager, next, jumper, ->, total"
            :current-page="page"
            :page-size="pageSize"
            :total="questions.length"
            @current-change="onPageChange"
        />
      </el-form-item>
      <el-button type="primary" @click="submit">发布考试</el-button>
    </el-form>
  </el-card>
</template>
<script setup>
import { computed, nextTick, onMounted, reactive, ref } from 'vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'

const subjects = ref([])
const questions = ref([])
const tableRef = ref()
const page = ref(1)
const pageSize = 8
const selectedIdSet = ref(new Set())
const form = reactive({ name: '', subjectId: null, passScore: 60, startTime: '', endTime: '', questionIds: [] })
const pagedQuestions = computed(() => questions.value.slice((page.value - 1) * pageSize, page.value * pageSize))

const loadSubjects = async () => subjects.value = (await request.get('/common/subjects')).data
const onSubjectChange = async () => {
  questions.value = (await request.get(`/common/questions/${form.subjectId}`)).data
  page.value = 1
  selectedIdSet.value = new Set()
  form.questionIds = []
  await nextTick()
  restoreSelections()
}

const onSelectionChange = (rows) => {
  const currentIds = pagedQuestions.value.map(i => i.id)
  currentIds.forEach(id => selectedIdSet.value.delete(id))
  rows.forEach(row => selectedIdSet.value.add(row.id))
  form.questionIds = Array.from(selectedIdSet.value)
}

const restoreSelections = () => {
  if (!tableRef.value) return
  tableRef.value.clearSelection()
  pagedQuestions.value.forEach(row => {
    if (selectedIdSet.value.has(row.id)) {
      tableRef.value.toggleRowSelection(row, true)
    }
  })
}

const onPageChange = async (p) => {
  page.value = p
  await nextTick()
  restoreSelections()
}

const submit = async () => {
  if (!form.questionIds.length) return ElMessage.warning('请至少选择1道题')
  const res = await request.post('/exam/create', form)
  res.code === '200' ? ElMessage.success('发布成功') : ElMessage.error(res.message)
}
onMounted(loadSubjects)
</script>
