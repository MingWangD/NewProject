<template>
  <el-space direction="vertical" fill>
    <el-card>
      <template #header><b>考试创建（课程固定，按课程题库组卷）</b></template>
      <el-form :model="form" label-width="120px">
        <el-form-item label="考试名称"><el-input v-model="form.name"/></el-form-item>
        <el-form-item label="课程">
          <el-select v-model="form.subjectId" @change="onSubjectChange" style="width: 300px">
            <el-option v-for="s in subjects" :key="s.id" :value="s.id" :label="`${s.name}（${s.totalHours}学时）`"/>
          </el-select>
        </el-form-item>
        <el-form-item label="考试类型">
          <el-select v-model="form.examType" style="width: 300px">
            <el-option label="课后测验" value="REGULAR"/>
            <el-option label="期末考试" value="FINAL"/>
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

    <el-card>
      <template #header><b>已发布考试（可撤销未被任何学生完成的考试）</b></template>
      <el-table :data="pagedExamList" border>
        <el-table-column prop="id" label="ID" width="80"/>
        <el-table-column prop="name" label="考试名称"/>
        <el-table-column prop="subjectName" label="课程" width="140"/>
        <el-table-column label="类型" width="120">
          <template #default="scope">{{ scope.row.examType === 'FINAL' ? '期末考试' : '课后测验' }}</template>
        </el-table-column>
        <el-table-column prop="startTime" label="开始时间" width="180"/>
        <el-table-column prop="endTime" label="结束时间" width="180"/>
        <el-table-column label="操作" width="120">
          <template #default="scope">
            <el-button type="danger" plain @click="revoke(scope.row.id)">撤销</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        style="margin-top: 12px"
        background
        layout="prev, pager, next, ->, total"
        :current-page="examPage"
        :page-size="examPageSize"
        :total="examList.length"
        @current-change="(p)=>examPage=p"
      />
    </el-card>
  </el-space>
</template>

<script setup>
import { computed, nextTick, onMounted, reactive, ref } from 'vue'
import request from '@/utils/request'
import { ElMessage, ElMessageBox } from 'element-plus'

const subjects = ref([])
const questions = ref([])
const examList = ref([])
const tableRef = ref()
const page = ref(1)
const pageSize = 8
const examPage = ref(1)
const examPageSize = 8
const selectedIdSet = ref(new Set())
const form = reactive({ name: '', subjectId: null, examType: 'REGULAR', passScore: 60, startTime: '', endTime: '', questionIds: [] })
const pagedQuestions = computed(() => questions.value.slice((page.value - 1) * pageSize, page.value * pageSize))
const pagedExamList = computed(() => examList.value.slice((examPage.value - 1) * examPageSize, examPage.value * examPageSize))

const loadSubjects = async () => subjects.value = (await request.get('/common/subjects')).data
const loadExamList = async () => {
  const list = (await request.get('/exam/list')).data || []
  examList.value = list.map(i => ({ ...i, subjectName: i.subject_name || i.subjectName, examType: i.examType || i.exam_type }))
  examPage.value = 1
}

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
  if (!form.name || !form.name.trim()) return ElMessage.warning('请输入考试名称')
  if (!form.subjectId) return ElMessage.warning('请选择课程')
  if (!form.passScore || form.passScore <= 0) return ElMessage.warning('及格分必须大于0')
  if (!form.startTime || !form.endTime) return ElMessage.warning('请选择开始和结束时间')
  if (new Date(form.startTime).getTime() >= new Date(form.endTime).getTime()) {
    return ElMessage.warning('开始时间必须早于结束时间')
  }
  if (!['REGULAR', 'FINAL'].includes(form.examType)) {
    return ElMessage.warning('考试类型仅支持课后测验或期末考试')
  }
  if (!form.questionIds.length) return ElMessage.warning('请至少选择1道题')
  const totalScore = questions.value
    .filter(q => form.questionIds.includes(q.id))
    .reduce((sum, q) => sum + (q.score || 0), 0)
  if (form.passScore > totalScore) return ElMessage.warning(`及格分不能大于总分（当前总分 ${totalScore}）`)
  const res = await request.post('/exam/create', form)
  if (res.code === '200') {
    ElMessage.success('发布成功')
    await loadExamList()
  } else {
    ElMessage.error(res.message)
  }
}

const revoke = async (examId) => {
  await ElMessageBox.confirm('仅可撤销未被学生完成的考试，确认继续？', '撤销考试', { type: 'warning' })
  const res = await request.delete(`/exam/${examId}/revoke`)
  if (res.code === '200') {
    ElMessage.success('撤销成功')
    await loadExamList()
  } else {
    ElMessage.error(res.message)
  }
}

onMounted(async () => {
  await Promise.all([loadSubjects(), loadExamList()])
})
</script>
