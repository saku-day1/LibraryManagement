<template>
  <div>
    <div class="board-header">
      <button class="btn-add" @click="showModal = true">+ 追加</button>
    </div>

    <div class="kanban-board">
      <KanbanColumn
        title="未読"
        v-model:books="unreadBooks"
        @moved="fixStatuses"
        @edit="openEditModal"
        @move="moveBook"
        @delete="openDeleteDialog"
      />
      <KanbanColumn
        title="読書中"
        v-model:books="readingBooks"
        @moved="fixStatuses"
        @edit="openEditModal"
        @move="moveBook"
        @delete="openDeleteDialog"
      />
      <KanbanColumn
        title="読了"
        v-model:books="completedBooks"
        @moved="fixStatuses"
        @edit="openEditModal"
        @move="moveBook"
        @delete="openDeleteDialog"
      />
    </div>

    <BookModal
      v-if="showModal"
      :book="editingBook ?? undefined"
      @close="closeModal"
      @add="handleAdd"
      @update="handleUpdate"
    />

    <DeleteConfirmDialog
      v-if="deletingBook"
      :title="deletingBook.title"
      @confirm="confirmDelete"
      @cancel="deletingBook = null"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Book, BookStatus } from '../types/book'
import KanbanColumn from './KanbanColumn.vue'
import BookModal from './BookModal.vue'
import DeleteConfirmDialog from './DeleteConfirmDialog.vue'

const unreadBooks = ref<Book[]>([
  { id: 1, title: 'リーダブルコード', author: 'Dustin Boswell', status: 'unread' },
])
const readingBooks = ref<Book[]>([
  { id: 2, title: 'Clean Architecture', author: 'Robert C. Martin', status: 'reading' },
])
const completedBooks = ref<Book[]>([
  { id: 3, title: 'ドメイン駆動設計', author: 'Eric Evans', status: 'completed', rating: 5 },
])

const showModal = ref(false)
const editingBook = ref<Book | null>(null)
const deletingBook = ref<Book | null>(null)
let nextId = 4

function fixStatuses() {
  unreadBooks.value.forEach(b => { b.status = 'unread' })
  readingBooks.value.forEach(b => { b.status = 'reading' })
  completedBooks.value.forEach(b => { b.status = 'completed' })
}

function handleAdd(newBook: Omit<Book, 'id'>) {
  const book: Book = { id: nextId++, ...newBook }
  if (book.status === 'reading') readingBooks.value.push(book)
  else if (book.status === 'completed') completedBooks.value.push(book)
  else unreadBooks.value.push(book)
}

function openEditModal(book: Book) {
  editingBook.value = { ...book }
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingBook.value = null
}

function moveBook(book: Book, newStatus: BookStatus) {
  handleUpdate({ ...book, status: newStatus })
}

function openDeleteDialog(book: Book) {
  deletingBook.value = book
}

function confirmDelete() {
  if (!deletingBook.value) return
  for (const arr of [unreadBooks, readingBooks, completedBooks]) {
    const idx = arr.value.findIndex(b => b.id === deletingBook.value!.id)
    if (idx !== -1) {
      arr.value.splice(idx, 1)
      break
    }
  }
  deletingBook.value = null
}

function handleUpdate(updated: Book) {
  for (const arr of [unreadBooks, readingBooks, completedBooks]) {
    const idx = arr.value.findIndex(b => b.id === updated.id)
    if (idx !== -1) {
      arr.value.splice(idx, 1)
      break
    }
  }
  if (updated.status === 'reading') readingBooks.value.push(updated)
  else if (updated.status === 'completed') completedBooks.value.push(updated)
  else unreadBooks.value.push(updated)
}
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
