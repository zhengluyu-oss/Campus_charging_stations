<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import type { FormInstance, FormRules, UploadFile } from 'element-plus'
import { ElMessage } from 'element-plus'
import { Edit, Lock, Message, Phone, User } from '@element-plus/icons-vue'
import { getCurrentUser, updateOwnMessage } from '@/api/user'
import { uploadAvatar } from '@/api/upload'
import { useUserStore } from '@/stores/user'
import { useEffects, type EffectsLevel } from '@/effects/effectsContext'

const store = useUserStore()
const effects = useEffects()
const effectsLevel = computed(() => effects.level.value)
const formRef = ref<FormInstance>()
const editing = ref(false)
const saving = ref(false)
const avatarFile = ref<File>()
const password = ref('')
const form = reactive<any>({ id: 0, username: '', email: '', telephone: '', avatarPath: '' })

const onEffectsChange = (val: string | number | boolean | undefined) => {
  if (val === 'off' || val === 'low' || val === 'full') effects.setLevel(val as EffectsLevel)
}

const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '邮箱格式不正确', trigger: 'blur' },
  ],
  telephone: [{ required: true, message: '请输入手机号码', trigger: 'blur' }],
}

const assign = (user: any) =>
  Object.assign(form, {
    id: user?.id || 0,
    username: user?.username || '',
    email: user?.email || '',
    telephone: user?.telephone || user?.phone || '',
    avatarPath: user?.avatarPath || user?.avatar_path || '',
  })

onMounted(async () => {
  if (store.user) {
    assign(store.user)
    return
  }
  try {
    const response: any = await getCurrentUser()
    assign(response?.data)
  } catch {
    // The page remains usable with an empty form if account loading fails.
  }
})

const choose = (file: UploadFile) => {
  if (!editing.value) return
  if (file.raw) {
    avatarFile.value = file.raw
    form.avatarPath = URL.createObjectURL(file.raw)
  }
}

