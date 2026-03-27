<template>
  <el-card>
    <el-form>
      <div v-for="q in qs" :key="q.id" style="margin-bottom:16px">
        <p>{{q.content}}</p>
        <el-radio-group v-model="ans[q.id]">
          <el-radio label="A">A. {{q.optionA}}</el-radio>
          <el-radio label="B">B. {{q.optionB}}</el-radio>
          <el-radio label="C">C. {{q.optionC}}</el-radio>
          <el-radio label="D">D. {{q.optionD}}</el-radio>
        </el-radio-group>
      </div>
      <el-button type="primary" @click="submit">提交</el-button>
    </el-form>
  </el-card>
</template>
<script setup>
import { onMounted, ref, reactive } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import request from '@/utils/request';
const route = useRoute(); const router = useRouter(); const user = JSON.parse(localStorage.getItem('user')||'{}')
const qs = ref([]); const ans = reactive({})
onMounted(async()=> qs.value=(await request.get(`/exam/${route.params.examId}/questions`)).data)
const submit = async()=>{
  const answers = qs.value.map(q=>({questionId:q.id,selectedOption:ans[q.id]||'A'}))
  const res = await request.post('/exam/submit',{examId:Number(route.params.examId), studentId:user.id, answers})
  if(res.code==='200'){alert(`成绩:${res.data.score}`);router.push('/student/score')} else alert(res.message)
}
</script>
