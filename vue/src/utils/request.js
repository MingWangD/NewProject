import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:9090/api',
  timeout: 20000
})

request.interceptors.response.use(res => res.data)

export default request
