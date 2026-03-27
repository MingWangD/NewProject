<template>
  <div style="max-width:360px;margin:120px auto">
    <el-card>
      <template #header><b>学情智能预警系统</b></template>
      <el-form :model="form" label-position="top">
        <el-form-item label="账号"><el-input v-model="form.username" placeholder="admin / stu1"/></el-form-item>
        <el-form-item label="密码"><el-input type="password" v-model="form.password" placeholder="123456"/></el-form-item>
        <el-form-item label="角色">
          <el-segmented v-model="form.role" :options="['STUDENT','ADMIN']"/>
        </el-form-item>
        <el-button type="primary" style="width:100%" @click="login">登录</el-button>
      </el-form>
    </el-card>
  </div>
</template>
<script setup>
import { reactive } from 'vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'
import router from '@/router'

const form = reactive({ username: 'stu1', password: '123456', role: 'STUDENT' })

const login = async () => {
  const res = await request.post('/auth/login', form)
  if (res.code === '200') {
    localStorage.setItem('user', JSON.stringify(res.data))
    ElMessage.success('登录成功')
    router.push(form.role === 'ADMIN' ? '/admin/exam-create' : '/student/exams')
  } else ElMessage.error(res.message)
}
</script>
