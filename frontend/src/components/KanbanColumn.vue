<template>
  <div class="kanban-column">
    <h2 class="column-title">{{ title }}</h2>
    <VueDraggable
      v-model="books"
      group="books"
      class="card-list"
      @end="$emit('moved')"
    >
      <BookCard
        v-for="book in books"
        :key="book.id"
        :book="book"
        @edit="$emit('edit', book)"
        @move="(newStatus) => $emit('move', book, newStatus)"
      />
    </VueDraggable>
    <p v-if="books.length === 0" class="empty-message">書籍なし</p>
  </div>
</template>

<script setup lang="ts">
import { VueDraggable } from 'vue-draggable-plus'
import type { Book, BookStatus } from '../types/book'
import BookCard from './BookCard.vue'

const books = defineModel<Book[]>('books', { required: true })

defineProps<{ title: string }>()
defineEmits<{ moved: []; edit: [book: Book]; move: [book: Book, newStatus: BookStatus] }>()
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
  min-height: 60px;
}

.empty-message {
  font-size: 13px;
  color: #aaa;
  text-align: center;
  margin-top: 20px;
  pointer-events: none;
}
</style>
