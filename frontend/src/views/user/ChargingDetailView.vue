<script setup lang="ts">
import { computed, onBeforeUnmount, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft, Clock, Lightning, Location, Wallet } from '@element-plus/icons-vue'

const route=useRoute(),router=useRouter()
const total=Number(route.query.duration||60)*60
const elapsed=ref(0)
const timer=window.setInterval(()=>{if(elapsed.value<total)elapsed.value++},1000)
onBeforeUnmount(()=>clearInterval(timer))
const percent=computed(()=>Math.min(100,Math.round(elapsed.value/total*100)))
const remaining=computed(()=>Math.ceil((total-elapsed.value)/60))
const cost=computed(()=>elapsed.value/3600*.5)
const time=computed(()=>`${String(Math.floor(elapsed.value/60)).padStart(2,'0')}:${String(elapsed.value%60).padStart(2,'0')}`)
</script>

<template>
  <div class="charge-page">
    <main class="charge-console">
      <header class="console-header">
        <button type="button" @click="router.push('/user-dashboard')"><ArrowLeft /> 返回工作台</button>
        <div class="session-id">SESSION / #{{ route.params.id }}</div>
        <span class="live"><i /> 充电进行中</span>
      </header>

      <section class="charge-stage">
        <div class="charge-location"><Location /> {{route.query.location||'校园充电区'}} <span>·</span> 充电桩 #{{route.params.id}}</div>
        <div class="progress-number"><strong>{{ percent }}</strong><span>%<small>CHARGED</small></span></div>
        <div class="linear-progress"><i :style="{ width: `${percent}%` }"></i></div>
        <p>设备运行正常。充电完成后，请及时移走车辆并保持充电区域畅通。</p>
        <Lightning class="energy-mark" />
      </section>

      <section class="metrics">
        <article><Clock /><span><small>已充时长</small><strong>{{time}}</strong></span><b>ELAPSED</b></article>
        <article><Clock /><span><small>预计剩余</small><strong>{{remaining}} 分钟</strong></span><b>REMAINING</b></article>
        <article><Wallet /><span><small>当前费用</small><strong>¥{{cost.toFixed(2)}}</strong></span><b>CURRENT COST</b></article>
      </section>

      <footer class="console-footer"><span>请勿在充电过程中强行拔出设备</span><el-button @click="router.push('/user-dashboard')">返回首页</el-button></footer>
    </main>
  </div>
</template>

<style scoped>
.charge-page{min-height:calc(100vh - 68px);display:grid;place-items:center;padding:45px 24px;color:#fff;background:#0d0f15!important}.charge-console{width:min(1120px,100%);border:1px solid #292c36;border-radius:14px;overflow:hidden;background:radial-gradient(circle at 84% 18%,rgba(83,98,246,.2),transparent 28%),#12141b;box-shadow:0 40px 100px rgba(0,0,0,.28)}.console-header{height:62px;padding:0 26px;display:grid;grid-template-columns:1fr auto 1fr;align-items:center;border-bottom:1px solid #292c36}.console-header button{width:fit-content;display:flex;align-items:center;gap:7px;padding:0;color:#9296a2;background:none;border:0;font-size:10px;cursor:pointer}.console-header button :deep(svg){width:14px}.session-id{color:#5f6370;font-size:8px;letter-spacing:.14em}.live{justify-self:end;display:flex;align-items:center;gap:7px;color:#8fff75;font-size:9px;font-weight:750;letter-spacing:.08em}.live i{width:6px;height:6px;background:currentColor;border-radius:50%;box-shadow:0 0 0 5px rgba(143,255,117,.08)}.charge-stage{position:relative;min-height:470px;padding:64px 8vw 52px;overflow:hidden}.charge-location{display:flex;align-items:center;gap:7px;color:#858995;font-size:10px}.charge-location :deep(svg){width:14px;color:#7681ff}.charge-location span{color:#444751}.progress-number{display:flex;align-items:flex-end;margin:72px 0 40px}.progress-number>strong{font-size:clamp(110px,17vw,205px);font-weight:570;line-height:.63;letter-spacing:-.085em}.progress-number>span{margin-left:22px;color:#7783ff;font-size:40px;line-height:.8}.progress-number small{display:block;margin:19px 0 3px;color:#636773;font-size:8px;letter-spacing:.16em}.linear-progress{position:relative;height:5px;background:#2d303a;overflow:hidden}.linear-progress i{position:relative;display:block;height:100%;background:linear-gradient(90deg,#6675ff,#9d6df2 65%,#ff7951);transition:width .6s ease}.linear-progress i::after{content:'';position:absolute;right:0;top:-3px;width:11px;height:11px;background:#fff;border-radius:50%;box-shadow:0 0 20px #8290ff}.charge-stage>p{max-width:520px;margin:24px 0 0;color:#777b87;font-size:11px;line-height:1.7}.energy-mark{position:absolute;width:290px;right:3vw;top:75px;color:rgba(255,255,255,.022)}.metrics{display:grid;grid-template-columns:repeat(3,1fr);border-top:1px solid #292c36;border-bottom:1px solid #292c36}.metrics article{position:relative;min-height:115px;padding:26px 30px;display:grid;grid-template-columns:28px 1fr;align-items:center;gap:13px}.metrics article+article{border-left:1px solid #292c36}.metrics article>:deep(svg){width:21px;color:#7783ff}.metrics small,.metrics strong{display:block}.metrics small{color:#686c78;font-size:8px;letter-spacing:.06em}.metrics strong{margin-top:7px;color:#fff;font-size:18px}.metrics article>b{position:absolute;right:18px;top:15px;color:#353843;font-size:7px;letter-spacing:.12em}.console-footer{min-height:76px;padding:0 25px;display:flex;align-items:center;justify-content:space-between;gap:20px}.console-footer>span{color:#636773;font-size:9px}.console-footer :deep(.el-button){color:#fff;background:#20232d;border-color:#323641}
@media(max-width:700px){.charge-page{padding:16px 12px}.console-header{grid-template-columns:1fr auto}.session-id{display:none}.charge-stage{min-height:390px;padding:52px 22px 40px}.progress-number{margin-top:82px}.progress-number>strong{font-size:108px}.energy-mark{width:180px}.metrics{grid-template-columns:1fr}.metrics article{min-height:90px}.metrics article+article{border-left:0;border-top:1px solid #292c36}.console-footer{padding:18px 20px;align-items:flex-start;flex-direction:column}}
</style>
