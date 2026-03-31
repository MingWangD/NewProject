<template>
  <el-card>
    <template #header><b>成绩页（按考试类型分类）</b></template>

    <el-collapse>
      <el-collapse-item v-for="group in grouped" :key="group.type" :name="group.type" :title="`${typeLabel(group.type)}（${group.items.length} 条）`">
        <el-table :data="group.items" border>
          <el-table-column prop="examName" label="考试名称"/>
          <el-table-column prop="score" label="成绩" width="100"/>
          <el-table-column label="完成状态" width="120">
            <template #default>
              <el-tag type="success">已完成</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="submitTime" label="提交时间"/>
          <el-table-column label="操作" width="120">
            <template #default="scope"><el-button @click="view(scope.row.id)">详情</el-button></template>
          </el-table-column>
        </el-table>
      </el-collapse-item>
    </el-collapse>
  </el-card>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import router from '@/router'
import request from '@/utils/request'

const user = JSON.parse(localStorage.getItem('user') || '{}')
const records = ref([])

const typeLabel = (type) => type === 'FINAL' ? '期末考试' : '课后测验'

const grouped = computed(() => {
  const map = new Map()
  for (const r of records.value) {
    const type = r.examType || 'REGULAR'
    if (!map.has(type)) map.set(type, [])
    map.get(type).push(r)
  }
  return Array.from(map.entries()).map(([type, items]) => ({ type, items }))
})

onMounted(async () => {
  records.value = (await request.get(`/student/${user.id}/state`)).data.records || []
})

const view = (recordId) => router.push(`/student/result/${recordId}`)
</script>
