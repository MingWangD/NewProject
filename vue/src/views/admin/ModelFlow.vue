<template>
  <el-card>
    <template #header><b>逻辑回归计算流程说明</b></template>

    <el-descriptions :column="1" border>
      <el-descriptions-item label="课后测验权重">0.3</el-descriptions-item>
      <el-descriptions-item label="期末考试权重">0.7</el-descriptions-item>
      <el-descriptions-item label="课程 GPA 生效条件">期末考试 >= 60 分，否则该课程记为挂科，课程 GPA 显示“-”。</el-descriptions-item>
      <el-descriptions-item label="课程加权分">weighted = 0.3 * regularAvg + 0.7 * finalAvg</el-descriptions-item>
      <el-descriptions-item label="风险概率 Logistic">p = 1 / (1 + e^(-z))，z = 3.2 - 0.035*regularAvg - 0.045*finalAvg - 2.2*attendanceRate - 1.8*passRate</el-descriptions-item>
      <el-descriptions-item label="风险等级阈值">p≥0.75 红色；0.55≤p&lt;0.75 橙色；0.35≤p&lt;0.55 黄色；其余绿色</el-descriptions-item>
    </el-descriptions>
  </el-card>
</template>
