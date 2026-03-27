<template>
  <el-row :gutter="12" style="margin-bottom: 12px">
    <el-col :span="6"><el-card>平均成绩：{{fmt(data.avgScore)}}</el-card></el-col>
    <el-col :span="6"><el-card>平均GPA：{{fmt(data.avgGpa)}}</el-card></el-col>
    <el-col :span="6"><el-card>出勤率：{{pct(data.attendanceRate)}}</el-card></el-col>
    <el-col :span="6"><el-card>通过率：{{pct(data.passRate)}}</el-card></el-col>
  </el-row>

  <el-card>
    <template #header><b>风险预警分布（按 GPA 颜色区间）</b></template>
    <el-table :data="riskRows" border>
      <el-table-column prop="riskLevel" label="预警等级" width="180">
        <template #default="scope">
          <el-tag :type="tagType(scope.row.riskLevel)">{{ label(scope.row.riskLevel) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="count" label="人数"/>
      <el-table-column label="区间说明">
        <template #default="scope">{{ desc(scope.row.riskLevel) }}</template>
      </el-table-column>
    </el-table>
  </el-card>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';

const data = ref({})
const riskRows = ref([])
const fmt = (v)=> (v ?? 0).toFixed ? (v ?? 0).toFixed(2) : v
const pct = (v)=> `${(((v ?? 0) * 100)).toFixed(1)}%`
const label = (r)=> ({RED:'红色预警', ORANGE:'橙色预警', YELLOW:'黄色预警', GREEN:'正常'}[r] || r)
const tagType = (r)=> ({RED:'danger', ORANGE:'warning', YELLOW:'warning', GREEN:'success'}[r] || 'info')
const desc = (r)=> ({RED:'GPA < 1.5', ORANGE:'1.5 ≤ GPA < 2.0', YELLOW:'2.0 ≤ GPA ≤ 2.5', GREEN:'GPA > 2.5'}[r] || '-')

onMounted(async()=>{
  const res = await request.get('/admin/dashboard')
  data.value = res.data
  riskRows.value = res.data.risk || []
})
</script>
