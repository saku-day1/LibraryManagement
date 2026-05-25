<template>
  <div>
    <div class="board-header">
      <button class="btn-add" @click="showModal = true">+ 追加</button>
    </div>

    <div class="kanban-board">
      <KanbanColumn title="未読" :books="unread" />
      <KanbanColumn title="読書中" :books="reading" />
      <KanbanColumn title="読了" :books="completed" />
    </div>

    <BookModal
      v-if="showModal"
      @close="showModal = false"
      @add="handleAdd"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { Book } from '../types/book'
import KanbanColumn from './KanbanColumn.vue'
import BookModal from './BookModal.vue'

const books = ref<Book[]>([
  { id: 1, title: 'リーダブルコード', author: 'Dustin Boswell', status: 'unread' },
  { id: 2, title: 'Clean Architecture', author: 'Robert C. Martin', status: 'reading' },
  { id: 3, title: 'ドメイン駆動設計', author: 'Eric Evans', status: 'completed', rating: 5 },
])

const showModal = ref(false)

let nextId = 4

function handleAdd(newBook: Omit<Book, 'id'>) {
  books.value.push({ id: nextId++, ...newBook })
}

const unread = computed(() => books.value.filter(b => b.status === 'unread'))
const reading = computed(() => books.value.filter(b => b.status === 'reading'))
const completed = computed(() => books.value.filter(b => b.status === 'completed'))
</script>

<style scoped>
.board-header {
  display: flex;
  justify-content: flex-end;
  padding: 16px 24px 0;
}

.btn-add {
  padding: 8px 20px;
  background: #1a1a2e;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
}

.btn-add:hover {
  background: #2d2d4e;
}

.kanban-board {
  display: flex;
  gap: 20px;
  padding: 16px 24px 24px;
  justify-content: center;
  flex-wrap: wrap;
}
</style>
