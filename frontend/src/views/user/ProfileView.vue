<template>
  <div class="profile-page">
    <div class="page-background">
      <div class="background-grid">
        <div v-for="(p, i) in particles" :key="i" class="grid-cell" :style="{
          left: p.left,
          top: p.top,
          animationDelay: p.animationDelay,
          '--size': p.size
        }"></div>
      </div>
      <div class="gradient-overlay"></div>
    </div>
<!--个人中心-->
    <header class="page-header">
      <h1>个人中心</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>个人中心</el-breadcrumb-item>
      </el-breadcrumb>
    </header>
<!-- 点击更换头像---->
    <main class="profile-main">
      <el-card class="profile-card">
        <div class="profile-header">
          <div class="avatar-section" @click="triggerAvatarUpload">
            <el-avatar :size="100" :src="userInfo.avatarPath" class="profile-avatar" />
            <div class="avatar-overlay">
              <span>点击更换头像</span>
            </div>
          </div>
          <div class="user-info">
            <h2>{{ userInfo.username }}</h2>
            <p>{{ userInfo.email }}</p>
          </div>
        </div>

        <el-form
          :model="userInfo"
          :rules="rules"
          ref="formRef"
          label-width="100px"
          class="profile-form"
        >
          <el-form-item label="姓名" prop="username">
            <el-input v-model="userInfo.username" :readonly="!isEditing" :disabled="!isEditing" />
          </el-form-item>

          <el-form-item label="邮箱" prop="email">
            <el-input v-model="userInfo.email" :readonly="!isEditing" :disabled="!isEditing" />
          </el-form-item>

          <el-form-item label="手机号" prop="telephone">
            <el-input v-model="userInfo.telephone" :readonly="!isEditing" :disabled="!isEditing" />
          </el-form-item>

          <el-form-item label="密码">
            <div class="password-field">
              <el-input
                v-model="userInfo.password"
                type="password"
                show-password
                :readonly="!isEditing"
                :disabled="!isEditing"
                placeholder="留空则不修改密码"
              />
            </div>
          </el-form-item>

          <el-form-item class="form-actions">
            <el-button 
              type="primary" 
              @click="toggleEdit"
              class="action-button"
            >
              {{ isEditing ? '保存个人信息' : '修改个人信息' }}
            </el-button>
            <el-button 
              @click="resetForm" 
              v-if="isEditing"
              class="action-button secondary"
            >
              取消
            </el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </main>

    <input 
      type="file" 
      ref="avatarInputRef" 
      @change="handleAvatarChange" 
      accept="image/*" 
      style="display: none;" 
    />

  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import { useRouter } from 'vue-router';
import { useUserStore } from '../../stores/user';
import { getCurrentUser, updateOwnMessage } from '../../api/user';
import { uploadAvatar } from '../../api/upload';
import type { User } from '../../viewmodel/UserModel';

const router = useRouter();

