<template>
  <el-card>
    <template #header>
      <div style="display:flex;justify-content:space-between;align-items:center">
        <b>课程表（2026年3月-6月）</b>
        <el-space>
          <el-button @click="changeWeek(-1)">上一周</el-button>
          <el-tag type="info">{{ weekRange }}</el-tag>
          <el-button @click="changeWeek(1)">下一周</el-button>
        </el-space>
      </div>
    </template>

    <el-table :data="rows" border>
      <el-table-column prop="date" label="日期" width="130"/>
      <el-table-column prop="weekDay" label="星期" width="110"/>
      <el-table-column prop="timeRange" label="时间" width="130"/>
      <el-table-column prop="subject" label="课程"/>
      <el-table-column prop="classroom" label="教室"/>
      <el-table-column prop="teacher" label="任课老师"/>
    </el-table>
  </el-card>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import request from '@/utils/request'

const weekStart = ref('2026-03-02')
const rows = ref([])

const weekRange = computed(() => {
  const start = new Date(`${weekStart.value}T00:00:00`)
  const end = new Date(start)
  end.setDate(end.getDate() + 6)
  return `${weekStart.value} ~ ${end.toISOString().slice(0, 10)}`
})

const load = async () => {
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  const res = await request.get(`/student/${user.id}/timetable`, { params: { weekStart: weekStart.value } })
  rows.value = res.data || []
}

const changeWeek = async (delta) => {
  const start = new Date(`${weekStart.value}T00:00:00`)
  start.setDate(start.getDate() + delta * 7)
  weekStart.value = start.toISOString().slice(0, 10)
  await load()
}

onMounted(load)
</script>
