<template>
  <div style="width:320px;margin:120px auto">
    <el-card>
      <el-form :model="form">
        <el-form-item><el-input v-model="form.username" placeholder="账号"/></el-form-item>
        <el-form-item><el-input type="password" v-model="form.password" placeholder="密码"/></el-form-item>
        <el-form-item>
          <el-select v-model="form.role" style="width:100%">
            <el-option label="管理员" value="ADMIN"/>
            <el-option label="学生" value="STUDENT"/>
          </el-select>
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

const form = reactive({ username: '', password: '', role: 'STUDENT' })

const login = async () => {
  const res = await request.post('/auth/login', form)
  if (res.code === '200') {
    localStorage.setItem('user', JSON.stringify(res.data))
    ElMessage.success('登录成功')
    router.push(form.role === 'ADMIN' ? '/admin/exam-create' : '/student/exams')
  } else ElMessage.error(res.message)
}
</script>
