<template>
  <el-card>
    <template #header>
      <div style="display:flex;justify-content:space-between;align-items:center;">
        <div>
          <b>答题详情</b>
          <div style="margin-top:6px;color:#666;font-size:13px;">
            学生：{{ meta.studentName || '-' }} ｜ 考试：{{ meta.examName || '-' }} ｜ 提交时间：{{ meta.submitTime || '-' }}
          </div>
        </div>
        <el-button @click="goBack">返回成绩列表</el-button>
      </div>
    </template>
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
import { useRoute, useRouter } from 'vue-router';
import request from '@/utils/request';
const route = useRoute();
const router = useRouter();
const list = ref([])
const meta = ref({})

const goBack = () => router.push('/admin/scores')

onMounted(async () => {
  const recordId = route.params.recordId
  list.value = (await request.get(`/exam/record/${recordId}/answers`)).data
  meta.value = (await request.get(`/exam/record/${recordId}/meta`)).data || {}
})
</script>
