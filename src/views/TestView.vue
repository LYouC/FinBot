<template>
  <n-layout position="absolute">
    <n-layout-header bordered style="height: 48px">
      <n-flex justify="space-between">
        <n-button
          style="height: 48px; margin-left: 10px"
          v-if="layoutStore.isMobile"
          text
          @click="handleMenuClick"
          class="menu-trigger"
        >
          <n-icon size="30">
            <menu-outline />
          </n-icon>
        </n-button>
        <n-button
          style="height: 48px; margin-left: 10px; font-size: 36px"
          v-else
          text
          @click="handleMenuClick"
          class="menu-trigger"
        >
          GISO
        </n-button>
        <n-button
          style="height: 48px; margin-right: 10px"
          text
          @click="router.push('/search')"
          class="search-button"
        >
          <n-icon size="30">
            <search-outline />
          </n-icon>
        </n-button>
      </n-flex>
    </n-layout-header>
    <n-layout has-sider position="absolute" style="top: 48px">
      <side-nav ref="sideNavRef" @update:theme="handleThemeChange" />
      <n-layout-content :native-scrollbar="false" class="main-content">
        <n-page-header subtitle="欢迎使用后台管理系统">
          <template #title>
            <n-gradient-text type="info"> 后台管理系统 </n-gradient-text>
          </template>
        </n-page-header>

        <n-space vertical size="large" style="margin-top: 20px">
          <n-card title="数据概览" size="small">
            <n-grid :cols="4" :x-gap="12">
              <n-gi>
                <n-statistic label="总用户数" value="1,234" />
              </n-gi>
              <n-gi>
                <n-statistic label="活跃用户" value="890" />
              </n-gi>
              <n-gi>
                <n-statistic label="总订单数" value="3,456" />
              </n-gi>
              <n-gi>
                <n-statistic label="今日订单" value="123" />
              </n-gi>
            </n-grid>
          </n-card>

          <n-card title="最近活动" size="small">
            <n-list>
              <n-list-item v-for="i in 3" :key="i">
                <n-thing title="系统通知" content="这是一条系统通知消息..." />
              </n-list-item>
            </n-list>
          </n-card>

          <n-card title="近期记录" size="small">
            <template #header-extra>
              <n-button text @click="toggleSelectMode">
                {{ isSelectMode ? '完成' : '选择' }}
              </n-button>
            </template>

            <n-space vertical>
              <record-card
                v-for="record in records"
                :key="record.id"
                :record="record"
                :selectable="isSelectMode"
                v-model:selected="record.selected"
                @click="handleRecordClick(record)"
              />
            </n-space>
          </n-card>
        </n-space>
      </n-layout-content>
    </n-layout>
  </n-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { MenuOutline, SearchOutline } from '@vicons/ionicons5'
import { type GlobalTheme } from 'naive-ui'
import SideNav from '@/components/SideNav.vue'
import { useLayoutStore } from '@/stores/layout'
import { useRouter } from 'vue-router'
import RecordCard from '@/components/RecordCard.vue'
import { NIcon } from 'naive-ui'

const layoutStore = useLayoutStore()
const sideNavRef = ref()
const router = useRouter()

const emit = defineEmits(['update:theme'])

function handleMenuClick() {
  sideNavRef.value?.toggleMobileMenu()
}

function handleThemeChange(newTheme: GlobalTheme | null) {
  emit('update:theme', newTheme)
}

// 选择模式状态
const isSelectMode = ref(false)

interface Record {
  id: number
  date: Date
  summary: string
  details: string
  amount: number
  selected: boolean
}

// 模拟记录数据
const records = ref<Record[]>([
  {
    id: 1,
    date: new Date(),
    summary: '午餐',
    details: '公司附近的快餐店',
    amount: -25,
    selected: false,
  },
  {
    id: 2,
    date: new Date(Date.now() - 3600000),
    summary: '工资',
    details: '8月份工资',
    amount: 8000,
    selected: false,
  },
  {
    id: 3,
    date: new Date(Date.now() - 7200000),
    summary: '购物',
    details: '超市日用品',
    amount: -199.5,
    selected: false,
  },
])

// 切换选择模式
function toggleSelectMode() {
  records.value.forEach((record) => console.log(record.selected))
  isSelectMode.value = !isSelectMode.value
  if (!isSelectMode.value) {
    // 退出选择模式时清除所有选择
    records.value.forEach((record) => (record.selected = false))
  }
}

// 处理记录点击
function handleRecordClick(record: Record) {
  console.log('点击记录:', record)
}
</script>

<style scoped>
.main-content {
  padding: 8px;
  transition: margin-left 0.5s ease;
}

.left-section {
  display: flex;
  align-items: center;
}

.right-section {
  margin-left: auto;
}

.menu-trigger {
  margin-right: 8px;
}

.content-card {
  margin-top: 16px;
}

/* 响应式布局 */
@media (max-width: 639px) {
  .main-content {
    margin-left: 0;
  }
}

@media (min-width: 640px) {
  .main-content {
    margin-left: 12px;
    margin-right: 8px;
  }
}

@media (min-width: 1024px) {
  .n-layout-sider:not(.n-layout-sider--collapsed) + .main-content {
    margin-left: 16px;
    margin-right: 12px;
  }
}

.search-button {
  padding: 4px;
}
</style>
