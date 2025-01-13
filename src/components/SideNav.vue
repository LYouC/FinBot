<template>
  <n-layout-sider
    :collapsed="collapsed"
    :collapsed-width="64"
    :width="240"
    :native-scrollbar="false"
    collapse-mode="width"
    :show-trigger="showTrigger"
    bordered
    class="side-nav"
    @collapse="collapsed = true"
    @expand="collapsed = false"
  >
    <br />
    <n-menu
      :collapsed="collapsed"
      :collapsed-width="64"
      :collapsed-icon-size="22"
      :options="menuOptions"
    />

    <!-- 添加主题切换开关 -->
    <div class="theme-switch">
      <n-switch v-model:value="isDarkMode" @update:value="handleThemeChange">
        <template #checked> 暗色 </template>
        <template #unchecked> 亮色 </template>
      </n-switch>
    </div>
  </n-layout-sider>

  <!-- 移动端抽屉 -->
  <n-drawer v-model:show="showDrawer" :width="240" placement="left">
    <br />
    <n-menu :options="menuOptions" />
    <div class="theme-switch-drawer">
      <n-switch v-model:value="isDarkMode" @update:value="handleThemeChange">
        <template #checked>暗色</template>
        <template #unchecked>亮色</template>
      </n-switch>
    </div>
  </n-drawer>
</template>

<script setup lang="ts">
import { ref, computed, h, type Component } from 'vue'
import { BookOutline, HomeOutline, SettingsOutline, PersonOutline } from '@vicons/ionicons5'
import { NIcon, darkTheme, useOsTheme } from 'naive-ui'
import { useLayoutStore } from '@/stores/layout'

const layoutStore = useLayoutStore()
const emit = defineEmits(['update:theme'])
const isDarkMode = ref(useOsTheme().value === 'dark')
const collapsed = ref(false)
const showDrawer = ref(false)

// 使用 store 中的状态
const showTrigger = computed(() => !layoutStore.isMobile)

// 切换移动端菜单
function toggleMobileMenu() {
  showDrawer.value = !showDrawer.value
}

function handleThemeChange(value: boolean) {
  emit('update:theme', value ? darkTheme : null)
}

// 导出抽屉显示状态和切换方法供父组件使用
defineExpose({
  showDrawer,
  toggleMobileMenu,
})

// 渲染图标
function renderIcon(icon: string | Component) {
  return () => h(NIcon, null, { default: () => h(icon) })
}

// 菜单选项
const menuOptions = [
  {
    label: '首页',
    key: 'home',
    icon: renderIcon(HomeOutline),
  },
  {
    label: '用户管理',
    key: 'users',
    icon: renderIcon(PersonOutline),
  },
  {
    label: '系统设置',
    key: 'settings',
    icon: renderIcon(SettingsOutline),
    children: [
      {
        label: '基本设置',
        key: 'basic-settings',
      },
      {
        label: '高级设置',
        key: 'advanced-settings',
      },
    ],
  },
  {
    label: '文档中心',
    key: 'docs',
    icon: renderIcon(BookOutline),
  },
]
</script>

<style scoped>
.side-nav {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 1;
}

.mobile-menu-trigger {
  display: none;
}

@media (min-width: 640px) {
  .mobile-menu-trigger {
    display: none;
  }
}

@media (max-width: 639px) {
  .side-nav {
    display: none;
  }
}

.theme-switch {
  position: absolute;
  bottom: 16px;
  left: 16px;
  right: 16px;
  display: flex;
  justify-content: center;
}

.theme-switch-drawer {
  position: absolute;
  bottom: 16px;
  left: 16px;
  right: 16px;
  display: flex;
  justify-content: center;
}
</style>
