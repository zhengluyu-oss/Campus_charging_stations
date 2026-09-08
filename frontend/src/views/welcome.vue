<script setup lang="ts">
import { useRouter } from 'vue-router'
import { ArrowRight, Calendar, Clock, Lightning, Location, Search, TrendCharts } from '@element-plus/icons-vue'

const router = useRouter()
const capabilities = [
  { no: '01', icon: Search, title: '先看状态，再去现场', desc: '按校园区域浏览充电站，空闲、使用中与维护状态一目了然。' },
  { no: '02', icon: Calendar, title: '把时间留给自己', desc: '提前选择站点和时间段，让充电安排更确定。' },
  { no: '03', icon: TrendCharts, title: '每次充电都有记录', desc: '统一查看时长、费用与历史订单，重要信息不遗漏。' },
]
</script>

<template>
  <main class="landing">
    <section class="dark-stage">
      <nav class="landing-nav">
        <button class="landing-brand" type="button" aria-label="校园充电首页">
          <span class="brand-symbol"><i></i><i></i></span>
          <span><strong>CAMPUS</strong><strong>CHARGE</strong></span>
        </button>
        <div class="nav-links"><a href="#product">产品</a><a href="#workflow">服务流程</a></div>
        <div class="nav-actions">
          <el-button text @click="router.push('/user-login')">登录</el-button>
          <el-button @click="router.push('/user-register')">创建账户</el-button>
        </div>
      </nav>

      <div class="hero">
        <div class="hero-copy">
          <p class="eyebrow"><i></i> CAMPUS ENERGY SYSTEM</p>
          <h1>校园充电<br><em>少一点等待。</em></h1>
          <p class="hero-description">从寻找空闲站点、预约时间，到查看充电记录，一套简洁的校园能源服务系统，让每次出发更从容。</p>
          <div class="hero-actions">
            <el-button type="primary" size="large" @click="router.push('/user-login')">进入系统 <ArrowRight /></el-button>
            <button type="button" class="text-action" @click="router.push('/user-register')">注册校园账户 <ArrowRight /></button>
          </div>
          <div class="hero-index"><span>01 站点查询</span><span>02 预约充电</span><span>03 记录管理</span></div>
        </div>

        <div id="product" class="product-window" aria-label="校园充电产品界面预览">
          <div class="window-bar"><span class="window-dots"><i></i><i></i><i></i></span><small>产品界面预览</small><b>ONLINE</b></div>
          <div class="product-body">
            <aside class="product-rail"><span class="rail-logo"><Lightning /></span><i class="active"></i><i></i><i></i><i></i><span class="rail-avatar">U</span></aside>
            <div class="map-workspace">
              <header><div><small>CAMPUS NETWORK</small><h2>寻找充电位</h2></div><span><Search /> 按校区或楼宇查找</span></header>
              <div class="campus-map">
                <span class="building one">图书馆</span><span class="building two">教学区</span><span class="building three">学生公寓</span>
                <button class="map-pin p1" type="button"><i></i><b>4</b></button>
                <button class="map-pin p2 busy" type="button"><i></i><b>2</b></button>
                <button class="map-pin p3" type="button"><i></i><b>6</b></button>
                <span class="map-path path-a"></span><span class="map-path path-b"></span>
              </div>
              <div class="map-key"><span><i class="available"></i>空闲</span><span><i class="busy"></i>使用中</span><small>状态示意</small></div>
            </div>
            <aside class="station-drawer">
              <div class="drawer-heading"><small>推荐站点</small><span>查看全部 <ArrowRight /></span></div>
              <article><span class="station-status available"></span><div><strong>图书馆充电区</strong><small><Location /> 北区 · 7 kW</small></div><b>空闲</b></article>
              <article><span class="station-status busy"></span><div><strong>综合楼充电区</strong><small><Location /> 南区 · 14 kW</small></div><b class="busy-label">使用中</b></article>
              <article><span class="station-status available"></span><div><strong>学生公寓充电区</strong><small><Location /> 东区 · 7 kW</small></div><b>空闲</b></article>
              <button type="button" class="drawer-action" @click="router.push('/user-login')"><Lightning /> 登录后开始充电</button>
            </aside>
          </div>
        </div>
      </div>
    </section>

    <section id="workflow" class="workflow">
      <div class="section-intro">
        <p>ONE SYSTEM, FULL JOURNEY</p>
        <h2>从找到站点到完成充电，<br>每一步都清清楚楚。</h2>
      </div>
      <div class="capability-list">
        <article v-for="item in capabilities" :key="item.no">
          <span class="capability-no">{{ item.no }}</span>
          <span class="capability-icon"><component :is="item.icon" /></span>
          <h3>{{ item.title }}</h3>
          <p>{{ item.desc }}</p>
          <ArrowRight class="capability-arrow" />
        </article>
      </div>
      <div class="service-band">
        <div><Clock /><span><small>每日服务时间</small><strong>07:00—23:00</strong></span></div>
        <p>充电状态以登录后的系统数据为准</p>
        <el-button type="primary" @click="router.push('/user-register')">创建账户 <ArrowRight /></el-button>
      </div>
    </section>
  </main>
