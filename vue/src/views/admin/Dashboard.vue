<template>
  <el-row :gutter="12" style="margin-bottom: 12px">
    <el-col :span="6"><el-card>平均成绩：{{ fmt(data.avgScore) }}</el-card></el-col>
    <el-col :span="6"><el-card>平均GPA：{{ fmt(data.avgGpa) }}</el-card></el-col>
    <el-col :span="6"><el-card>出勤率：{{ pct(data.attendanceRate) }}</el-card></el-col>
    <el-col :span="6"><el-card>通过率：{{ pct(data.passRate) }}</el-card></el-col>
  </el-row>

  <el-row :gutter="12" style="margin-bottom: 12px">
    <el-col :span="12">
      <el-card>
        <template #header><b>风险预警分布（Echarts）</b></template>
        <div ref="riskChartRef" style="height: 320px"></div>
      </el-card>
    </el-col>
    <el-col :span="12">
      <el-card>
        <template #header><b>核心指标概览（Echarts）</b></template>
        <div ref="metricChartRef" style="height: 320px"></div>
      </el-card>
    </el-col>
  </el-row>

  <el-card>
    <template #header><b>风险预警明细</b></template>
    <el-table :data="riskRows" border>
      <el-table-column prop="riskLevel" label="预警等级" width="180">
        <template #default="scope">
          <el-tag :type="tagType(scope.row.riskLevel)">{{ label(scope.row.riskLevel) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="count" label="人数" />
      <el-table-column label="区间说明">
        <template #default="scope">{{ desc(scope.row.riskLevel) }}</template>
      </el-table-column>
    </el-table>
  </el-card>
</template>

<script setup>
import { nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import request from '@/utils/request'

const data = ref({})
const riskRows = ref([])
const riskChartRef = ref(null)
const metricChartRef = ref(null)
let riskChart = null
let metricChart = null
let echartsLib = null

const fmt = (v) => ((v ?? 0).toFixed ? (v ?? 0).toFixed(2) : v)
const pct = (v) => `${((v ?? 0) * 100).toFixed(1)}%`
const label = (r) => ({ RED: '红色预警', ORANGE: '橙色预警', YELLOW: '黄色预警', GREEN: '正常' }[r] || r)
const tagType = (r) => ({ RED: 'danger', ORANGE: 'warning', YELLOW: 'warning', GREEN: 'success' }[r] || 'info')
const desc = (r) => ({ RED: 'GPA < 1.5', ORANGE: '1.5 ≤ GPA < 2.0', YELLOW: '2.0 ≤ GPA < 2.5', GREEN: 'GPA ≥ 2.5' }[r] || '-')
const color = (r) => ({ RED: '#f56c6c', ORANGE: '#e6a23c', YELLOW: '#f2c94c', GREEN: '#67c23a' }[r] || '#909399')

const loadEcharts = async () => {
  if (echartsLib) return echartsLib
  try {
    const pkg = 'echarts'
    echartsLib = await import(pkg)
    return echartsLib
  } catch (e) {
    await new Promise((resolve, reject) => {
      const script = document.createElement('script')
      script.src = 'https://cdn.jsdelivr.net/npm/echarts@5.5.1/dist/echarts.min.js'
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })
    echartsLib = window.echarts
    return echartsLib
  }
}

const renderCharts = async () => {
  await nextTick()
  const echarts = await loadEcharts()
  if (riskChartRef.value) {
    riskChart ??= echarts.init(riskChartRef.value)
    riskChart.setOption({
      tooltip: { trigger: 'item' },
      legend: { bottom: 0 },
      series: [{
        name: '风险人数',
        type: 'pie',
        radius: ['45%', '70%'],
        data: riskRows.value.map((i) => ({ value: i.count, name: label(i.riskLevel), itemStyle: { color: color(i.riskLevel) } }))
      }]
    })
  }

  if (metricChartRef.value) {
    metricChart ??= echarts.init(metricChartRef.value)
    metricChart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: { type: 'category', data: ['平均成绩', '平均GPA', '出勤率', '通过率'] },
      yAxis: { type: 'value' },
      series: [{
        type: 'bar',
        data: [
          Number((data.value.avgScore ?? 0).toFixed ? (data.value.avgScore ?? 0).toFixed(2) : data.value.avgScore ?? 0),
          Number((data.value.avgGpa ?? 0).toFixed ? (data.value.avgGpa ?? 0).toFixed(2) : data.value.avgGpa ?? 0),
          Number(((data.value.attendanceRate ?? 0) * 100).toFixed(2)),
          Number(((data.value.passRate ?? 0) * 100).toFixed(2))
        ],
        itemStyle: {
          color: (p) => ['#409eff', '#67c23a', '#e6a23c', '#909399'][p.dataIndex]
        }
      }]
    })
  }
}

onMounted(async () => {
  const res = await request.get('/admin/dashboard')
  data.value = res.data || {}
  riskRows.value = data.value.risk || []
  try {
    await renderCharts()
  } catch (e) {
    console.error('Echarts load failed:', e)
  }
  window.addEventListener('resize', resizeCharts)
})

const resizeCharts = () => {
  riskChart?.resize()
  metricChart?.resize()
}

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  riskChart?.dispose()
  metricChart?.dispose()
})
</script>
