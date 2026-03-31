<template>
  <el-card>
    <template #header><b>可参加考试（按科目分类）</b></template>

    <el-collapse>
      <el-collapse-item
        v-for="group in grouped"
        :key="group.subject"
        :name="group.subject"
        :title="`${group.subject}（${group.items.length} 场）`"
      >
        <el-table :data="group.items" border>
          <el-table-column prop="name" label="考试名称"/>
          <el-table-column label="出勤门槛" width="220">
            <template #default="scope">
              <el-tag :type="scope.row.canAttend ? 'success' : 'danger'">
                {{scope.row.attendance}} / {{scope.row.requiredAttendance}} ({{ scope.row.canAttend ? '达标' : '不达标' }})
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="240">
            <template #default="scope">
              <el-space>
                <el-button
                  :disabled="!scope.row.canAttend || scope.row.completed"
                  :type="scope.row.completed ? 'info' : 'primary'"
                  @click="go(scope.row.id)">
                  {{ scope.row.completed ? '已完成' : '参加考试' }}
                </el-button>
                <el-button v-if="scope.row.completed" type="success" plain @click="viewResult(scope.row.recordId)">
                  查看详情
                </el-button>
              </el-space>
            </template>
          </el-table-column>
        </el-table>
      </el-collapse-item>
    </el-collapse>
  </el-card>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import request from '@/utils/request'
import router from '@/router'

const exams = ref([])
const user = JSON.parse(localStorage.getItem('user') || '{}')

const grouped = computed(() => {
  const map = new Map()
  for (const exam of exams.value) {
    const subject = exam.subjectName || '未分类课程'
    if (!map.has(subject)) map.set(subject, [])
    map.get(subject).push(exam)
  }
  return Array.from(map.entries()).map(([subject, items]) => ({ subject, items }))
})

const load = async () => {
  const list = (await request.get('/exam/list')).data
  const merged = []
  for (const exam of list) {
    const [ruleRes, recordRes] = await Promise.all([
      request.get(`/exam/${exam.id}/can-attend/${user.id}`),
      request.get(`/exam/${exam.id}/record/${user.id}`)
    ])
    const rule = ruleRes.data
    const record = recordRes.data
    merged.push({ ...exam, subjectName: exam.subjectName || exam.subject_name, ...rule, completed: !!record, recordId: record?.id, score: record?.score })
  }
  exams.value = merged
}

const go = (id) => router.push(`/student/exam/${id}`)
const viewResult = (recordId) => router.push(`/student/result/${recordId}`)

onMounted(load)
</script>
