<template>
  <div class="news-page">
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

    <header class="page-header">
      <div class="header-content">
        <div class="header-left">
          <h1>{{ getPageTitle }}</h1>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ getPageTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-button v-if="isPublishMode" type="primary" @click="openPublishDialog">
            <el-icon><Plus /></el-icon>
            发布资讯
          </el-button>
          <el-button @click="goBack">
            <el-icon><Back /></el-icon>
            返回首页
          </el-button>
        </div>
      </div>
    </header>

    <main class="news-main">
      <div class="news-nav" v-if="isPublishMode || !currentCategory">
        <el-tabs v-model="activeCategory" class="news-tabs">
          <el-tab-pane label="校园活动" name="event">
            <div class="tab-content">
              <div class="news-list">
                <el-card 
                  v-for="news in filteredNews" 
                  :key="news.id" 
                  class="news-card" 
                  shadow="hover"
                  @click="selectNews(news)"
                >
                  <div class="news-card-content">
                    <div class="news-image" v-if="news.image">
                      <img :src="news.image" :alt="news.title" />
                    </div>
                    <div class="news-info">
                      <h3 class="news-title">{{ news.title }}</h3>
                      <p class="news-summary">{{ news.summary }}</p>
                      <div class="news-meta">
                        <span class="news-category">{{ getCategoryName(news.category) }}</span>
                        <span class="news-date">{{ formatDate(news.date) }}</span>
                      </div>
                    </div>
                  </div>
                </el-card>

                <div v-if="filteredNews.length === 0" class="no-news">
                  <el-empty description="暂无新闻" />
                </div>
              </div>

              <div class="news-pagination">
                <el-pagination
                  v-model:current-page="currentPage"
                  v-model:page-size="pageSize"
                  :page-sizes="[10, 20, 50]"
                  layout="total, sizes, prev, pager, next, jumper"
                  :total="filteredNews.length"
                  @size-change="handleSizeChange"
                  @current-change="handleCurrentChange"
                />
              </div>
            </div>
          </el-tab-pane>
          <el-tab-pane label="政策法规" name="policy">
            <div class="tab-content">
              <div class="news-list">
                <el-card 
                  v-for="news in filteredNews" 
                  :key="news.id" 
                  class="news-card" 
                  shadow="hover"
                  @click="selectNews(news)"
                >
                  <div class="news-card-content">
                    <div class="news-image" v-if="news.image">
                      <img :src="news.image" :alt="news.title" />
                    </div>
                    <div class="news-info">
                      <h3 class="news-title">{{ news.title }}</h3>
                      <p class="news-summary">{{ news.summary }}</p>
                      <div class="news-meta">
                        <span class="news-category">{{ getCategoryName(news.category) }}</span>
                        <span class="news-date">{{ formatDate(news.date) }}</span>
                      </div>
                    </div>
                  </div>
                </el-card>

                <div v-if="filteredNews.length === 0" class="no-news">
                  <el-empty description="暂无新闻" />
                </div>
              </div>

              <div class="news-pagination">
                <el-pagination
                  v-model:current-page="currentPage"
                  v-model:page-size="pageSize"
                  :page-sizes="[10, 20, 50]"
                  layout="total, sizes, prev, pager, next, jumper"
                  :total="filteredNews.length"
                  @size-change="handleSizeChange"
                  @current-change="handleCurrentChange"
                />
              </div>
            </div>
          </el-tab-pane>
          <el-tab-pane label="失物广播" name="lost">
            <div class="tab-content">
              <div class="news-list">
                <el-card 
                  v-for="news in filteredNews" 
                  :key="news.id" 
                  class="news-card" 
                  shadow="hover"
                  @click="selectNews(news)"
                >
                  <div class="news-card-content">
                    <div class="news-image" v-if="news.image">
                      <img :src="news.image" :alt="news.title" />
                    </div>
                    <div class="news-info">
                      <h3 class="news-title">{{ news.title }}</h3>
                      <p class="news-summary">{{ news.summary }}</p>
                      <div class="news-meta">
                        <span class="news-category">{{ getCategoryName(news.category) }}</span>
                        <span class="news-date">{{ formatDate(news.date) }}</span>
                      </div>
                    </div>
                  </div>
                </el-card>

                <div v-if="filteredNews.length === 0" class="no-news">
                  <el-empty description="暂无失物信息" />
                </div>
              </div>

              <div class="news-pagination">
                <el-pagination
                  v-model:current-page="currentPage"
                  v-model:page-size="pageSize"
                  :page-sizes="[10, 20, 50]"
                  layout="total, sizes, prev, pager, next, jumper"
                  :total="filteredNews.length"
                  @size-change="handleSizeChange"
                  @current-change="handleCurrentChange"
                />
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>

      <div class="category-news" v-if="!isPublishMode && currentCategory">
        <div class="news-list">
          <el-card 
            v-for="news in filteredNews" 
            :key="news.id" 
            class="news-card" 
            shadow="hover"
            @click="selectNews(news)"
          >
            <div class="news-card-content">
              <div class="news-image" v-if="news.image">
                <img :src="news.image" :alt="news.title" />
              </div>
              <div class="news-info">
                <h3 class="news-title">{{ news.title }}</h3>
                <p class="news-summary">{{ news.summary }}</p>
                <div class="news-meta">
                  <span class="news-category">{{ getCategoryName(news.category) }}</span>
                  <span class="news-date">{{ formatDate(news.date) }}</span>
                </div>
              </div>
            </div>
          </el-card>

          <div v-if="filteredNews.length === 0" class="no-news">
            <el-empty description="暂无新闻" />
          </div>
        </div>

        <div class="news-pagination">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next, jumper"
            :total="filteredNews.length"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
      </div>

      <el-dialog
        v-model="dialogVisible"
        :title="selectedNews?.title || '新闻详情'"
        width="80%"
        :before-close="handleClose"
        class="news-dialog"
      >
        <div v-if="selectedNews" class="news-detail">
          <div class="news-detail-header">
            <h3>{{ selectedNews.title }}</h3>
            <div class="news-detail-meta">
              <span class="news-detail-category">{{ getCategoryName(selectedNews.category) }}</span>
              <span class="news-detail-date">{{ formatDate(selectedNews.date) }}</span>
            </div>
          </div>
          <div class="news-detail-content" v-html="sanitizeHtml(selectedNews.content)"></div>
        </div>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="dialogVisible = false">关闭</el-button>
          </span>
        </template>
      </el-dialog>

      <el-dialog
        v-model="publishDialogVisible"
        title="发布资讯"
        width="600px"
        class="publish-dialog"
      >
        <el-form :model="publishForm" label-width="100px" :rules="publishRules" ref="publishFormRef">
          <el-form-item label="标题" prop="title">
            <el-input v-model="publishForm.title" placeholder="请输入资讯标题" maxlength="100" show-word-limit />
          </el-form-item>
          <el-form-item label="内容" prop="content">
            <el-input 
              v-model="publishForm.content" 
              type="textarea" 
              :rows="6" 
              placeholder="请输入资讯内容"
              maxlength="2000"
              show-word-limit
            />
          </el-form-item>
          <el-form-item label="分类" prop="categoryId">
            <el-select v-model="publishForm.categoryId" placeholder="请选择分类" style="width: 100%">
              <el-option label="校园活动" :value="1" />
              <el-option label="政策法规" :value="2" />
              <el-option label="失物广播" :value="3" />
            </el-select>
          </el-form-item>
          <el-form-item label="资讯分类" prop="newsCategory">
            <el-input v-model="publishForm.newsCategory" placeholder="请输入资讯分类" />
          </el-form-item>
          <el-form-item label="发布日期" prop="publishDate">
            <el-date-picker
              v-model="publishForm.publishDate"
              type="date"
              placeholder="选择日期"
              style="width: 100%"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
            />
          </el-form-item>
          <el-form-item label="图片" prop="imageUrl">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :show-file-list="false"
              :on-success="handleUploadSuccess"
              :before-upload="beforeUpload"
              :headers="uploadHeaders"
            >
              <img v-if="publishForm.imageUrl" :src="publishForm.imageUrl" class="avatar" />
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
            <div class="upload-tip">支持 jpg、png 格式，大小不超过 2MB</div>
          </el-form-item>
        </el-form>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="publishDialogVisible = false">取消</el-button>
            <el-button type="primary" @click="handlePublish" :loading="publishLoading">发布</el-button>
          </span>
        </template>
      </el-dialog>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import { Plus, Back } from '@element-plus/icons-vue';
