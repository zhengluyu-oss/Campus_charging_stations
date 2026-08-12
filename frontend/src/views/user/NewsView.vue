<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowRight, Plus, Search } from '@element-plus/icons-vue'
import { getNewsList, publishNews } from '@/api/news'

const route = useRoute()
const loading = ref(false)
const dialog = ref(false)
const keyword = ref('')
const category = ref(String(route.query.category || 'all'))
const selected = ref<any | null>(null)
const items = ref<any[]>([])

const fallback = [
  {
    id: 1,
    title: '校园充电设施服务时间调整通知',
    summary: '为进一步提升校园充电服务质量，部分区域服务时间将进行调整。',
    category: 'policy',
    date: '2026-07-12',
    content: '校园充电设施将继续优化运行安排，请师生根据页面实时状态合理规划充电时间。',
  },
  {
    id: 2,
    title: '绿色出行主题活动开始报名',
    summary: '参与校园绿色出行活动，共建低碳校园。',
    category: 'event',
    date: '2026-07-10',
    content: '本次活动面向全校师生开放，欢迎关注校园充电服务平台后续通知。',
  },
  {
    id: 3,
    title: '充电区域安全使用提示',
    summary: '请规范停放车辆，并在充电结束后及时移走。',
    category: 'policy',
    date: '2026-07-08',
    content: '连接充电设备前请检查接口状态，发现设备异常请停止使用并联系管理员。',
  },
]

const categoryKey = (item: any) => item.category || item.newsCategory || 'policy'
const categoryLabel = (item: any) => {
  const key = categoryKey(item)
  if (key === 'event') return '校园活动'
  if (key === 'lost') return '失物招领'
  return '通知政策'
}
const articleDate = (item: any) => item.date || item.publishDate || '近期'
const articleSummary = (item: any) =>
  item.summary || String(item.content || '').replace(/<[^>]+>/g, '').slice(0, 110)

const filtered = computed(() => {
  const query = keyword.value.trim().toLowerCase()
  return items.value.filter((item) => {
    const matchesCategory = category.value === 'all' || categoryKey(item) === category.value
    const matchesKeyword =
      !query || `${item.title || ''} ${articleSummary(item)}`.toLowerCase().includes(query)
    return matchesCategory && matchesKeyword
  })
})

const featured = computed(() => filtered.value[0])
const remaining = computed(() => filtered.value.slice(1))
const form = reactive({ title: '', content: '', newsCategory: 'event' })

onMounted(async () => {
  loading.value = true
  try {
    const response: any = await getNewsList()
    items.value = Array.isArray(response?.data) && response.data.length ? response.data : fallback
  } catch {
    items.value = fallback
  } finally {
    loading.value = false
  }
})

const publish = async () => {
  if (!form.title || !form.content) {
    ElMessage.warning('请填写标题和正文')
    return
  }
  try {
    await publishNews({
      title: form.title,
      content: form.content,
      categoryId: form.newsCategory === 'event' ? 1 : 2,
      imageUrl: '',
      publishDate: new Date().toISOString().slice(0, 10),
      newsCategory: form.newsCategory,
    })
    items.value.unshift({
      id: Date.now(),
      ...form,
      date: new Date().toISOString().slice(0, 10),
      summary: form.content.slice(0, 60),
      category: form.newsCategory,
    })
    dialog.value = false
    form.title = ''
    form.content = ''
    ElMessage.success('资讯发布成功')
  } catch {
    ElMessage.error('发布失败，请稍后重试')
  }
}
</script>

