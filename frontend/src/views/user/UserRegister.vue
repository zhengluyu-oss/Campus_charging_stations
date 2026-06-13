<template>
  <div class="register-container">
    <!-- 注册表单卡片 -->
    <div class="register-card">
      <div class="card-header">
        <h2 class="card-title">用户注册</h2>
        <p class="card-subtitle">创建您的校园充电站账号</p>
      </div>

      <div class="card-body">
        <el-form :model="form" :rules="rules" ref="formRef" label-position="top">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="form.username" placeholder="请输入用户名" prefix-icon="UserFilled" />
          </el-form-item>

          <el-form-item label="邮箱" prop="email">
            <el-input v-model="form.email" placeholder="请输入邮箱" prefix-icon="Message" type="email" />
          </el-form-item>

          <el-form-item label="密码" prop="password">
            <el-input v-model="form.password" placeholder="请输入密码" prefix-icon="Lock" type="password" show-password />
          </el-form-item>

          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input v-model="form.confirmPassword" placeholder="请确认密码" prefix-icon="Lock" type="password" show-password />
          </el-form-item>

          <el-form-item label="手机号码" prop="phone">
            <el-input v-model="form.phone" placeholder="请输入手机号码" prefix-icon="Phone" />
          </el-form-item>

          <el-form-item>
            <el-checkbox v-model="form.agree" class="agree-checkbox">
              我已阅读并同意 <a href="#" class="terms-link">服务条款</a> 和 <a href="#" class="terms-link">隐私政策</a>
            </el-checkbox>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="handleRegister" :loading="loading" class="register-button">
              注册
            </el-button>
          </el-form-item>

          <div class="login-link">
            已有账号？ <router-link to="/user-login" class="link">立即登录</router-link>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { userRegister } from '../../apis/user';

const router = useRouter();
const formRef = ref();
const loading = ref(false);

// 表单数据
const form = reactive({
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
  phone: '',
  agree: false
});

// 表单验证规则
const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== form.password) {
          callback(new Error('两次输入的密码不一致'));
        } else {
          callback();
        }
      },
      trigger: 'blur'
    }
  ],
  phone: [
    { required: true, message: '请输入手机号码', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
};

// 处理注册
const handleRegister = async () => {
  if (!formRef.value) return;
  
  try {
    await formRef.value.validate();
    
    if (!form.agree) {
      ElMessage.warning('请阅读并同意服务条款和隐私政策');
      return;
    }

    loading.value = true;
    
    console.log('准备发送注册请求:', {
      username: form.username,
      email: form.email,
      phone: form.phone,
      userType: 'student'
    });
    
    // 调用注册API
    const response = await userRegister(
      form.username,
      form.password,
      form.email,
      form.phone,
      'student' // 默认用户类型为学生
    );
    
    console.log('注册API响应:', response);
    console.log('响应数据类型:', typeof response);
    console.log('响应数据内容:', JSON.stringify(response, null, 2));
    
    // 检查注册是否成功
    if (response) {
      // 后端可能返回不同的格式，需要兼容处理
      const state = response.state;
      const code = response.code;
      const message = response.message;
      const data = response.data;
      
      console.log('解析后的数据:', { state, code, message, data });
      
      // 判断注册是否成功
      // 情况1: state === 0 或 state === undefined（后端可能不返回state）
      // 情况2: code === 200 或 code === undefined
      // 情况3: 有data字段且不为空
      const isSuccess = (state === 0 || state === undefined) && 
                        (code === 200 || code === undefined) && 
                        (data !== undefined || message === undefined || message === '成功');
      
      if (isSuccess) {
        ElMessage.success('注册成功！');
        // 注册成功后跳转到默认界面
        router.push('/welcome');
      } else {
        ElMessage.error(message || '注册失败，请重试');
      }
    } else {
      ElMessage.error('注册失败，响应格式错误');
    }
  } catch (error: any) {
    console.error('注册失败详细信息:', {
      error: error,
      message: error.message,
      response: error.response,
      responseData: error.response?.data,
      status: error.response?.status
    });
    
    // 显示错误信息
    if (error.response?.data?.message) {
      ElMessage.error(error.response.data.message);
    } else if (error.response?.status) {
      ElMessage.error(`请求失败: ${error.response.status}`);
    } else if (error.message) {
      ElMessage.error(error.message);
    } else {
      ElMessage.error('注册失败，请检查网络连接');
    }
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.register-container {
  position: relative;
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  overflow: hidden;
  padding: 20px;
}

.register-card {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 450px;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(12px);
  border-radius: 20px;
  padding: 40px 30px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  animation: fadeInUp 0.8s ease-out;
}

.card-header {
  text-align: center;
  margin-bottom: 30px;
}

.card-title {
  font-size: 2rem;
  font-weight: 700;
  color: white;
  margin-bottom: 10px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-fill-color: transparent;
}

.card-subtitle {
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.7);
}

.card-body {
  width: 100%;
}

.el-form-item {
  margin-bottom: 20px;
}

.el-form-item__label {
  color: rgba(255, 255, 255, 0.9) !important;
  font-size: 0.9rem;
}

.el-input {
  --el-input-bg-color: rgba(255, 255, 255, 0.1) !important;
  --el-input-border-color: rgba(255, 255, 255, 0.2) !important;
  --el-input-text-color: white !important;
  --el-input-placeholder-color: rgba(255, 255, 255, 0.5) !important;
}

.el-input__wrapper {
  background: rgba(255, 255, 255, 0.1) !important;
  border-color: rgba(255, 255, 255, 0.2) !important;
}

.el-input__wrapper:hover {
  border-color: rgba(255, 255, 255, 0.4) !important;
}

.el-input__wrapper.is-focus {
  border-color: #00c9ff !important;
  box-shadow: 0 0 0 1px rgba(0, 201, 255, 0.3) !important;
}

.agree-checkbox {
  color: rgba(255, 255, 255, 0.7) !important;
  font-size: 0.85rem;
}

.terms-link {
  color: #00c9ff !important;
  text-decoration: none;
}

.terms-link:hover {
  text-decoration: underline;
}

.register-button {
  width: 100%;
  padding: 12px;
  font-size: 1rem;
  font-weight: 600;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  border: none;
  border-radius: 8px;
  color: #0f2027;
  transition: all 0.3s ease;
}

.register-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 201, 255, 0.4);
}

.login-link {
  text-align: center;
  margin-top: 20px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.link {
  color: #00c9ff !important;
  text-decoration: none;
  font-weight: 500;
}

.link:hover {
  text-decoration: underline;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .register-card {
    padding: 30px 20px;
  }

  .card-title {
    font-size: 1.8rem;
  }
}
</style>