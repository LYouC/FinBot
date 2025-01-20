<template>
  <n-layout position="absolute">
    <n-layout-header bordered style="height: 48px">
      <n-grid x-gap="12" :cols="4">
        <n-gi>
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
            <n-gradient-text> GISO </n-gradient-text>
          </n-button>
        </n-gi>
        <n-gi :span="2">
          <n-flex justify="space-between" style="align-items: center; height: 100%">
            <n-input-group style="align-items: center">
              <n-input placeholder="请输入搜索内容" />
              <n-button
                type="primary"
                ghost
                @click="router.push('/search')"
                style="align-items: center"
              >
                <n-icon>
                  <search-outline />
                </n-icon>
              </n-button>
            </n-input-group>
          </n-flex>
        </n-gi>
        <n-gi>
          <n-flex justify="flex-end" style="margin-right: 10px; height: 100%">
            <n-button
              text
              type="error"
              v-show="isSelectMode"
              @click="toggleDeleteWhenSelectMode"
              size="large"
            >
              <template #icon>
                <n-icon size="26px">
                  <delete20-regular />
                </n-icon>
              </template>
              {{ layoutStore.isMobile ? '' : '删除选中目标' }}
            </n-button>
            <n-button
              text
              size="large"
              @click="toggleSelectMode"
              style="align-items: center; vertical-align: middle"
            >
              <template #icon>
                <n-icon size="26px">
                  <template v-if="isSelectMode">
                    <edit-off20-regular />
                  </template>
                  <template v-else>
                    <edit20-regular />
                  </template>
                </n-icon>
              </template>
              {{ layoutStore.isMobile ? '' : isSelectMode ? '完成' : '编辑' }}
            </n-button>
          </n-flex>
        </n-gi>
      </n-grid>
    </n-layout-header>
    <n-layout has-sider position="absolute" style="top: 48px">
      <side-nav ref="sideNavRef" @update:theme="handleThemeChange" />
      <n-layout-content :native-scrollbar="false" class="main-content">
        <n-space vertical size="medium" style="margin-top: 20px">
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
        </n-space>
        <n-divider dashed style="margin-top: 1em; margin-bottom: 1em"> </n-divider>
        <n-card
          v-for="recordGroup in records"
          :key="recordGroup.date"
          :title="recordGroup.date"
          size="small"
          hoverable
        >
          <template #header-extra>
            <n-tag type="success"> +{{ recordGroup.income }} </n-tag>
            <n-tag type="error"> -{{ recordGroup.outcome }} </n-tag>
            <n-tag type="warning">
              {{ recordGroup.income - recordGroup.outcome > 0 ? '+' : ''
              }}{{ recordGroup.income - recordGroup.outcome }}
            </n-tag>
          </template>
          <record-card
            v-for="r in recordGroup.records"
            :key="r.id"
            :record="r"
            :selectable="isSelectMode"
            v-model:selected="r.selected"
            @click="handleRecordClick(r)"
          />
        </n-card>
      </n-layout-content>
    </n-layout>
  </n-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { MenuOutline, SearchOutline } from '@vicons/ionicons5/es'
import { Edit20Regular, Delete20Regular, EditOff20Regular } from '@vicons/fluent'
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

interface RecordGroup {
  date: string
  income: number
  outcome: number
  records: Record[]
}

// 模拟记录数据
const records = ref<RecordGroup[]>([
  {
    date: '2025-01-15', // 日期
    income: 35, // 收入
    outcome: 25, // 支出
    records: [
      {
        id: 1,
        date: new Date('2025-01-15T12:00:00'),
        summary: '购买了一本《爱在西元前》',
        details: '这是一本很好看的书',
        amount: 25.5,
        selected: false,
      },
      {
        id: 2,
        date: new Date('2025-01-15T12:30:00'),
        summary: '购买了一本《爱在美元前》',
        details: '这是一本很好看的书',
        amount: 25.5,
        selected: false,
      },
    ],
  },
  {
    date: '2025-01-14',
    income: 36,
    outcome: 2500,
    records: [
      {
        id: 3,
        date: new Date('2025-01-14T12:00:00'),
        summary: '购买ice phone',
        details: '这是一部很好看的手机',
        amount: 2500,
        selected: false,
      },
      {
        id: 4,
        date: new Date('2025-01-14T12:30:00'),
        summary: '购买了一本《爱在东元前》',
        details: '这是一本很好看的书',
        amount: 25.5,
        selected: false,
      },
    ],
  },
])

// 切换选择模式
function toggleSelectMode() {
  console.log('切换选择模式')
  isSelectMode.value = !isSelectMode.value
}

function toggleDeleteWhenSelectMode() {
  console.log('删除选中记录')
  records.value.forEach((group) => {
    group.records = group.records.filter((r) => !r.selected)
  })
  for (let i = records.value.length - 1; i >= 0; i--) {
    let total_income = 0
    let total_outcome = 0
    for (let j = records.value[i].records.length - 1; j >= 0; j--) {
      if (records.value[i].records[j].amount > 0) total_income += records.value[i].records[j].amount
      else total_outcome += records.value[i].records[j].amount
    }
    records.value[i].income = total_income
    records.value[i].outcome = total_outcome
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
