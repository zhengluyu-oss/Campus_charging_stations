import type { EChartsOption } from 'echarts'

export function energyChartTheme(): Record<string, unknown> {
  return {
    color: ['#00e5ff', '#7cffb2', '#ffc857', '#ff5c7a', '#8aa0b5'],
    backgroundColor: 'transparent',
    textStyle: {
      color: '#8aa0b5',
      fontFamily: 'DM Sans, PingFang SC, sans-serif',
    },
    title: {
      textStyle: { color: '#e8f1f8', fontWeight: 600 },
    },
    legend: {
      textStyle: { color: '#8aa0b5' },
    },
    categoryAxis: {
      axisLine: { lineStyle: { color: 'rgba(255,255,255,0.12)' } },
      axisLabel: { color: '#8aa0b5' },
      splitLine: { show: false },
    },
    valueAxis: {
      axisLine: { show: false },
      axisLabel: { color: '#8aa0b5' },
      splitLine: { lineStyle: { color: 'rgba(0,229,255,0.08)' } },
    },
    tooltip: {
      backgroundColor: 'rgba(12,22,36,0.92)',
      borderColor: 'rgba(0,229,255,0.35)',
      textStyle: { color: '#e8f1f8' },
    },
  }
}

export function withMotion(option: EChartsOption, animate: boolean): EChartsOption {
  if (animate) return option
  return { ...option, animation: false }
}
