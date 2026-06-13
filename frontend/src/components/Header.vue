<script setup lang="ts">
import {reactive} from 'vue'
import {useRouter} from 'vue-router'
import {useUserStore} from '../stores/user'

const store = useUserStore()
const router = useRouter()
const state = reactive({
  //name: store.user.username,
  hasBack: true, // 是否展示返回icon
})
// 退出登录
const btnLogout = () => {
  //把token设置为空
  store.saveToken('')
  //跳转登录页面
  router.push({
    path: "/user-login"
  })
}

// 返回方法
const back = () => {
  router.back()
}
</script>
<template>
  <div class="header">
    <div class="left">
      <el-icon class="back" v-if="state.hasBack" @click="back">
        <Back/>
      </el-icon>
      <span style="font-size: 20px">{{ store.getUser?.username }}</span>
    </div>
    <div class="right">
      <el-popover placement="bottom" :width="320" trigger="click" popper-class="popper-user-box">
        <template #reference>
          <div class="author">
            <i class="icon el-icon-s-custom"/>
            {{ store.getUser?.username || '用户' }}
            <i class="el-icon-caret-bottom"/>
          </div>
        </template>
        <div class="nickname">
          <p>登录名：{{ store.getUser?.username || '用户' }}</p>
          <el-tag size="small" effect="dark" class="logout" @click="btnLogout">退出</el-tag>
        </div>
      </el-popover>
    </div>
  </div>
</template>

<style scoped>
.header {
  height: 50px;
  border-bottom: 1px solid #e9e9e9;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.header .left .back {
  border: 1px solid #e9e9e9;
  padding: 5px;
  border-radius: 50%;
  margin-right: 5px;
  cursor: pointer;
}

.right > div > .icon {
  font-size: 18px;
  margin-right: 6px;
}

.author {
  margin-left: 10px;
  cursor: pointer;
}
</style>

<style>
.popper-user-box {
  background: url('https://s.yezgea02.com/lingling-h5/static/account-banner-bg.png') 50% 50% no-repeat !important;
  background-size: cover !important;
  border-radius: 0 !important;
}

.popper-user-box .nickname {
  position: relative;
  color: #ffffff;
}

.popper-user-box .nickname .logout {
  position: absolute;
  right: 0;
  top: 0;
  cursor: pointer;
}
</style>
