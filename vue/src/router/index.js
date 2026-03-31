import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: () => import('@/views/Login.vue') },
  {
    path: '/admin',
    component: () => import('@/layout/AdminLayout.vue'),
    children: [
      { path: 'exam-create', component: () => import('@/views/admin/ExamCreate.vue') },
      { path: 'query', component: () => import('@/views/admin/StudentInsight.vue') },
      { path: 'model-flow', component: () => import('@/views/admin/ModelFlow.vue') },
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
      { path: 'timetable', component: () => import('@/views/student/Timetable.vue') },
      { path: 'subject-gpa', component: () => import('@/views/student/SubjectGpa.vue') }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  const isAuthed = !!user?.id
  const role = user?.role
  const isAdminRoute = to.path.startsWith('/admin')
  const isStudentRoute = to.path.startsWith('/student')

  if ((isAdminRoute || isStudentRoute) && !isAuthed) {
    next('/login')
    return
  }
  if (isAdminRoute && role !== 'ADMIN') {
    next('/login')
    return
  }
  if (isStudentRoute && role !== 'STUDENT') {
    next('/login')
    return
  }
  next()
})

export default router