<template>
  <div class="news-page">
    <header class="page-header news-header">
      <div>
        <p class="eyebrow">CAMPUS JOURNAL</p>
        <h1>校园资讯</h1>
        <span>关注服务动态，也关注校园正在发生的事。</span>
      </div>
      <el-button
        v-if="route.query.mode === 'publish'"
        type="primary"
        :icon="Plus"
        @click="dialog = true"
      >
        发布资讯
      </el-button>
    </header>

    <main class="news-main">
      <section class="news-tools" aria-label="资讯筛选">
        <el-segmented
          v-model="category"
          :options="[
            { label: '全部', value: 'all' },
            { label: '校园活动', value: 'event' },
            { label: '通知政策', value: 'policy' },
            { label: '失物招领', value: 'lost' },
          ]"
        />
        <el-input
          v-model="keyword"
          :prefix-icon="Search"
          clearable
          placeholder="搜索资讯"
          aria-label="搜索校园资讯"
        />
      </section>

      <section v-loading="loading" class="editorial">
        <article v-if="featured" class="lead-story" @click="selected = featured">
          <div class="lead-art" aria-hidden="true">
            <span>{{ categoryLabel(featured) }}</span>
            <b>{{ String(filtered.length).padStart(2, '0') }}</b>
            <i />
          </div>
          <div class="lead-copy">
            <div class="story-meta">
              <span>HEADLINE</span>
              <time>{{ articleDate(featured) }}</time>
            </div>
            <h2>{{ featured.title }}</h2>
            <p>{{ articleSummary(featured) }}</p>
            <button type="button">
              阅读全文
              <el-icon><ArrowRight /></el-icon>
            </button>
          </div>
        </article>

        <div v-if="remaining.length" class="story-list">
          <article v-for="(item, index) in remaining" :key="item.id ?? index" @click="selected = item">
            <div class="story-number">{{ String(index + 2).padStart(2, '0') }}</div>
            <div class="story-body">
              <div class="story-meta">
                <span>{{ categoryLabel(item) }}</span>
                <time>{{ articleDate(item) }}</time>
              </div>
              <h3>{{ item.title }}</h3>
              <p>{{ articleSummary(item) }}</p>
            </div>
            <el-icon class="story-arrow"><ArrowRight /></el-icon>
          </article>
        </div>

        <div v-if="!loading && !filtered.length" class="empty-state">
          <span>NO STORIES</span>
          <h2>暂无相关资讯</h2>
          <p>调整分类或搜索关键词，再试一次。</p>
        </div>
      </section>
    </main>

    <el-dialog v-model="selected" :title="selected?.title" width="650px">
      <div class="article-meta">{{ selected ? categoryLabel(selected) : '' }} · {{ selected ? articleDate(selected) : '' }}</div>
      <div class="article-content">{{ selected?.content || selected?.summary }}</div>
    </el-dialog>

    <el-dialog v-model="dialog" title="发布校园资讯" width="580px">
      <el-form label-position="top">
        <el-form-item label="资讯标题"><el-input v-model="form.title" /></el-form-item>
        <el-form-item label="分类">
          <el-select v-model="form.newsCategory">
            <el-option label="校园活动" value="event" />
            <el-option label="通知政策" value="policy" />
            <el-option label="失物招领" value="lost" />
          </el-select>
        </el-form-item>
        <el-form-item label="正文">
          <el-input v-model="form.content" type="textarea" :rows="8" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialog = false">取消</el-button>
        <el-button type="primary" @click="publish">确认发布</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.news-page {
  min-height: calc(100vh - 72px);
  padding-bottom: 80px;
  background: var(--surface-muted);
}

.news-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 32px;
  padding-top: 56px !important;
  padding-bottom: 38px !important;
}

.eyebrow,
.news-header h1,
.news-header span {
  margin: 0;
}

.eyebrow {
  margin-bottom: 12px;
  color: var(--brand);
  font-size: 11px;
  font-weight: 800;
  letter-spacing: .18em;
}

.news-header h1 {
  margin-bottom: 12px;
  font-size: clamp(42px, 6vw, 68px);
  font-weight: 720;
  letter-spacing: -.065em;
}

.news-header span {
  color: var(--text-secondary);
  font-size: 14px;
}

.news-tools {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 22px;
  padding: 14px 0;
  border-top: 1px solid var(--text-primary);
  border-bottom: 1px solid var(--border-color);
}

.news-tools .el-input {
  width: 260px;
}

.news-tools :deep(.el-segmented) {
  max-width: 100%;
  padding: 0;
  overflow-x: auto;
  background: transparent;
  border-radius: 0;
}

.news-tools :deep(.el-segmented__item) {
  min-height: 38px;
  border-radius: 0;
}

.editorial {
  min-height: 280px;
}

.lead-story {
  display: grid;
  grid-template-columns: minmax(280px, 1fr) 1.35fr;
  min-height: 430px;
  border-bottom: 1px solid var(--text-primary);
  cursor: pointer;
}

.lead-art {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 430px;
  padding: 32px;
  overflow: hidden;
  color: #fff;
  background: var(--text-primary);
}