const save = async () => {
  if (!editing.value) {
    editing.value = true
    return
  }
  if (!formRef.value || !(await formRef.value.validate().catch(() => false))) return

  saving.value = true
  try {
    let avatar = form.avatarPath
    if (avatarFile.value) {
      const uploadResponse: any = await uploadAvatar(avatarFile.value)
      avatar = uploadResponse?.data || uploadResponse?.url || avatar
    }
    await updateOwnMessage(
      form.id,
      form.username,
      password.value,
      avatar,
      form.email,
      form.telephone,
      'student',
    )
    const next: any = { ...(store.user || {}), ...form, avatarPath: avatar }
    store.saveUser(next)
    form.avatarPath = avatar
    avatarFile.value = undefined
    password.value = ''
    editing.value = false
    ElMessage.success('个人资料已保存')
  } catch {
    ElMessage.error('保存失败，请稍后重试')
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="profile-page">
    <header class="page-header profile-header">
      <div>
        <p class="eyebrow">ACCOUNT SETTINGS</p>
        <h1>账户设置</h1>
      </div>
      <p>管理你的个人资料、联系方式与登录安全。</p>
    </header>

    <main class="profile-main">
      <section class="account-summary">
        <div class="identity">
          <el-upload
            :show-file-list="false"
            :auto-upload="false"
            accept="image/*"
            :disabled="!editing"
            :on-change="choose"
          >
            <div class="avatar-wrap" :class="{ editable: editing }">
              <el-avatar :size="80" :src="form.avatarPath">
                {{ form.username?.slice(0, 1) }}
              </el-avatar>
              <span v-if="editing" class="avatar-edit"><Edit /></span>
            </div>
          </el-upload>
          <div>
            <span class="account-label">STUDENT ACCOUNT</span>
            <h2>{{ form.username || '校园用户' }}</h2>
            <p>{{ form.email || '尚未填写邮箱' }}</p>
          </div>
        </div>
        <div class="account-state">
          <i />
          <div>
            <span>账户状态</span>
            <strong>正常使用</strong>
          </div>
        </div>
      </section>

      <section class="effects-panel glass-panel">
        <div>
          <span class="account-label">VISUAL EFFECTS</span>
          <h2>视觉特效等级</h2>
          <p>答辩/服务器演示时可切换 Full / Low / Off，弱设备会自动降级。</p>
        </div>
        <el-radio-group :model-value="effectsLevel" @change="onEffectsChange">
          <el-radio-button value="full">Full</el-radio-button>
          <el-radio-button value="low">Low</el-radio-button>
          <el-radio-button value="off">Off</el-radio-button>
        </el-radio-group>
      </section>

      <section class="settings-layout">
        <aside>
          <span class="section-number">01</span>
          <h2>个人资料</h2>
          <p>这些信息用于识别账户，并帮助你及时接收预约和充电通知。</p>
        </aside>

        <div class="settings-panel">
          <header>
            <div>
              <h2>基本信息</h2>
              <p>{{ editing ? '修改完成后请保存。' : '点击编辑后即可更新资料。' }}</p>
            </div>
            <el-button
              :type="editing ? 'primary' : 'default'"
              :loading="saving"
              @click="save"
            >
              {{ editing ? '保存修改' : '编辑资料' }}
            </el-button>
          </header>

          <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
            <div class="field-row">
              <div class="field-icon"><User /></div>
              <div class="field-copy">
                <strong>用户名</strong>
                <span>在校园服务中展示的账户名称</span>
              </div>
              <el-form-item prop="username">
                <el-input v-model="form.username" :disabled="!editing" />
              </el-form-item>
            </div>

            <div class="field-row">
              <div class="field-icon"><Message /></div>
              <div class="field-copy">
                <strong>电子邮箱</strong>
                <span>用于接收服务通知与账户信息</span>
              </div>
              <el-form-item prop="email">
                <el-input v-model="form.email" :disabled="!editing" />
              </el-form-item>
            </div>

            <div class="field-row">
              <div class="field-icon"><Phone /></div>
              <div class="field-copy">
                <strong>手机号码</strong>
                <span>设备异常时的重要联系方式</span>
              </div>
              <el-form-item prop="telephone">
                <el-input v-model="form.telephone" :disabled="!editing" />
              </el-form-item>
            </div>

            <div class="field-row password-row">
              <div class="field-icon"><Lock /></div>
              <div class="field-copy">
                <strong>登录密码</strong>
                <span>留空代表继续使用当前密码</span>
              </div>
              <el-form-item>
                <el-input
                  v-model="password"
                  type="password"
                  show-password
                  placeholder="不修改请留空"
                  :disabled="!editing"
                />
              </el-form-item>
            </div>
          </el-form>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.profile-page {
  min-height: calc(100vh - 72px);
  padding-bottom: 80px;
  background: transparent;
}

.effects-panel {
  margin: 8px 0 28px;
  padding: 22px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}
.effects-panel h2 {
  margin: 8px 0 6px;
  font-size: 20px;
}
.effects-panel p {
  margin: 0;
  color: var(--text-secondary);
  font-size: 13px;
}

.profile-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 40px;
  padding-top: 56px !important;
  padding-bottom: 38px !important;
}

.eyebrow,
.profile-header h1,
.profile-header p {
  margin: 0;
}

.eyebrow {
  margin-bottom: 12px;
  color: var(--brand);
  font-size: 11px;
  font-weight: 800;
  letter-spacing: .18em;
}

.profile-header h1 {
  font-size: clamp(42px, 6vw, 68px);
  font-weight: 720;
  letter-spacing: -.065em;
}

.profile-header > p {
  max-width: 330px;
  padding-bottom: 8px;
  color: var(--text-secondary);
  font-size: 14px;
  line-height: 1.7;
}

.account-summary {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 32px;
  padding: 30px 0;
  border-top: 1px solid var(--text-primary);
  border-bottom: 1px solid var(--border-color);
}

.identity,
.account-state {
  display: flex;
  align-items: center;
}

.identity {
  gap: 22px;
}

.avatar-wrap {
  position: relative;
  display: block;
}

.avatar-wrap.editable {
  cursor: pointer;
}

.avatar-wrap :deep(.el-avatar) {
  color: var(--surface);
  background: var(--text-primary);
  border: 1px solid var(--border-color);
  font-size: 28px;
  font-weight: 700;
}

.avatar-edit {
  position: absolute;
  right: -4px;
  bottom: 1px;
  display: grid;
  width: 28px;
  height: 28px;
  place-items: center;
  color: #fff;
  background: var(--brand);
  border: 3px solid var(--surface-muted);
  border-radius: 50%;
}

.avatar-edit :deep(svg) {
  width: 12px;
}

.account-label {
  color: var(--brand);
  font-size: 9px;
  font-weight: 800;
  letter-spacing: .14em;
}

.identity h2,
.identity p {
  margin: 0;
}

.identity h2 {
  margin-top: 7px;
  font-size: 23px;
  letter-spacing: -.03em;
}

.identity p {
  margin-top: 5px;
  color: var(--text-muted);
  font-size: 12px;
}

.account-state {
  gap: 11px;
  min-width: 150px;
  padding-left: 24px;
  border-left: 1px solid var(--border-color);
}

.account-state i {
  width: 9px;
  height: 9px;
  background: var(--success);
  border-radius: 50%;
  box-shadow: 0 0 0 5px color-mix(in srgb, var(--success) 12%, transparent);
}

.account-state span,
.account-state strong {
  display: block;
}

.account-state span {
  color: var(--text-muted);
  font-size: 10px;
}

.account-state strong {
  margin-top: 4px;
  font-size: 13px;
}

.settings-layout {
  display: grid;
  grid-template-columns: minmax(220px, .8fr) 2.4fr;
  gap: clamp(40px, 8vw, 110px);
  padding-top: 70px;
}

.settings-layout aside {
  align-self: start;
  position: sticky;
  top: 96px;
}

.section-number {
  color: var(--brand);
  font-size: 11px;
  font-weight: 800;
}

.settings-layout aside h2 {
  margin: 15px 0 12px;
  font-size: 25px;
  letter-spacing: -.035em;
}

.settings-layout aside p {
  max-width: 280px;
  margin: 0;
  color: var(--text-secondary);
  font-size: 12px;
  line-height: 1.8;
}

.settings-panel {
  min-width: 0;
}

.settings-panel > header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 24px;
  padding-bottom: 22px;
  border-bottom: 1px solid var(--text-primary);
}

