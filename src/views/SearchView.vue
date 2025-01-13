<template>
  <n-layout position="absolute">
    <div class="search-page">
      <!-- 顶部导航栏 -->
      <div class="top-bar">
        <n-button text @click="router.back()" class="back-button">
          <n-icon size="24">
            <arrow-back-outline />
          </n-icon>
        </n-button>
        <n-input-group class="search-input">
          <n-input v-model:value="searchQuery" placeholder="搜索..." @keyup.enter="handleSearch">
            <template #prefix>
              <n-icon :component="SearchOutline" />
            </template>
          </n-input>
          <n-button type="primary" ghost @click="handleSearch"> 搜索 </n-button>
        </n-input-group>
      </div>

      <!-- 日期选择区域 -->
      <div class="date-section">
        <n-text style="font-weight: bold">时间范围</n-text>

        <!-- 桌面端范围选择器 -->
        <div class="desktop-picker">
          <n-date-picker
            v-model:value="dateRange"
            type="daterange"
            clearable
            :is-date-disabled="disableFutureDate"
            placement="bottom-start"
          />
        </div>

        <!-- 移动端双选择器 -->
        <div class="mobile-pickers">
          <n-flex>
            <n-date-picker
              v-model:value="startDate"
              type="date"
              clearable
              style="min-width: 360px"
              :is-date-disabled="disableFutureDate"
              placement="bottom-start"
              placeholder="开始日期"
            />
            <n-date-picker
              v-model:value="endDate"
              type="date"
              clearable
              style="min-width: 360px"
              :is-date-disabled="disableFutureDate"
              placement="bottom-start"
              placeholder="结束日期"
            />
          </n-flex>
        </div>
      </div>

      <!-- 搜索历史 -->
      <div class="history-section">
        <div class="history-header">
          <n-text style="font-weight: bold">搜索历史</n-text>
          <n-button text type="error" @click="clearHistory" size="small">
            <template #icon>
              <n-icon><trash-outline /></n-icon>
            </template>
            清空
          </n-button>
        </div>

        <div class="history-content" :class="{ 'is-collapsed': isCollapsed && shouldCollapse }">
          <n-flex>
            <n-tag
              v-for="(item, index) in searchHistory"
              :key="index"
              :bordered="false"
              size="small"
              round
              clickable
              @click="handleHistoryClick(item)"
            >
              {{ item }}
            </n-tag>
          </n-flex>
        </div>

        <n-button
          v-if="shouldCollapse"
          text
          size="small"
          class="collapse-button"
          @click="isCollapsed = !isCollapsed"
        >
          {{ isCollapsed ? '展开' : '收起' }}
          <n-icon size="tiny">
            <chevron-down-outline v-if="isCollapsed" />
            <chevron-up-outline v-else />
          </n-icon>
        </n-button>
      </div>
    </div>
  </n-layout>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import {
  SearchOutline,
  ArrowBackOutline,
  TrashOutline,
  ChevronDownOutline,
  ChevronUpOutline,
} from '@vicons/ionicons5'

const router = useRouter()
const searchQuery = ref('')
const dateRange = ref<[number, number] | null>(null)
const startDate = ref<number | null>(null)
const endDate = ref<number | null>(null)
const isCollapsed = ref(true)

// 模拟搜索历史数据
const searchHistory = ref([
  '搜索历史1',
  '历史记录2',
  '测试数据3',
  '搜索示例4',
  '历史条目5',
  '搜索记录6',
  '测试历史7',
  '历史示例8',
  '历史示例9',
  '历史示例10',
  '历史示例11',
  '历史示例12',
  '历史示例9',
  '历史示例10',
  '历史示例11',
  '历史示例12',
])

// 计算是否需要显示折叠按钮
const shouldCollapse = computed(() => {
  return searchHistory.value.length > 6 // 假设6个项目占据两行
})

// 禁用未来日期
function disableFutureDate(ts: number) {
  return ts > Date.now()
}

// 处理搜索
function handleSearch() {
  if (!searchQuery.value.trim()) return
  console.log('搜索:', searchQuery.value, '日期范围:', dateRange.value)
  // TODO: 实现搜索逻辑
}

// 清空搜索历史
function clearHistory() {
  searchHistory.value = []
}

// 点击历史记录
function handleHistoryClick(item: string) {
  searchQuery.value = item
  handleSearch()
}

// 同步单独的日期选择器和日期范围选择器
watch(dateRange, (newRange) => {
  if (newRange) {
    startDate.value = newRange[0]
    endDate.value = newRange[1]
  } else {
    startDate.value = null
    endDate.value = null
  }
})

watch([startDate, endDate], ([newStart, newEnd]) => {
  if (newStart && newEnd) {
    dateRange.value = [newStart, newEnd]
  } else {
    dateRange.value = null
  }
})
</script>

<style scoped>
.search-page {
  padding: 16px;
  max-width: 800px;
  margin: 0 auto;
  min-height: 100vh;
  /* 确保页面至少占满整个视口高度 */
}

.top-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 24px;
}

.search-input {
  flex: 1;
}

.history-section {
  margin-top: 24px;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.history-content {
  transition: max-height 0.3s ease;
}

.history-content.is-collapsed {
  max-height: 72px;
  /* 约两行的高度 */
  overflow: hidden;
}

.collapse-button {
  display: flex;
  align-items: center;
  margin: 8px auto 0;
}

.desktop-picker {
  display: none;
}

@media (min-width: 640px) {
  .desktop-picker {
    display: block;
    width: 100%;
    max-width: 360px;
  }

  .mobile-pickers {
    display: none;
  }
}
</style>
