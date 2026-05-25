<template>
  <div class="kanban-board">
    <KanbanColumn
      title="未読"
      :books="unread"
    />
    <KanbanColumn
      title="読書中"
      :books="reading"
    />
    <KanbanColumn
      title="読了"
      :books="completed"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { Book } from '../types/book'
import KanbanColumn from './KanbanColumn.vue'

const books = ref<Book[]>([
  { id: 1, title: 'リーダブルコード', author: 'Dustin Boswell', status: 'unread' },
  { id: 2, title: 'Clean Architecture', author: 'Robert C. Martin', status: 'reading' },
  { id: 3, title: 'ドメイン駆動設計', author: 'Eric Evans', status: 'completed', rating: 5 },
])

const unread = computed(() => books.value.filter(b => b.status === 'unread'))
const reading = computed(() => books.value.filter(b => b.status === 'reading'))
const completed = computed(() => books.value.filter(b => b.status === 'completed'))
</script>

<style scoped>
.kanban-board {
  display: flex;
  gap: 20px;
  padding: 24px;
  justify-content: center;
  flex-wrap: wrap;
}
</style>
