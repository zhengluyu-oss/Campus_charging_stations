<script setup lang="ts">import{useRouter}from'vue-router';import{ArrowRight,Calendar,Clock,Lightning,Search}from'@element-plus/icons-vue';const router=useRouter();const options=[{title:'立即充电',desc:'选择当前空闲的充电桩并设置充电时长',path:'/user/use-charger',icon:Lightning,tag:'推荐'},{title:'预约充电',desc:'提前安排充电时间，减少到站后的等待',path:'/booking',icon:Calendar},{title:'查看站点',desc:'浏览全校充电桩的实时使用状态',path:'/user/charging-stations',icon:Search},{title:'充电记录',desc:'查询历史订单、充电时长与费用信息',path:'/history',icon:Clock}]</script>
<template>
  <div class="options-page">
    <header class="page-header options-header"><p>SERVICE DIRECTORY / 04</p><h1>电量，由你安排。</h1><span>即时开始、提前预约，或者先了解校园站点状态。</span></header>
    <main class="options-main">
      <section class="service-list" aria-label="充电服务">
        <button v-for="(item,index) in options" :key="item.path" type="button" @click="router.push(item.path)">
          <span class="number">{{String(index + 1).padStart(2,'0')}}</span>
          <span class="service-icon"><component :is="item.icon"/></span>
          <span class="service-copy"><span class="title-line"><strong>{{item.title}}</strong><em v-if="item.tag">{{item.tag}}</em></span><small>{{item.desc}}</small></span>
          <span class="action">OPEN <ArrowRight/></span>
        </button>
      </section>
      <aside class="operation-note">
        <span class="note-icon"><Lightning/></span>
        <div><small>BEFORE YOU CHARGE</small><strong>连接设备，确认状态，然后开始。</strong></div>
        <p>请先确认充电枪连接稳固，并根据实际行程设置合理时长。</p>
      </aside>
    </main>
  </div>
</template>
<style scoped>
.options-page{min-height:calc(100vh - 64px);padding-bottom:64px;background:var(--surface-muted)}.options-header{padding-top:58px!important;padding-bottom:38px!important}.options-header p,.options-header h1,.options-header span{margin:0}.options-header p{color:var(--brand);font-size:11px;font-weight:800;letter-spacing:.18em}.options-header h1{margin:14px 0 16px;font-size:clamp(44px,6vw,72px);font-weight:650;line-height:1;letter-spacing:-.06em}.options-header>span{color:var(--text-secondary);font-size:14px}
.service-list{background:var(--surface);border:1px solid var(--border-color);border-radius:14px;overflow:hidden}.service-list>button{position:relative;width:100%;min-height:126px;display:grid;grid-template-columns:64px 48px minmax(260px,1fr) 100px;align-items:center;gap:24px;padding:24px 30px;color:var(--text-primary);text-align:left;background:var(--surface);border:0;border-bottom:1px solid var(--border-color);cursor:pointer;overflow:hidden;transition:color .25s,background .25s}.service-list>button:last-child{border-bottom:0}.service-list>button::before{content:'';position:absolute;inset:0;background:var(--brand);transform:translateX(-101%);transition:transform .38s cubic-bezier(.22,1,.36,1)}.service-list>button>*{position:relative;z-index:1}.service-list>button:hover{color:#fff}.service-list>button:hover::before{transform:translateX(0)}
.number{color:var(--text-muted);font-size:11px;font-weight:750;letter-spacing:.1em}.service-icon{width:46px;height:46px;display:grid;place-items:center;color:var(--brand);background:var(--brand-soft);border-radius:9px;transition:color .25s,background .25s}.service-icon :deep(svg){width:22px}.service-list>button:hover .number,.service-list>button:hover .service-copy small{color:rgba(255,255,255,.68)}.service-list>button:hover .service-icon{color:#fff;background:rgba(255,255,255,.16)}.service-copy{display:block}.title-line{display:flex;align-items:center;gap:11px}.service-copy strong{font-size:25px;font-weight:650;letter-spacing:-.035em}.service-copy em{padding:4px 7px;color:var(--brand);background:var(--brand-soft);border-radius:4px;font-size:8px;font-style:normal;font-weight:850;letter-spacing:.1em}.service-list>button:hover .service-copy em{color:var(--text-primary);background:#b8f34a}.service-copy small{display:block;margin-top:8px;color:var(--text-secondary);font-size:12px;transition:color .25s}.action{display:flex;align-items:center;justify-content:flex-end;gap:12px;font-size:9px;font-weight:850;letter-spacing:.15em}.action :deep(svg){width:18px;transition:transform .25s}.service-list>button:hover .action :deep(svg){transform:translateX(5px)}
.operation-note{display:grid;grid-template-columns:48px minmax(230px,.8fr) 1.2fr;align-items:center;gap:20px;margin-top:18px;padding:22px 26px;color:#fff;background:#0a0b0d;border-radius:12px}.note-icon{width:44px;height:44px;display:grid;place-items:center;color:#0a0b0d;background:#b8f34a;border-radius:8px}.note-icon :deep(svg){width:22px}.operation-note small,.operation-note strong{display:block}.operation-note small{color:#9297a1;font-size:8px;font-weight:800;letter-spacing:.15em}.operation-note strong{margin-top:6px;font-size:13px}.operation-note p{margin:0;color:#aeb2ba;font-size:11px;line-height:1.65}
@media(max-width:720px){.service-list>button{grid-template-columns:34px 42px 1fr;gap:13px;min-height:112px;padding:20px 16px}.service-icon{width:40px;height:40px}.service-copy strong{font-size:19px}.action{display:none}.operation-note{grid-template-columns:44px 1fr}.operation-note p{grid-column:1/-1}.options-header h1{font-size:42px}}
</style>
