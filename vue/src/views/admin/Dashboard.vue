<template>
  <el-row :gutter="12" style="margin-bottom: 12px">
    <el-col :span="6"><el-card>平均成绩：{{fmt(data.avgScore)}}</el-card></el-col>
    <el-col :span="6"><el-card>平均GPA：{{fmt(data.avgGpa)}}</el-card></el-col>
    <el-col :span="6"><el-card>出勤率：{{pct(data.attendanceRate)}}</el-card></el-col>
    <el-col :span="6"><el-card>通过率：{{pct(data.passRate)}}</el-card></el-col>
  </el-row>
  <el-card>
    <template #header><b>风险等级分布</b></template>
    <div ref="chartRef" style="height:340px"></div>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
import * as echarts from 'echarts'
const chartRef = ref(); const data = ref({})
const fmt = (v)=> (v ?? 0).toFixed ? (v ?? 0).toFixed(2) : v
const pct = (v)=> `${(((v ?? 0) * 100)).toFixed(1)}%`
onMounted(async()=>{
  const res = await request.get('/admin/dashboard'); data.value = res.data
  const chart = echarts.init(chartRef.value)
  const risk = res.data.risk || []
  chart.setOption({
    tooltip: {},
    xAxis:{type:'category',data:risk.map(i=>i.riskLevel)},
    yAxis:{type:'value'},
    series:[{type:'bar',data:risk.map(i=>i.count),itemStyle:{color:'#409EFF'}}]
  })
})
</script>
