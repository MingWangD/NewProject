import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: () => import('@/views/Login.vue') },
  {
    path: '/admin',
    component: () => import('@/layout/AdminLayout.vue'),
    children: [
      { path: 'exam-create', component: () => import('@/views/admin/ExamCreate.vue') },
      { path: 'scores', component: () => import('@/views/admin/ScoreList.vue') },
      { path: 'answers/:recordId', component: () => import('@/views/admin/AnswerDetail.vue') },
      { path: 'attendance', component: () => import('@/views/admin/AttendanceStats.vue') },
      { path: 'dashboard', component: () => import('@/views/admin/Dashboard.vue') }
    ]
  },
  {
    path: '/student',
    component: () => import('@/layout/StudentLayout.vue'),
    children: [
      { path: 'exams', component: () => import('@/views/student/ExamList.vue') },
      { path: 'exam/:examId', component: () => import('@/views/student/ExamDo.vue') },
      { path: 'result/:recordId', component: () => import('@/views/student/ExamResult.vue') },
      { path: 'score', component: () => import('@/views/student/ScoreView.vue') },
      { path: 'state', component: () => import('@/views/student/LearnState.vue') },
      { path: 'profile', component: () => import('@/views/student/Profile.vue') },
      { path: 'timetable', component: () => import('@/views/student/Timetable.vue') }
    ]
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