import type { FormInstance, FormRules, UploadProps } from 'element-plus';
import { publishNews } from '@/apis/news';
import { useUserStore } from '@/stores/user';
import DOMPurify from 'dompurify';

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();

// XSS 防护：净化 HTML 内容
const sanitizeHtml = (html: string) => DOMPurify.sanitize(html);

// 预计算粒子位置，避免模板中 Math.random() 导致重渲染跳动
const particles = Array.from({ length: 30 }, () => ({
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 5}s`,
  size: `${Math.random() * 8 + 2}px`
}));

const isPublishMode = ref(false);
const currentCategory = ref('');

onMounted(() => {
  const mode = route.query.mode as string;
  const category = route.query.category as string;
  isPublishMode.value = mode === 'publish';
  currentCategory.value = category || '';
  if (category) {
    activeCategory.value = category;
  }
});

// 新闻数据
const newsList = ref([
  {
    id: 1,
    title: '校园充电站新增100个快充桩',
    summary: '为满足日益增长的电动车充电需求，学校在多个校区新增了100个快充桩，支持快速充电技术。',
    content: '<p>为满足日益增长的电动车充电需求，学校在多个校区新增了100个快充桩，支持快速充电技术。这些充电桩分布在学生宿舍区、教学区和停车场等多个区域，方便师生使用。</p><p>新安装的充电桩采用了最新的快充技术，充电速度比传统充电桩提高了3倍，大大减少了充电等待时间。同时，充电桩支持智能预约功能，师生可以通过APP提前预约充电时间，避免排队等待。</p><p>学校相关负责人表示，此次充电桩的扩建是学校绿色校园建设的重要举措，旨在鼓励师生使用新能源交通工具，减少碳排放，为环保事业做出贡献。</p>',
    category: 'event',
    date: '2026-03-15',
    image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=campus%20electric%20vehicle%20charging%20station%20with%20modern%20design&image_size=landscape_4_3'
  },
  {
    id: 2,
    title: '校园充电APP全新升级',
    summary: '校园充电APP进行了重大升级，新增了多种功能，提升了用户体验。',
    content: '<p>校园充电APP进行了重大升级，新增了多种功能，提升了用户体验。新版本APP增加了实时充电桩状态查询、智能预约、充电记录管理等功能，方便师生随时了解充电桩使用情况。</p><p>此外，APP还新增了充电费用查询和支付功能，师生可以通过APP直接查看充电费用并进行在线支付，无需现金交易。同时，APP还增加了积分系统，用户通过充电可以获得积分，积分可以兑换校园周边产品和服务。</p><p>为了提升用户体验，APP还优化了界面设计，采用了更加简洁美观的界面，操作更加直观便捷。学校相关负责人表示，此次APP升级是为了更好地服务师生，提高校园充电服务的质量和效率。</p>',
    category: 'event',
    date: '2026-02-28',
    image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20for%20campus%20charging%20station%20with%20modern%20interface&image_size=landscape_4_3'
  },
  {
    id: 3,
    title: '国家新能源汽车充电基础设施建设规划发布',
    summary: '国家发改委发布最新规划，到2030年将建成覆盖全国的充电基础设施网络。',
    content: '<p>国家发改委发布最新规划，到2030年将建成覆盖全国的充电基础设施网络。根据规划，到2030年，全国将建设超过1000万个充电桩，其中公共充电桩达到200万个，满足超过2000万辆电动汽车的充电需求。</p><p>规划提出，要加快推进充电基础设施建设，重点在城市公共区域、高速公路服务区、居民小区等场所建设充电桩。同时，要加强充电基础设施的互联互通，实现不同运营商之间的充电服务兼容。</p><p>此外，规划还强调要提高充电基础设施的智能化水平，推广智能充电、有序充电等技术，提高充电效率和电网稳定性。对于校园充电基础设施建设，规划也提出了明确要求，鼓励高校建设智能充电示范区。</p>',
    category: 'policy',
    date: '2026-03-05',
    image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=national%20electric%20vehicle%20charging%20infrastructure%20plan&image_size=landscape_4_3'
  },
  {
    id: 4,
    title: '新能源汽车充电安全管理规定出台',
    summary: '教育部出台校园新能源汽车充电安全管理规定，规范校园充电行为。',
    content: '<p>教育部出台校园新能源汽车充电安全管理规定，规范校园充电行为。规定要求各高校建立健全充电安全管理制度，加强对充电桩的日常维护和检查，确保充电设施的安全运行。</p><p>规定明确了师生在使用充电桩时的安全责任，要求用户遵守充电操作规程，不得违规充电。同时，规定还要求高校加强对师生的充电安全知识宣传和教育，提高安全意识。</p><p>此外，规定还对充电桩的安装、使用和管理等方面做出了详细规定，为高校校园充电设施的安全运行提供了制度保障。</p>',
    category: 'policy',
    date: '2026-02-15',
    image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=campus%20electric%20vehicle%20charging%20safety%20regulations&image_size=landscape_4_3'
  },
  {
    id: 5,
    title: '失物招领：在充电桩旁捡到钱包',
    summary: '有同学在校园东区充电桩旁捡到一个黑色钱包，内有身份证和银行卡等物品。',
    content: '<p>有同学在校园东区充电桩旁捡到一个黑色钱包，内有身份证和银行卡等物品。失主可凭有效证件到校园服务中心领取。</p><p>钱包特征：黑色皮质，内有身份证（姓名：张三）、银行卡3张、现金若干。</p><p>领取地点：校园服务中心（行政楼1楼）</p><p>联系电话：12345678900</p><p>领取时间：工作日 8:00-17:00</p>',
    category: 'lost',
    date: '2026-03-16',
    image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lost%20and%20found%20notice%20on%20campus&image_size=landscape_4_3'
  },
  {
    id: 6,
    title: '失物招领：充电桩附近捡到钥匙串',
    summary: '有同学在校园西区充电桩附近捡到一串钥匙，上面有电动车钥匙和宿舍钥匙。',
    content: '<p>有同学在校园西区充电桩附近捡到一串钥匙，上面有电动车钥匙和宿舍钥匙。失主可凭有效证件到校园服务中心领取。</p><p>钥匙特征：银色钥匙串，包含电动车钥匙1把、宿舍钥匙2把、门禁卡1张。</p><p>领取地点：校园服务中心（行政楼1楼）</p><p>联系电话：12345678900</p><p>领取时间：工作日 8:00-17:00</p>',
    category: 'lost',
    date: '2026-03-14',
    image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lost%20keys%20found%20on%20campus&image_size=landscape_4_3'
  }
]);

// 状态管理
const activeCategory = ref('event');
const currentPage = ref(1);
const pageSize = ref(10);
const dialogVisible = ref(false);
const selectedNews = ref<any>(null);

// 筛选新闻
const filteredNews = computed(() => {
  if (currentCategory.value) {
    return newsList.value.filter(news => news.category === currentCategory.value);
  }
  return newsList.value.filter(news => news.category === activeCategory.value);
});

const getPageTitle = computed(() => {
  if (isPublishMode.value) {
    return '发布资讯';
  }
  const categoryNames: Record<string, string> = {
    'event': '校园活动',
    'policy': '政策法规',
    'lost': '失物广播'
  };
  return categoryNames[currentCategory.value] || '充电新闻';
});

// 分页处理
const handleSizeChange = (size: number) => {
  pageSize.value = size;
  currentPage.value = 1;
};

const handleCurrentChange = (current: number) => {
  currentPage.value = current;
};

// 选择新闻
const selectNews = (news: any) => {
  selectedNews.value = news;
  dialogVisible.value = true;
};

// 关闭对话框
const handleClose = () => {
  dialogVisible.value = false;
  selectedNews.value = null;
};

// 获取分类名称
const getCategoryName = (category: string) => {
  const categoryMap: Record<string, string> = {
    'policy': '政策法规',
    'event': '校园活动',
    'lost': '失物广播'
  };
  return categoryMap[category] || category;
};

// 格式化日期
const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  });
};

const goBack = () => {
  router.push('/user-dashboard');
};

const publishDialogVisible = ref(false);
const publishLoading = ref(false);
const publishFormRef = ref<FormInstance>();

const publishForm = ref({
  title: '',
  content: '',
  categoryId: 1,
  imageUrl: '',
  publishDate: new Date().toISOString().split('T')[0],
  newsCategory: ''
});

const publishRules: FormRules = {
  title: [{ required: true, message: '请输入资讯标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入资讯内容', trigger: 'blur' }],
  categoryId: [{ required: true, message: '请选择分类', trigger: 'change' }],
  newsCategory: [{ required: true, message: '请输入资讯分类', trigger: 'blur' }],
  publishDate: [{ required: true, message: '请选择发布日期', trigger: 'change' }]
};

const uploadUrl = '/upload/image';
const uploadHeaders = {
  token: userStore.getToken || ''
};

const openPublishDialog = () => {
  publishForm.value = {
    title: '',
    content: '',
    categoryId: 1,
    imageUrl: '',
    publishDate: new Date().toISOString().split('T')[0],
    newsCategory: ''
  };
  publishDialogVisible.value = true;
};

const beforeUpload: UploadProps['beforeUpload'] = (rawFile) => {
  const isJPG = rawFile.type === 'image/jpeg' || rawFile.type === 'image/png';
  const isLt2M = rawFile.size / 1024 / 1024 < 2;

  if (!isJPG) {
    ElMessage.error('图片只能是 JPG/PNG 格式!');
    return false;
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!');
    return false;
  }
  return true;
};

const handleUploadSuccess: UploadProps['onSuccess'] = (response) => {
  if (response && response.data) {
    publishForm.value.imageUrl = response.data;
    ElMessage.success('图片上传成功');
  } else {
    ElMessage.error('图片上传失败');
  }
};

const handlePublish = async () => {
  if (!publishFormRef.value) return;
  
  await publishFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        publishLoading.value = true;
        const response = await publishNews(publishForm.value);
        
        if (response.data) {
          ElMessage.success('资讯发布成功');
          publishDialogVisible.value = false;
        } else {
          ElMessage.error('资讯发布失败');
        }
      } catch (error) {
        console.error('发布资讯失败:', error);
        ElMessage.error('发布资讯失败，请稍后重试');
      } finally {
        publishLoading.value = false;
      }
    }
  });
};
</script>

<style scoped>
.news-page {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  margin: 0;
  padding: 0;
  padding-bottom: 40px;
  padding-top: 20px;
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
    opacity: 0.5;
  }
  90% {
    opacity: 0.5;
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
  background: radial-gradient(circle at center, transparent 0%, rgba(0, 0, 0, 0.7) 100%);
  z-index: 2;
}

.page-header {
  margin-bottom: 30px;
  padding: 0 20px;
  z-index: 1;
  position: relative;
  width: 100%;
  box-sizing: border-box;
}

.page-header h1 {
  margin: 0 0 15px 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  background: linear-gradient(45deg, #ffffff, #a0d2eb);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.news-main {
  padding: 0 20px;
  z-index: 1;
  position: relative;
}

.news-nav {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.news-tabs {
  background: transparent;
}

:deep(.el-tabs__header) {
  background: rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin: 0;
}

:deep(.el-tabs__nav-wrap) {
  padding: 0 20px;
}

:deep(.el-tabs__item) {
  color: rgba(255, 255, 255, 0.7) !important;
  font-size: 15px;
  padding: 0 25px;
  height: 50px;
  line-height: 50px;
}

:deep(.el-tabs__item:hover) {
  color: #ffffff !important;
}

:deep(.el-tabs__item.is-active) {
  color: #ffffff !important;
  font-weight: 600;
}

:deep(.el-tabs__active-bar) {
  background: linear-gradient(90deg, #4facfe, #00f2fe);
}

:deep(.el-tabs__content) {
  padding: 0;
}

.tab-content {
  padding: 20px;
}

.news-list {
  margin-bottom: 20px;
}

.news-card {
  margin-bottom: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.1) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 12px;
}

.news-card:hover {
  transform: translateY(-2px);
  background: rgba(255, 255, 255, 0.15) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

:deep(.el-card__body) {
  padding: 20px;
}

.news-card-content {
  display: flex;
  gap: 20px;
}

.news-image {
  width: 200px;
  height: 120px;
  flex-shrink: 0;
  overflow: hidden;
  border-radius: 8px;
}

.news-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.news-card:hover .news-image img {
  transform: scale(1.05);
}

.news-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.news-title {
  margin: 0 0 8px 0;
  color: #ffffff;
  font-size: 16px;
  font-weight: 500;
  line-height: 1.4;
}

.news-summary {
  margin: 0 0 12px 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.news-meta {
  display: flex;
  gap: 16px;
  margin-top: auto;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.news-category {
  padding: 2px 10px;
  background: rgba(79, 172, 254, 0.3);
  color: #4facfe;
  border-radius: 10px;
}

.news-date {
  color: rgba(255, 255, 255, 0.6);
}

.no-news {
  padding: 60px 0;
  text-align: center;
}

:deep(.el-empty__description) {
  color: rgba(255, 255, 255, 0.6);
}

.news-pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  padding: 20px 0;
}

.category-news {
  padding: 20px;
}

.category-news .news-list {
  margin-bottom: 20px;
}

.category-news .news-card {
  margin-bottom: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.1) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 12px;
}

.category-news .news-card:hover {
  transform: translateY(-2px);
  background: rgba(255, 255, 255, 0.15) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.category-news .news-card-content {
  display: flex;
  gap: 20px;
}

.category-news .news-image {
  width: 200px;
  height: 120px;
  flex-shrink: 0;
  overflow: hidden;
  border-radius: 8px;
}

.category-news .news-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.category-news .news-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.category-news .news-title {
  font-size: 18px;
  font-weight: 600;
  color: #ffffff;
  margin-bottom: 8px;
}

.category-news .news-summary {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.category-news .news-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12px;
}

.category-news .news-category {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: #ffffff;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
}

.category-news .news-date {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

:deep(.el-pagination) {
  --el-pagination-bg-color: rgba(255, 255, 255, 0.1);
  --el-pagination-text-color: rgba(255, 255, 255, 0.8);
  --el-pagination-button-bg-color: rgba(255, 255, 255, 0.1);
  --el-pagination-button-color: #ffffff;
  --el-pagination-hover-color: #4facfe;
}

.news-detail {
  padding: 10px 0;
}

.news-detail-header {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.news-detail-header h3 {
  margin: 0 0 10px 0;
  color: #ffffff;
  font-size: 20px;
  font-weight: 600;
}

.news-detail-meta {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

.news-detail-category {
  padding: 2px 10px;
  background: rgba(79, 172, 254, 0.3);
  color: #4facfe;
  border-radius: 10px;
}

.news-detail-content {
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.8;
  font-size: 15px;
}

.news-detail-content p {
  margin: 0 0 15px 0;
}

:deep(.el-dialog) {
  background: rgba(15, 32, 39, 0.95) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
}

:deep(.el-dialog__header) {
  background: rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 20px;
}

:deep(.el-dialog__title) {
  color: #ffffff !important;
  font-weight: 600;
}

:deep(.el-dialog__body) {
  color: rgba(255, 255, 255, 0.9);
  padding: 20px;
}

:deep(.el-dialog__footer) {
  background: rgba(255, 255, 255, 0.05);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 20px;
}

:deep(.el-button) {
  background: rgba(79, 172, 254, 0.3);
  border-color: rgba(79, 172, 254, 0.5);
  color: #ffffff;
}

:deep(.el-button:hover) {
  background: rgba(79, 172, 254, 0.5);
  border-color: rgba(79, 172, 254, 0.7);
}

@media (max-width: 768px) {
  .news-page {
    padding: 0;
  }

  .news-card-content {
    flex-direction: column;
  }

  .news-image {
    width: 100%;
    height: 180px;
  }

  .page-header h1 {
    font-size: 20px;
  }

  .news-detail-header h3 {
    font-size: 18px;
  }
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.header-right {
  display: flex;
  gap: 10px;
}

.publish-dialog :deep(.el-dialog) {
  background: rgba(15, 32, 39, 0.95) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.publish-dialog :deep(.el-form-item__label) {
  color: rgba(255, 255, 255, 0.9);
}

.publish-dialog :deep(.el-input__wrapper),
.publish-dialog :deep(.el-textarea__inner) {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #ffffff;
}

.publish-dialog :deep(.el-input__inner),
.publish-dialog :deep(.el-textarea__inner) {
  color: #ffffff;
}

.publish-dialog :deep(.el-select .el-input__wrapper) {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.avatar-uploader {
  border: 1px dashed rgba(255, 255, 255, 0.3);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s;
  width: 178px;
  height: 178px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-uploader:hover {
  border-color: #409eff;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: rgba(255, 255, 255, 0.6);
  width: 178px;
  height: 178px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
  object-fit: cover;
}

.upload-tip {
  margin-top: 8px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}
</style>