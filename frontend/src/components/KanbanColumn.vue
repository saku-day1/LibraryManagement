<template>
  <div class="kanban-column">
    <h2 class="column-title">{{ title }}</h2>
    <div class="card-list">
      <BookCard v-for="book in books" :key="book.id" :book="book" />
      <p v-if="books.length === 0" class="empty-message">書籍なし</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Book } from '../types/book'
import BookCard from './BookCard.vue'

defineProps<{
  title: string
  books: Book[]
}>()
</script>

<style scoped>
.kanban-column {
  background: #f0f2f5;
  border-radius: 10px;
  padding: 16px;
  width: 300px;
  min-height: 400px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.column-title {
  font-size: 16px;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 8px;
}

.card-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  flex: 1;
}

.empty-message {
  font-size: 13px;
  color: #aaa;
  text-align: center;
  margin-top: 20px;
}
</style>
