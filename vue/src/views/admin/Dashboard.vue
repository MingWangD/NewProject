<template>
  <el-card>
    <div ref="chartRef" style="height:320px"></div>
    <p>平均成绩：{{data.avgScore}}</p><p>平均GPA：{{data.avgGpa}}</p><p>出勤率：{{data.attendanceRate}}</p><p>通过率：{{data.passRate}}</p>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import request from '@/utils/request';
import * as echarts from 'echarts'
const chartRef = ref(); const data = ref({})
onMounted(async()=>{
  const res = await request.get('/admin/dashboard'); data.value = res.data
  const chart = echarts.init(chartRef.value)
  const risk = res.data.risk || []
  chart.setOption({xAxis:{type:'category',data:risk.map(i=>i.riskLevel)},yAxis:{type:'value'},series:[{type:'bar',data:risk.map(i=>i.count)}]})
})
</script>