// 预计算粒子位置，避免模板中 Math.random() 导致重渲染跳动
const particles = Array.from({ length: 50 }, () => ({
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 5}s`,
  size: `${Math.random() * 6 + 2}px`
}));
const formRef = ref();
const avatarInputRef = ref();
const isEditing = ref(false);
const userStore = useUserStore();

// 用户信息
const userInfo = reactive<User>({
  id: 0,
  username: '',
  password: '',
  avatarPath: 'https://cube.elemecdn.com/3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg',
  email: '',
  telephone: '',
  qq: '',
  updateTime: new Date().toISOString(),
  createTime: new Date().toISOString(),
  licensePlate: '',
  carModel: ''
});

// 临时存储头像文件
const avatarFile = ref<File | null>(null);

// 表单验证规则
const rules = reactive({
  username: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 2, max: 10, message: '姓名长度为2-10个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  telephone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  password: [
    { min: 6, message: '密码长度至少为6位', trigger: 'blur' }
  ]
});



// 加载用户信息
onMounted(async () => {
  try {
    if (!userStore.user) {
      const response = await getCurrentUser();
      console.log('API Response:', response); // 调试信息
      if (response.data) {
        console.log('Response Data:', response.data); // 调试信息
        // 更新用户信息，处理可能的null值
        Object.assign(userInfo, {
          ...userInfo,
          id: response.data.id || userInfo.id,
          username: response.data.username || userInfo.username,
          password: response.data.password || userInfo.password || '', // 保留现有密码或使用空字符串
          avatarPath: response.data.avatarPath || response.data.avatar_path || userInfo.avatarPath,
          email: response.data.email || userInfo.email,
          telephone: response.data.telephone || response.data.phone || userInfo.telephone, // 兼容不同字段名
          qq: response.data.qq || userInfo.qq,
          updateTime: response.data.updateTime || response.data.updated_time || userInfo.updateTime,
          createTime: response.data.createTime || response.data.created_time || userInfo.createTime,
          licensePlate: response.data.licensePlate || userInfo.licensePlate || '',
          carModel: response.data.carModel || userInfo.carModel || ''
        });
        console.log('Updated userInfo:', userInfo); // 调试信息
        // 更新store
        userStore.saveUser(userInfo); // 使用处理后的完整用户信息
      }
    } else {
      // 使用store中的用户信息，处理可能的null值
      console.log('Using store user:', userStore.user); // 调试信息
      Object.assign(userInfo, {
        ...userInfo,
        id: userStore.user.id || userInfo.id,
        username: userStore.user.username || userInfo.username,
        password: userStore.user.password || userInfo.password || '', // 使用空字符串作为默认值
        avatarPath: userStore.user.avatarPath || userStore.user.avatar_path || userInfo.avatarPath,
        email: userStore.user.email || userInfo.email,
        telephone: userStore.user.telephone || userStore.user.phone || userInfo.telephone, // 兼容不同字段名
        qq: userStore.user.qq || userInfo.qq,
        updateTime: userStore.user.updateTime || userStore.user.updated_time || userInfo.updateTime,
        createTime: userStore.user.createTime || userStore.user.created_time || userInfo.createTime,
        licensePlate: userStore.user.licensePlate || userInfo.licensePlate || '',
        carModel: userStore.user.carModel || userInfo.carModel || ''
      });
    }
  } catch (error) {
    console.error('加载用户信息失败:', error);
    ElMessage.error('加载用户信息失败');
  }
});

// 切换编辑模式
const toggleEdit = async () => {
  if (isEditing.value) {
    if (!formRef.value) return;

    formRef.value.validate(async (valid: boolean) => {
      if (valid) {
        try {
          let avatarPath = userInfo.avatarPath;
          
          if (avatarFile.value) {
            const uploadResponse = await uploadAvatar(avatarFile.value);
            if (uploadResponse.data && (uploadResponse.data.code === 200 || uploadResponse.data.state === 0 || uploadResponse.data.status === 'success')) {
              avatarPath = uploadResponse.data.data || uploadResponse.data.url || uploadResponse.data.path;
              userInfo.avatarPath = avatarPath;
            } else {
              ElMessage.error(uploadResponse.data?.message || uploadResponse.data?.msg || '头像上传失败');
              return;
            }
          }

          const userId = userInfo.id || userStore.user?.id || 0;
          const response = await updateOwnMessage(
            userId,
            userInfo.username,
            userInfo.password || '',
            avatarPath,
            userInfo.email,
            userInfo.telephone,
            'student'
          );

          console.log('更新个人信息响应:', response);

          if (response && (response.code === 200 || response.state === 0 || response.status === 'success')) {
            userStore.saveUser({
              ...userInfo,
              id: userId,
              avatarPath: avatarPath
            });
            ElMessage.success('个人信息更新成功！');
            isEditing.value = false;
            userInfo.password = '';
            avatarFile.value = null;
          } else {
            ElMessage.error(response?.message || response?.msg || '更新失败');
          }
        } catch (error: any) {
          console.error('更新用户信息失败:', error);
          if (error.response?.status === 401 || error.response?.data?.state === -1) {
            ElMessage.error('登录已过期，请重新登录');
            router.push('/user-login');
          } else {
            ElMessage.error(error.response?.data?.message || error.message || '更新失败，请稍后重试');
          }
        }
      } else {
        ElMessage.error('请填写正确的信息');
      }
    });
  } else {
    isEditing.value = true;
  }
};

// 重置表单
const resetForm = () => {
  if (!formRef.value) return;
  // 重新加载用户信息以撤销更改
  Object.assign(userInfo, userStore.user);
  formRef.value.clearValidate();
  isEditing.value = false;

  // 清空临时头像文件
  avatarFile.value = null;
};

// 触发头像上传
const triggerAvatarUpload = () => {
  // 移除编辑模式的限制，让用户可以直接点击更换头像
  // 但如果不在编辑模式，自动进入编辑模式
  if (!isEditing.value) {
    isEditing.value = true;
  }
  // 确保avatarInputRef存在
  if (avatarInputRef.value) {
    avatarInputRef.value.click();
  } else {
    console.error('avatarInputRef not found');
    ElMessage.error('头像上传组件未初始化');
  }
};

// 处理头像选择
const handleAvatarChange = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];

  if (file) {
    const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (!validTypes.includes(file.type)) {
      ElMessage.error('请选择有效的图片文件(jpg, png, gif)');
      return;
    }

    if (file.size > 2 * 1024 * 1024) {
      ElMessage.error('图片大小不能超过2MB');
      return;
    }

    // 存储文件供后续上传
    avatarFile.value = file;

    // 创建预览URL
    const reader = new FileReader();
    reader.onload = (e) => {
      userInfo.avatarPath = e.target?.result as string;
      ElMessage.success('头像已选择，保存个人信息时将一同上传');
    };
    reader.readAsDataURL(file);
  }
};
</script>

<style scoped>
.profile-page {
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.page-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.background-grid {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.grid-cell {
  position: absolute;
  width: var(--size);
  height: var(--size);
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  animation: floatGrid 15s infinite linear;
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
}

@keyframes floatGrid {
  0% {
    transform: translateY(0) translateX(0) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    transform: translateY(-100vh) translateX(100px) rotate(360deg);
    opacity: 0;
  }
}

.gradient-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at center, transparent 0%, rgba(0, 0, 0, 0.3) 100%);
  z-index: 1;
}

.page-header {
  margin: 20px;
  z-index: 10;
  position: relative;
  width: calc(100% - 40px);
  box-sizing: border-box;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.page-header h1 {
  margin: 0 0 10px 0;
  font-size: 24px;
  font-weight: 600;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-fill-color: transparent;
}

.page-header :deep(.el-breadcrumb) {
  font-size: 14px;
}

.page-header :deep(.el-breadcrumb__inner) {
  color: rgba(255, 255, 255, 0.7);
}

.page-header :deep(.el-breadcrumb__inner a) {
  color: #00c9ff;
}

.page-header :deep(.el-breadcrumb__separator) {
  color: rgba(255, 255, 255, 0.5);
}

.profile-main {
  padding: 0 20px 40px;
  z-index: 10;
  position: relative;
}

.profile-card {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(12px);
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  box-sizing: border-box;
  padding: 30px;
}

.profile-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 40px rgba(0, 201, 255, 0.2);
  border-color: rgba(0, 201, 255, 0.3);
}

.profile-header {
  display: flex;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 25px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.avatar-section {
  position: relative;
  cursor: pointer;
  margin-right: 25px;
}

.avatar-section:hover .avatar-overlay {
  opacity: 1;
}

.profile-avatar {
  border: 3px solid rgba(0, 201, 255, 0.4);
  transition: all 0.3s ease;
}

.profile-avatar:hover {
  transform: scale(1.05);
  border-color: rgba(0, 201, 255, 0.7);
  box-shadow: 0 0 20px rgba(0, 201, 255, 0.3);
}

.avatar-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 14px;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.user-info h2 {
  margin: 0 0 8px 0;
  font-size: 22px;
  color: white;
  font-weight: 600;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}

.user-info p {
  margin: 0;
  color: rgba(255, 255, 255, 0.9);
  font-size: 15px;
  font-weight: 500;
}

.profile-form {
  width: 100%;
}



.form-actions {
  text-align: center;
  margin-top: 20px;
}

:deep(.el-form-item__label) {
  color: rgba(255, 255, 255, 0.9) !important;
  font-weight: 500;
  font-size: 15px;
}

:deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.1) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  border-radius: 8px !important;
  transition: all 0.3s ease !important;
  color: white !important;
}

:deep(.el-input__inner) {
  color: white !important;
  font-size: 15px !important;
  line-height: 1.5 !important;
}

:deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.5) !important;
}

:deep(.el-input__wrapper):hover {
  background: rgba(255, 255, 255, 0.15) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
}

:deep(.el-input__wrapper.is-focus) {
  background: rgba(255, 255, 255, 0.15) !important;
  border: 1px solid rgba(0, 201, 255, 0.5) !important;
  box-shadow: 0 0 0 2px rgba(0, 201, 255, 0.2) !important;
}

/* 密码输入框特殊样式 */
:deep(.el-input--password .el-input__inner) {
  letter-spacing: 2px !important;
}

/* 密码可见性切换按钮样式 */
:deep(.el-input__suffix-inner .el-input__icon) {
  color: rgba(255, 255, 255, 0.7) !important;
  font-size: 16px !important;
  cursor: pointer !important;
  transition: color 0.3s ease !important;
}

:deep(.el-input__suffix-inner .el-input__icon:hover) {
  color: #409EFF !important;
}

/* 悬停效果和按钮样式 */
.action-button {
  transition: all 0.3s ease;
  border-radius: 8px;
  font-weight: 500;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  min-width: 100px;
  margin-right: 10px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  border: none;
  color: #0f2027;
}

.action-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 201, 255, 0.3);
}

.action-button.secondary {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
}

.action-button.secondary:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 4px 12px rgba(255, 255, 255, 0.1);
}

:deep(.el-button) {
  border-radius: 8px !important;
  font-weight: 500 !important;
  transition: all 0.3s ease !important;
}

:deep(.el-button):hover {
  transform: translateY(-2px) !important;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .profile-page {
    padding: 0 10px 20px;
  }

  .page-header {
    padding: 0 10px;
    margin: 15px 10px;
  }

  .profile-header {
    flex-direction: column;
    text-align: center;
  }

  .avatar-section {
    margin-right: 0;
    margin-bottom: 15px;
  }

  .user-info h2 {
    font-size: 20px;
  }

  .action-button {
    width: 100%;
    margin-bottom: 10px;
    margin-right: 0;
  }
}
</style>