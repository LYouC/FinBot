<template>
    <n-layout has-sider position="absolute">
        <side-nav ref="sideNavRef" @update:theme="handleThemeChange" />
        <n-layout-content :native-scrollbar="false" class="main-content">
            <div class="top-bar">
                <div class="left-section">
                    <n-button v-if="layoutStore.isMobile" text @click="handleMenuClick" class="menu-trigger">
                        <n-icon size="24">
                            <menu-outline />
                        </n-icon>
                    </n-button>
                </div>

                <div class="right-section">
                    <n-button text @click="router.push('/search')" class="search-button">
                        <n-icon size="24">
                            <search-outline />
                        </n-icon>
                    </n-button>
                </div>
            </div>

            <n-card class="content-card">
                <n-page-header subtitle="欢迎使用后台管理系统">
                    <template #title>
                        <n-gradient-text type="info">
                            后台管理系统
                        </n-gradient-text>
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
                </n-space>
            </n-card>
        </n-layout-content>
    </n-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { MenuOutline, SearchOutline } from '@vicons/ionicons5'
import { type GlobalTheme } from 'naive-ui'
import SideNav from '@/components/SideNav.vue'
import { useLayoutStore } from '@/stores/layout'
import { useRouter } from 'vue-router'

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

</script>

<style scoped>
.main-content {
    padding: 16px;
    transition: margin-left 0.3s ease;
}

.top-bar {
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 16px;
    /* margin-left: 1vw;
    margin-right: 1vw; */
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
        margin-left: 64px;
    }
}

@media (min-width: 1024px) {
    .n-layout-sider:not(.n-layout-sider--collapsed)+.main-content {
        margin-left: 240px;
    }
}

.search-button {
    padding: 4px;
}
</style>