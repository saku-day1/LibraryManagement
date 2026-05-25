<template>
  <div class="book-card">
    <div class="card-body">
      <h3 class="book-title">{{ book.title }}</h3>
      <p class="book-author">{{ book.author }}</p>
      <div v-if="book.rating" class="book-rating">
        <span v-for="n in 5" :key="n" :class="{ filled: n <= book.rating! }">★</span>
      </div>
      <p v-if="book.memo" class="book-memo">{{ book.memo }}</p>
    </div>
    <div class="card-actions">
      <button class="btn-edit" @click.stop="$emit('edit')">編集</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Book } from '../types/book'

defineProps<{ book: Book }>()
defineEmits<{ edit: [] }>()
</script>

<style scoped>
.book-card {
  background: #fff;
  border-radius: 8px;
  padding: 12px 14px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  cursor: grab;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.book-card:active {
  cursor: grabbing;
}

.card-body {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.book-title {
  font-size: 14px;
  font-weight: 600;
  margin: 0;
  color: #1a1a2e;
}

.book-author {
  font-size: 12px;
  color: #666;
  margin: 0;
}

.book-rating {
  font-size: 12px;
}

.book-rating span {
  color: #ddd;
}

.book-rating span.filled {
  color: #f5a623;
}

.book-memo {
  font-size: 12px;
  color: #888;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-actions {
  display: flex;
  justify-content: flex-end;
}

.btn-edit {
  font-size: 12px;
  padding: 3px 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background: #f5f5f5;
  color: #555;
  cursor: pointer;
}

.btn-edit:hover {
  background: #e8e8e8;
}
</style>
