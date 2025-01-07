<script setup lang="ts">
import { RouterView } from 'vue-router'
import { ref } from 'vue'
import { type GlobalTheme } from 'naive-ui'

const theme = ref<GlobalTheme | null>(null)
</script>

<template>
    <n-config-provider :theme="theme">
        <n-message-provider>
            <RouterView @update:theme="theme = $event" />
        </n-message-provider>
    </n-config-provider>
</template>
