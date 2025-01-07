import { defineStore } from 'pinia'
import { computed } from 'vue'
import { useWindowSize } from '@vueuse/core'

export const useLayoutStore = defineStore('layout', () => {
  const { width } = useWindowSize()

  const isMobile = computed(() => width.value < 640)
  const isTablet = computed(() => width.value >= 640 && width.value < 1024)
  const isDesktop = computed(() => width.value >= 1024)
  const collapsed = computed(() => isMobile.value || isTablet.value)

  return {
    isMobile,
    isTablet,
    isDesktop,
    collapsed,
  }
})
