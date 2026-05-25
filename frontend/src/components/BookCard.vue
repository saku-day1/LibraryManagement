<template>
  <div class="book-card">
    <h3 class="book-title">{{ book.title }}</h3>
    <p class="book-author">{{ book.author }}</p>
    <div v-if="book.rating" class="book-rating">
      <span v-for="n in 5" :key="n" :class="{ filled: n <= book.rating! }">★</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Book } from '../types/book'

defineProps<{ book: Book }>()
</script>

<style scoped>
.book-card {
  background: #fff;
  border-radius: 8px;
  padding: 12px 14px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  cursor: grab;
}

.book-card:active {
  cursor: grabbing;
}

.book-title {
  font-size: 14px;
  font-weight: 600;
  margin: 0 0 4px;
  color: #1a1a2e;
}

.book-author {
  font-size: 12px;
  color: #666;
  margin: 0 0 6px;
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
</style>