.settings-panel header h2,
.settings-panel header p {
  margin: 0;
}

.settings-panel header h2 {
  font-size: 20px;
  letter-spacing: -.02em;
}

.settings-panel header p {
  margin-top: 6px;
  color: var(--text-muted);
  font-size: 11px;
}

.field-row {
  display: grid;
  grid-template-columns: 28px minmax(190px, 1fr) minmax(260px, 1.15fr);
  gap: 18px;
  align-items: center;
  min-height: 108px;
  border-bottom: 1px solid var(--border-color);
}

.field-icon {
  display: grid;
  width: 28px;
  height: 28px;
  place-items: center;
  color: var(--text-secondary);
}

.field-icon :deep(svg) {
  width: 18px;
}

.field-copy strong,
.field-copy span {
  display: block;
}

.field-copy strong {
  font-size: 13px;
}

.field-copy span {
  margin-top: 6px;
  color: var(--text-muted);
  font-size: 10px;
}

.field-row :deep(.el-form-item) {
  margin: 0;
}

.field-row :deep(.el-input__wrapper) {
  background: var(--surface) !important;
  border-radius: 6px !important;
}

.field-row :deep(.el-input.is-disabled .el-input__wrapper) {
  background: transparent !important;
  box-shadow: none !important;
}

.field-row :deep(.el-input.is-disabled .el-input__inner) {
  color: var(--text-primary);
  -webkit-text-fill-color: var(--text-primary);
}

@media (max-width: 780px) {
  .settings-layout {
    grid-template-columns: 1fr;
    gap: 34px;
    padding-top: 52px;
  }

  .settings-layout aside {
    position: static;
  }
}

@media (max-width: 620px) {
  .profile-header {
    align-items: flex-start;
    flex-direction: column;
    gap: 14px;
    padding-top: 36px !important;
  }

  .account-summary {
    align-items: flex-start;
    flex-direction: column;
  }

  .account-state {
    width: 100%;
    padding: 18px 0 0;
    border-top: 1px solid var(--border-color);
    border-left: 0;
  }

  .settings-panel > header {
    align-items: stretch;
    flex-direction: column;
  }

  .field-row {
    grid-template-columns: 28px 1fr;
    padding: 22px 0;
  }

  .field-row :deep(.el-form-item) {
    grid-column: 1 / -1;
  }
}
</style>