.lead-art::before,
.lead-art::after {
  position: absolute;
  content: '';
}

.lead-art::before {
  top: 50%;
  right: -18%;
  width: 72%;
  aspect-ratio: 1;
  border: 1px solid rgba(255, 255, 255, .22);
  border-radius: 50%;
  transform: translateY(-50%);
}

.lead-art::after {
  right: 14%;
  bottom: -20%;
  width: 56%;
  aspect-ratio: 1;
  background: var(--brand);
  border-radius: 50%;
  opacity: .9;
  filter: blur(1px);
}

.lead-art span,
.lead-art b,
.lead-art i {
  position: relative;
  z-index: 1;
}

.lead-art span {
  width: fit-content;
  padding-bottom: 8px;
  border-bottom: 1px solid currentColor;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: .12em;
}

.lead-art b {
  font-size: clamp(92px, 13vw, 170px);
  font-weight: 650;
  line-height: .72;
  letter-spacing: -.09em;
}

.lead-art i {
  position: absolute;
  top: 32px;
  right: 32px;
  width: 10px;
  height: 10px;
  background: var(--brand);
  border-radius: 50%;
}

.lead-copy {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: clamp(34px, 6vw, 76px);
  background: var(--surface);
}

.story-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  color: var(--text-muted);
  font-size: 10px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  letter-spacing: .1em;
}

.story-meta span {
  color: var(--brand);
}

.lead-copy h2 {
  max-width: 670px;
  margin: 28px 0 20px;
  font-size: clamp(30px, 4.2vw, 52px);
  line-height: 1.14;
  letter-spacing: -.055em;
}

.lead-copy p {
  max-width: 620px;
  margin: 0;
  color: var(--text-secondary);
  font-size: 14px;
  line-height: 1.85;
}

.lead-copy button {
  display: inline-flex;
  align-items: center;
  align-self: flex-start;
  gap: 12px;
  margin-top: 34px;
  padding: 0 0 8px;
  color: var(--text-primary);
  background: transparent;
  border: 0;
  border-bottom: 1px solid currentColor;
  cursor: pointer;
  font-weight: 700;
}

.story-list article {
  display: grid;
  grid-template-columns: 72px 1fr 36px;
  gap: 26px;
  align-items: center;
  min-height: 158px;
  padding: 28px 10px 28px 0;
  border-bottom: 1px solid var(--border-color);
  cursor: pointer;
  transition: background-color .18s ease, padding .18s ease;
}

.story-list article:hover {
  padding-left: 12px;
  background: var(--surface);
}

.story-number {
  color: var(--text-muted);
  font-size: 12px;
  font-variant-numeric: tabular-nums;
}

.story-body h3,
.story-body p {
  margin: 0;
}

.story-body h3 {
  margin: 12px 0 8px;
  font-size: 22px;
  line-height: 1.35;
  letter-spacing: -.025em;
}

.story-body p {
  max-width: 800px;
  color: var(--text-secondary);
  font-size: 12px;
  line-height: 1.7;
}

.story-arrow {
  color: var(--text-muted);
  font-size: 20px;
}

.empty-state {
  padding: 96px 20px;
  text-align: center;
  border-bottom: 1px solid var(--border-color);
}

.empty-state span,
.article-meta {
  color: var(--brand);
  font-size: 10px;
  font-weight: 750;
  letter-spacing: .12em;
}

.empty-state h2 {
  margin: 14px 0 8px;
}

.empty-state p {
  margin: 0;
  color: var(--text-muted);
}

.article-meta {
  margin-bottom: 22px;
}

.article-content {
  color: var(--text-secondary);
  font-size: 15px;
  line-height: 2;
}

@media (max-width: 820px) {
  .lead-story {
    grid-template-columns: 1fr;
  }

  .lead-art {
    min-height: 260px;
  }
}

@media (max-width: 620px) {
  .news-header,
  .news-tools {
    align-items: stretch;
    flex-direction: column;
  }

  .news-header {
    padding-top: 36px !important;
  }

  .news-tools .el-input {
    width: 100%;
  }

  .lead-art {
    min-height: 220px;
    padding: 24px;
  }

  .lead-copy {
    padding: 32px 22px 38px;
  }

  .story-list article {
    grid-template-columns: 34px 1fr 24px;
    gap: 12px;
  }

  .story-body h3 {
    font-size: 18px;
  }
}
</style>
