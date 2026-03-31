<template>
  <el-card>
    <template #header><b>学情综合查询</b></template>

    <el-space wrap>
      <el-select v-model="studentId" placeholder="选择学生" style="width: 220px" @change="load">
        <el-option v-for="s in students" :key="s.id" :label="`${s.realName}(${s.username})`" :value="s.id"/>
      </el-select>
      <el-select v-model="subjectId" placeholder="选择课程" style="width: 220px" @change="load">
        <el-option v-for="s in subjects" :key="s.id" :label="s.name" :value="s.id"/>
      </el-select>
    </el-space>

    <el-row :gutter="12" style="margin-top: 12px">
      <el-col :span="6"><el-card>出勤次数：{{ detail.attendanceCount ?? '-' }}</el-card></el-col>
      <el-col :span="6"><el-card>总GPA：{{ detail.overallGpa?.gpa ?? '-' }}</el-card></el-col>
      <el-col :span="6"><el-card>课程状态：{{ subjectStatus }}</el-card></el-col>
      <el-col :span="6"><el-card>该课程GPA：{{ subjectGpaText }}</el-card></el-col>
    </el-row>

    <el-card style="margin-top:12px">
      <template #header><b>课后测验成绩（可查看答题详情）</b></template>
      <el-table :data="pagedRecords" border>
        <el-table-column prop="examName" label="考试名称"/>
        <el-table-column prop="score" label="分数" width="100"/>
        <el-table-column prop="isPassed" label="通过" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.isPassed===1 ? 'success' : 'danger'">{{scope.row.isPassed===1 ? '通过' : '未通过'}}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="submitTime" label="提交时间"/>
        <el-table-column label="操作" width="140">
          <template #default="scope"><el-button @click="goAnswer(scope.row.recordId)">题目详情</el-button></template>
        </el-table-column>
      </el-table>
      <el-pagination
        style="margin-top:12px"
        background
        layout="prev, pager, next, ->, total"
        :current-page="recordPage"
        :page-size="recordPageSize"
        :total="regularRecords.length"
        @current-change="(p)=>recordPage=p"
      />
    </el-card>
  </el-card>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import request from '@/utils/request'
import router from '@/router'

const students = ref([])
const subjects = ref([])
const studentId = ref(null)
const subjectId = ref(null)
const detail = ref({})
const recordPage = ref(1)
const recordPageSize = 8

const subjectStatus = computed(() => {
  const status = detail.value.subjectGpa?.status
  if (status === 'FAILED') return '挂科'
  if (status === 'PASSED') return '通过'
  return '未完成'
})

const subjectGpaText = computed(() => {
  const status = detail.value.subjectGpa?.status
  if (status === 'FAILED') return '-'
  return detail.value.subjectGpa?.subjectGpa ?? '-'
})

const regularRecords = computed(() => detail.value.regularRecords || [])
const pagedRecords = computed(() => regularRecords.value.slice((recordPage.value - 1) * recordPageSize, recordPage.value * recordPageSize))

const loadBase = async () => {
  students.value = (await request.get('/admin/students')).data || []
  subjects.value = (await request.get('/common/subjects')).data || []
  if (students.value.length) studentId.value = students.value[0].id
  if (subjects.value.length) subjectId.value = subjects.value[0].id
  await load()
}

const load = async () => {
  if (!studentId.value || !subjectId.value) return
  detail.value = (await request.get('/admin/student-course-query', { params: { studentId: studentId.value, subjectId: subjectId.value } })).data || {}
  recordPage.value = 1
}

const goAnswer = (recordId) => router.push(`/admin/answers/${recordId}`)

onMounted(loadBase)
</script>
