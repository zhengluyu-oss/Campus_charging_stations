<template>
  <div class="password-input-container">
    <el-input
      :model-value="modelValue"
      :type="inputType"
      :placeholder="placeholder"
      @input="handleInput"
      @blur="handleBlur"
      @focus="handleFocus"
      class="password-input"
      show-password
    >
      <template #prefix>
        <el-icon><Lock /></el-icon>
      </template>
    </el-input>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import { Lock } from '@element-plus/icons-vue';

const props = defineProps<{
  modelValue: string;
  placeholder?: string;
}>();

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void;
}>();

const inputType = ref('password');
const passwordValue = ref(props.modelValue);
const visibleChars = ref<{ [key: number]: string }>({});
const timers = ref<{ [key: number]: number }>({});

// 监听modelValue变化
watch(
  () => props.modelValue,
  (newValue) => {
    passwordValue.value = newValue;
  }
);

// 处理输入
const handleInput = (value: string) => {
  emit('update:modelValue', value);
  passwordValue.value = value;
  
  // 处理临时显示字符
  const newValue = value as string;
  const oldValue = passwordValue.value;
  
  // 找到新增的字符位置
  if (newValue.length > oldValue.length) {
    const newCharIndex = newValue.length - 1;
    const newChar = newValue[newCharIndex];
    
    // 临时显示新字符
    visibleChars.value[newCharIndex] = newChar;
    
    // 清除之前的定时器
    if (timers.value[newCharIndex]) {
      clearTimeout(timers.value[newCharIndex]);
    }
    
    // 2秒后隐藏字符
    timers.value[newCharIndex] = window.setTimeout(() => {
      delete visibleChars.value[newCharIndex];
    }, 2000);
  }
};

// 处理失去焦点
const handleBlur = () => {
  // 清除所有定时器
  Object.values(timers.value).forEach(timer => clearTimeout(timer));
  timers.value = {};
  // 隐藏所有字符
  visibleChars.value = {};
};

// 处理获得焦点
const handleFocus = () => {
  // 可以在这里添加焦点相关的逻辑
};
</script>

<style scoped>
.password-input-container {
  position: relative;
  width: 100%;
}

.password-input {
  width: 100%;
}

.password-visibility-icon {
  cursor: pointer;
  transition: color 0.3s ease;
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
}

.password-visibility-icon:hover {
  color: #409EFF;
}

.password-visibility-icon.active {
  color: #409EFF;
}

:deep(.el-input__inner) {
  color: white !important;
  font-size: 16px !important;
  line-height: 1.5 !important;
  letter-spacing: 2px !important;
}

:deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.7) !important;
}

:deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.2) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  border-radius: 8px !important;
  transition: all 0.3s ease !important;
  color: white !important;
}

:deep(.el-input__wrapper):hover {
  background: rgba(255, 255, 255, 0.25) !important;
  border: 1px solid rgba(255, 255, 255, 0.6) !important;
  box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.1) !important;
}

:deep(.el-input__wrapper.is-focus) {
  background: rgba(255, 255, 255, 0.3) !important;
  border: 1px solid #409EFF !important;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.3) !important;
}
</style>