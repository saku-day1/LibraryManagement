<template>
  <div class="book-card">
    <div class="card-body">
      <div class="card-header">
        <!-- 未読: 閉じた本（前表紙） -->
        <svg v-if="book.status === 'unread'" class="status-icon status-unread" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-label="未読">
          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
          <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
        </svg>
        <!-- 読書中: 開いた本 -->
        <svg v-else-if="book.status === 'reading'" class="status-icon status-reading" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-label="読書中">
          <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
          <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
        </svg>
        <!-- 読了: 閉じた本（後ろ表紙）+ チェック -->
        <svg v-else class="status-icon status-completed" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-label="読了">
          <path d="M19.5 17H6A2.5 2.5 0 0 0 4 19.5"/>
          <path d="M17.5 2H4v20h13.5A2.5 2.5 0 0 0 20 19.5v-15A2.5 2.5 0 0 0 17.5 2z"/>
          <polyline points="9,12 11,14 15,10"/>
        </svg>
        <h3 class="book-title">{{ book.title }}</h3>
      </div>
      <p class="book-author">{{ book.author }}</p>
      <div v-if="book.rating" class="book-rating">
        <span v-for="n in 5" :key="n" :class="{ filled: n <= book.rating! }">★</span>
      </div>
      <p v-if="book.memo" class="book-memo">{{ book.memo }}</p>
    </div>
    <div class="card-actions">
      <div class="move-buttons">
        <button
          v-if="book.status !== 'unread'"
          class="btn-move"
          :title="book.status === 'reading' ? '未読へ戻す' : '読書中へ戻す'"
          @click.stop="$emit('move', book.status === 'reading' ? 'unread' : 'reading')"
        >←</button>
        <button
          v-if="book.status !== 'completed'"
          class="btn-move"
          :title="book.status === 'unread' ? '読書中へ' : '読了へ'"
          @click.stop="$emit('move', book.status === 'unread' ? 'reading' : 'completed')"
        >→</button>
      </div>
      <div class="right-actions">
        <button class="btn-edit" @click.stop="$emit('edit')">編集</button>
        <button class="btn-delete" @click.stop="$emit('delete')">削除</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Book, BookStatus } from '../types/book'

defineProps<{ book: Book }>()
defineEmits<{ edit: []; move: [newStatus: BookStatus]; delete: [] }>()
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

.card-header {
  display: flex;
  align-items: center;
  gap: 6px;
}

.status-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.status-unread {
  color: #7b8cde;
}

.status-reading {
  color: #f5a623;
}

.status-completed {
  color: #27ae60;
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
  justify-content: space-between;
  align-items: center;
}

.right-actions {
  display: flex;
  gap: 6px;
  align-items: center;
}

.move-buttons {
  display: flex;
  gap: 4px;
}

.btn-move {
  font-size: 13px;
  width: 28px;
  height: 24px;
  border: 1px solid #d0d0d0;
  border-radius: 4px;
  background: #f0f0f0;
  color: #555;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.15s, color 0.15s;
}

.btn-move:hover {
  background: #1a1a2e;
  color: #fff;
  border-color: #1a1a2e;
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

.btn-delete {
  font-size: 12px;
  padding: 3px 10px;
  border: 1px solid #e57373;
  border-radius: 4px;
  background: #fff0f0;
  color: #c0392b;
  cursor: pointer;
}

.btn-delete:hover {
  background: #c0392b;
  color: #fff;
  border-color: #c0392b;
}
</style>
