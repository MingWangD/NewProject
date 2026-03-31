<template>
  <el-card>
    <template #header><b>个人资料</b></template>
    <el-form :model="form" label-width="120px" style="max-width: 560px">
      <el-form-item label="学号ID">
        <el-input v-model="form.username" placeholder="请输入学号ID"/>
      </el-form-item>
      <el-form-item label="姓名">
        <el-input v-model="form.realName" placeholder="请输入姓名"/>
      </el-form-item>
      <el-form-item label="邮箱">
        <el-input v-model="form.email" placeholder="请输入邮箱"/>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="save">保存修改</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script setup>
import { onMounted, reactive } from 'vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'

const user = JSON.parse(localStorage.getItem('user') || '{}')
const form = reactive({ username: '', realName: '', email: '' })

const load = async () => {
  const res = await request.get(`/student/${user.id}/profile`)
  Object.assign(form, res.data || {})
}

const save = async () => {
  const res = await request.put(`/student/${user.id}/profile`, form)
  if (res.code === '200') {
    ElMessage.success('资料已更新')
    localStorage.setItem('user', JSON.stringify(res.data))
  } else {
    ElMessage.error(res.message)
  }
}

onMounted(load)
</script>
