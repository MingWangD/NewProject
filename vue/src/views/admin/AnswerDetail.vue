<template>
  <el-card>
    <h3>答题详情（学习通风格）</h3>
    <el-timeline>
      <el-timeline-item v-for="(a,i) in list" :key="a.id" :type="a.isCorrect===1?'success':'danger'">
        <p>{{ i+1 }}. {{ a.content }}</p>
        <p>学生答案：{{ a.selectedOption }}，正确答案：{{ a.correctOption }}，{{ a.isCorrect===1?'正确':'错误' }}</p>
      </el-timeline-item>
    </el-timeline>
  </el-card>
</template>
<script setup>
import { onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';
import request from '@/utils/request';
const route = useRoute(); const list = ref([])
onMounted(async()=> list.value=(await request.get(`/exam/record/${route.params.recordId}/answers`)).data)
</script>