</template>

<style scoped>
.landing { min-height: 100vh; overflow: hidden; color: var(--text-primary); background: var(--bg-void); }
.dark-stage {
  position: relative;
  min-height: 930px;
  color: #fff;
  background:
    radial-gradient(circle at 76% 22%, rgba(0, 229, 255, .22), transparent 28%),
    radial-gradient(circle at 96% 54%, rgba(124, 255, 178, .1), transparent 22%),
    #070b12;
}
.dark-stage::before { content: ''; position: absolute; inset: 0; opacity: .13; pointer-events: none; background-image: linear-gradient(rgba(255,255,255,.12) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.12) 1px,transparent 1px); background-size: 56px 56px; mask-image: linear-gradient(to bottom,#000,transparent 82%); }
.landing-nav { position: relative; z-index: 2; width: min(1320px, calc(100% - 56px)); height: 78px; margin: auto; display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; border-bottom: 1px solid rgba(255,255,255,.12); }
.landing-brand { width: fit-content; display: flex; align-items: center; gap: 10px; padding: 0; color: #fff; background: none; border: 0; cursor: pointer; }
.brand-symbol { position: relative; width: 30px; height: 30px; display: block; background: var(--brand); border-radius: 6px; overflow: hidden; }
.brand-symbol i { position: absolute; top: 5px; width: 5px; height: 20px; background: #fff; transform: skew(-18deg); }.brand-symbol i:first-child{left:8px}.brand-symbol i:last-child{right:7px;opacity:.4}
.landing-brand > span:last-child { display: grid; font-size: 10px; line-height: 1.05; letter-spacing: .15em; text-align: left; font-family: var(--font-display); }.landing-brand strong:last-child{color:var(--brand-cyan)}
.nav-links { display: flex; gap: 32px; color: #a9abb5; font-size: 12px; }.nav-links a:hover{color:#fff}
.nav-actions { justify-self: end; display: flex; align-items: center; gap: 6px; }.nav-actions :deep(.el-button.is-text){color:#d8d9df}.nav-actions :deep(.el-button:not(.is-text)){color:#11131a;background:#fff;border-color:#fff}
.hero { position: relative; z-index: 1; width: min(1320px, calc(100% - 56px)); margin: auto; display: grid; grid-template-columns: .85fr 1.15fr; align-items: center; gap: 66px; padding: 100px 0 118px; }
.eyebrow { display: flex; align-items: center; gap: 9px; margin: 0 0 27px; color: #a9abb5; font-size: 11px; font-weight: 750; letter-spacing: .15em; }.eyebrow i{width:7px;height:7px;background:#8dff73;border-radius:50%;box-shadow:0 0 0 5px rgba(141,255,115,.1)}
h1 { margin: 0; font-size: clamp(52px, 5.4vw, 74px); font-weight: 600; line-height: .98; letter-spacing: .01em; font-family: var(--font-display); }h1 em{display:block;color:var(--brand-cyan);font-style:normal;white-space:nowrap}
.hero-description { max-width: 550px; margin: 30px 0 0; color: #b5b7c0; font-size: 16px; line-height: 1.85; }
.hero-actions { display: flex; align-items: center; gap: 26px; margin-top: 38px; }.hero-actions :deep(.el-button){min-height:50px;padding-inline:23px}.text-action{display:flex;align-items:center;gap:8px;padding:12px 0;color:#fff;background:none;border:0;cursor:pointer;font-weight:650}.text-action :deep(svg){width:15px}.text-action:hover{color:#9da6ff}
.hero-index { display: flex; gap: 22px; margin-top: 78px; color: #737680; font-size: 10px; letter-spacing: .07em; }
.product-window { min-width: 0; overflow: hidden; background: #f4f3ef; border: 1px solid rgba(255,255,255,.22); border-radius: 16px; box-shadow: 0 45px 100px rgba(0,0,0,.38); transform: perspective(1200px) rotateY(-2deg); transform-origin: center right; }
.window-bar { height: 43px; padding: 0 15px; display: flex; align-items: center; color: #7f828b; background: #fff; border-bottom: 1px solid #dddde0; font-size: 9px; letter-spacing: .08em; }.window-dots{display:flex;gap:5px;margin-right:auto}.window-dots i{width:7px;height:7px;background:#d7d7d7;border-radius:50%}.window-bar small{position:absolute;left:50%;transform:translateX(-50%)}.window-bar b{margin-left:auto;color:#188f62;font-size:8px}
.product-body { min-height: 510px; display: grid; grid-template-columns: 54px 1fr 215px; color: var(--ink); }
.product-rail { padding: 16px 0; display: flex; align-items: center; flex-direction: column; gap: 18px; background: #11131a; }.rail-logo{width:30px;height:30px;display:grid;place-items:center;color:#fff;background:var(--brand);border-radius:7px}.rail-logo :deep(svg){width:16px}.product-rail>i{width:17px;height:4px;background:#343640;border-radius:2px}.product-rail>i.active{background:#7e89ff}.rail-avatar{width:25px;height:25px;margin-top:auto;display:grid;place-items:center;color:#fff;background:#555d7b;border-radius:6px;font-size:8px}
.map-workspace { min-width: 0; padding: 28px 24px 16px; background:#f4f3ef; }.map-workspace header{display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:20px}.map-workspace header small{font-size:8px;color:#8d8f97;letter-spacing:.12em}.map-workspace h2{margin:5px 0 0;font-size:23px;letter-spacing:-.04em}.map-workspace header>span{width:180px;padding:9px 10px;display:flex;align-items:center;gap:6px;color:#9a9ca4;background:#fff;border:1px solid #deddd8;border-radius:7px;font-size:8px}.map-workspace header>span :deep(svg){width:12px}
.campus-map{position:relative;height:360px;overflow:hidden;background-color:#e9e8e3;background-image:linear-gradient(#deddd7 1px,transparent 1px),linear-gradient(90deg,#deddd7 1px,transparent 1px);background-size:25px 25px;border:1px solid #d8d7d1;border-radius:10px}.campus-map::before{content:'';position:absolute;width:130px;height:500px;left:42%;top:-70px;background:#f4f3ef;border-left:1px solid #d3d2cc;border-right:1px solid #d3d2cc;transform:rotate(27deg)}.building{position:absolute;padding:16px 18px;color:#85878e;background:#d3d2cd;border:1px solid #cac9c3;border-radius:5px;font-size:8px;letter-spacing:.06em}.building.one{left:8%;top:12%;width:30%;height:70px}.building.two{right:8%;top:17%;width:28%;height:105px}.building.three{left:13%;bottom:12%;width:35%;height:76px}.map-pin{position:absolute;width:30px;height:30px;display:grid;place-items:center;color:#fff;background:var(--brand);border:3px solid #fff;border-radius:50%;box-shadow:0 8px 18px rgba(23,31,84,.22)}.map-pin b{font-size:8px}.map-pin.p1{left:32%;top:37%}.map-pin.p2{right:23%;top:54%}.map-pin.p3{left:52%;bottom:16%}.map-pin.busy{background:#e69b2c}.map-path{position:absolute;height:3px;background:#b8b6ae;border-radius:3px;transform-origin:left}.path-a{width:160px;left:22%;top:53%;transform:rotate(18deg)}.path-b{width:120px;right:15%;bottom:28%;transform:rotate(-27deg)}
.map-key{padding:11px 2px 0;display:flex;gap:13px;color:#6e7179;font-size:8px}.map-key span{display:flex;align-items:center;gap:5px}.map-key i{width:6px;height:6px;border-radius:50%}.map-key i.available{background:var(--success)}.map-key i.busy{background:var(--warning)}.map-key small{margin-left:auto;color:#aaa}
.station-drawer{padding:26px 17px;background:#fff;border-left:1px solid #deddd8}.drawer-heading{display:flex;justify-content:space-between;align-items:center;margin-bottom:17px}.drawer-heading small{font-size:9px;font-weight:800;letter-spacing:.08em}.drawer-heading span{display:flex;gap:3px;align-items:center;color:var(--brand);font-size:7px}.drawer-heading span :deep(svg){width:9px}.station-drawer article{display:grid;grid-template-columns:7px 1fr auto;align-items:center;gap:9px;padding:15px 2px;border-top:1px solid #e9e8e4}.station-status{width:6px;height:6px;border-radius:50%}.station-status.available{background:var(--success)}.station-status.busy{background:var(--warning)}.station-drawer strong,.station-drawer small{display:block}.station-drawer strong{font-size:9px}.station-drawer small{margin-top:5px;display:flex;align-items:center;gap:3px;color:#95979e;font-size:7px}.station-drawer small :deep(svg){width:8px}.station-drawer article>b{color:var(--success);font-size:7px}.station-drawer article>b.busy-label{color:var(--warning)}.drawer-action{width:100%;margin-top:20px;padding:12px 5px;display:flex;align-items:center;justify-content:center;gap:5px;color:#fff;background:#11131a;border:0;border-radius:7px;font-size:8px;font-weight:700;cursor:pointer}.drawer-action :deep(svg){width:11px}
.workflow { width: min(1220px, calc(100% - 48px)); margin: auto; padding: 120px 0 70px; color: var(--text-primary); }.section-intro{display:grid;grid-template-columns:.65fr 1.35fr;align-items:start;margin-bottom:70px}.section-intro p{margin:8px 0 0;color:var(--brand-cyan);font-size:10px;font-weight:800;letter-spacing:.14em}.section-intro h2{margin:0;font-size:clamp(32px,4.2vw,52px);line-height:1.08;letter-spacing:.01em;font-weight:600;font-family:var(--font-display)}
.capability-list{border-top:1px solid var(--border-color)}.capability-list article{display:grid;grid-template-columns:70px 50px .8fr 1.2fr 22px;align-items:center;gap:24px;min-height:132px;border-bottom:1px solid var(--border-color);transition:background .2s,padding .2s}.capability-list article:hover{padding-inline:14px;background:rgba(0,229,255,.05)}.capability-no{font-size:10px;color:var(--text-muted)}.capability-icon{width:42px;height:42px;display:grid;place-items:center;color:var(--brand-cyan);background:var(--brand-soft);border-radius:8px}.capability-icon :deep(svg){width:20px}.capability-list h3{margin:0;font-size:21px;letter-spacing:-.03em}.capability-list p{max-width:420px;margin:0;color:var(--text-secondary);font-size:13px;line-height:1.7}.capability-arrow{width:18px;color:var(--text-muted)}
.service-band{margin-top:70px;padding:27px 0;display:grid;grid-template-columns:1fr auto 1fr;align-items:center;gap:20px;border-top:1px solid var(--border-color);border-bottom:1px solid var(--border-color)}.service-band>div{display:flex;align-items:center;gap:12px}.service-band>div>:deep(svg){width:22px;color:var(--brand-cyan)}.service-band small,.service-band strong{display:block}.service-band small{color:var(--text-muted);font-size:9px}.service-band strong{margin-top:3px;font-size:13px}.service-band>p{color:var(--text-muted);font-size:11px}.service-band :deep(.el-button){justify-self:end}
@media(max-width:1080px){.hero{grid-template-columns:1fr;padding-top:74px}.hero-copy{max-width:760px}.hero-index{margin-top:45px}.product-window{max-width:900px;margin:auto;transform:none}.dark-stage{min-height:auto}.workflow{padding-top:90px}}
@media(max-width:720px){.landing-nav,.hero,.workflow{width:calc(100% - 28px)}.landing-nav{height:68px;grid-template-columns:1fr auto}.nav-links{display:none}.nav-actions :deep(.el-button.is-text){display:none}.hero{gap:52px;padding:66px 0 80px}.hero-description{font-size:14px}.hero-actions{align-items:flex-start;flex-direction:column;gap:10px}.hero-index{flex-wrap:wrap}.product-window{border-radius:11px}.product-body{grid-template-columns:42px 1fr}.station-drawer{display:none}.map-workspace{padding:22px 15px}.map-workspace header>span{display:none}.campus-map{height:310px}.section-intro{grid-template-columns:1fr;gap:22px;margin-bottom:45px}.capability-list article{grid-template-columns:38px 42px 1fr 16px;gap:13px;padding:20px 0}.capability-list article p{grid-column:3/5}.capability-arrow{grid-column:4;grid-row:1}.service-band{grid-template-columns:1fr}.service-band>p{margin:0}.service-band :deep(.el-button){justify-self:start}}
</style>
