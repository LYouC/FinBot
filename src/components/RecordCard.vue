<template>
    <n-card :class="['record-card', { 'is-selectable': selectable }]" size="small" @click="handleCardClick">

        <n-grid :cols="20">


            <!-- 主要内容区域 -->
            <n-gi span="14">
                <n-flex align-items="center">
                    <div class="control-button">
                        <n-button v-if="!selectable" quaternary circle size="small" @click.stop="toggleExpand">
                            <n-icon size="1.6em">
                                <component :is="expanded ? ChevronUpOutline : ChevronDownOutline" />
                            </n-icon>
                        </n-button>
                        <n-checkbox v-else :checked="selected" @update:checked="handleCheckboxChange" @click.stop
                            size="large" />
                    </div>
                    <div class="summary-section" style="font-size: 1.2em;">
                        <span class="date-text">{{ formatDate(record.date) }}</span>
                        <span class="summary-text">{{ record.summary }}</span>
                    </div>
                </n-flex>
            </n-gi>

            <!-- 金额区域 -->
            <n-gi span="6">
                <span :class="['amount', record.amount < 0 ? 'expense' : 'income']" style="font-size: 1.2em;">
                    {{ record.amount > 0 ? '+' : '' }}{{ record.amount }}
                </span>
            </n-gi>

            <!-- 详细信息区域 -->
            <n-gi v-if="expanded && record.details" span="24">
                <div class="details-section">
                    <n-text depth="3" class="details-text">{{ record.details }}</n-text>
                    <div class="collapse-button">
                        <n-button text size="tiny" @click.stop="toggleExpand">
                            收起详情
                            <template #icon>
                                <n-icon><chevron-up-outline /></n-icon>
                            </template>
                        </n-button>
                    </div>
                </div>
            </n-gi>
        </n-grid>
    </n-card>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ChevronDownOutline, ChevronUpOutline } from '@vicons/ionicons5'
import { format } from 'date-fns'

interface Record {
    id: number | string
    date: Date | number
    summary: string
    details?: string
    amount: number
}

const props = defineProps<{
    record: Record
    selectable?: boolean
    selected?: boolean
}>()

const emit = defineEmits<{
    'update:selected': [boolean]
    'click': [Record]
}>()

const expanded = ref(false)

// 处理复选框变化
function handleCheckboxChange(value: boolean) {
    emit('update:selected', value)
}

// 格式化日期
function formatDate(date: Date | number) {
    return format(new Date(date), 'MM-dd HH:mm')
}

// 切换展开状态
function toggleExpand() {
    expanded.value = !expanded.value
}

// 处理卡片点击
function handleCardClick() {
    emit('click', props.record)
}
</script>

<style scoped>
.record-card {
    transition: all 0.5s ease;
}

.record-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.control-button {
    display: flex;
    align-items: center;
    margin-right: 8px;
    min-width: 32px;
    /* 确保按钮和复选框有固定宽度 */
    justify-content: center;
}

.summary-section {
    display: flex;
    align-items: center;
    gap: 8px;
    flex: 1;
}

.date-text {
    color: var(--n-text-color-3);
    font-size: 0.9em;
}

.amount {
    font-weight: bold;
    font-size: 1.1em;
    display: flex;
    justify-content: flex-end;
}

.amount.expense {
    color: #d03050;
}

.amount.income {
    color: #18a058;
}

.details-section {
    margin-top: 12px;
    padding: 12px;
    background-color: var(--n-color-modal);
    border-radius: 6px;
}

.details-text {
    font-size: 0.9em;
    line-height: 1.5;
}

.collapse-button {
    display: flex;
    justify-content: center;
    margin-top: 8px;
    border-top: 1px solid var(--n-border-color);
    padding-top: 8px;
}
</style>