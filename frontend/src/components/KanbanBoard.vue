<template>
  <div>
    <div class="board-header">
      <button class="btn-add" @click="showModal = true">+ 追加</button>
    </div>

    <div v-if="errorMessage" class="error-toast" role="alert">
      {{ errorMessage }}
      <button class="toast-close" @click="errorMessage = ''">✕</button>
    </div>

    <div v-if="loadError" class="load-error">
      <p>書籍データを取得できませんでした。ページを再読み込みしてください。</p>
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
import { ref, onMounted } from 'vue'
import type { Book, BookStatus } from '../types/book'
import { getBooks, createBook, updateBook, deleteBook } from '../api/books'
import KanbanColumn from './KanbanColumn.vue'
import BookModal from './BookModal.vue'
import DeleteConfirmDialog from './DeleteConfirmDialog.vue'

const unreadBooks = ref<Book[]>([])
const readingBooks = ref<Book[]>([])
const completedBooks = ref<Book[]>([])

const showModal = ref(false)
const editingBook = ref<Book | null>(null)
const deletingBook = ref<Book | null>(null)
const errorMessage = ref('')
const loadError = ref(false)

function showError(msg: string) {
  errorMessage.value = msg
  setTimeout(() => { errorMessage.value = '' }, 4000)
}

onMounted(async () => {
  try {
    const books = await getBooks()
    unreadBooks.value = books.filter(b => b.status === 'unread')
    readingBooks.value = books.filter(b => b.status === 'reading')
    completedBooks.value = books.filter(b => b.status === 'completed')
  } catch {
    loadError.value = true
  }
})

async function fixStatuses() {
  const updates: Promise<unknown>[] = []

  for (const book of unreadBooks.value) {
    if (book.status !== 'unread') {
      book.status = 'unread'
      updates.push(updateBook(book.id, { status: 'unread' }))
    }
  }
  for (const book of readingBooks.value) {
    if (book.status !== 'reading') {
      book.status = 'reading'
      updates.push(updateBook(book.id, { status: 'reading' }))
    }
  }
  for (const book of completedBooks.value) {
    if (book.status !== 'completed') {
      book.status = 'completed'
      updates.push(updateBook(book.id, { status: 'completed' }))
    }
  }

  try {
    await Promise.all(updates)
  } catch {
    showError('ステータスの更新に失敗しました。ページを再読み込みしてください。')
  }
}

async function handleAdd(newBook: Omit<Book, 'id'>) {
  try {
    const book = await createBook(newBook)
    if (book.status === 'reading') readingBooks.value.push(book)
    else if (book.status === 'completed') completedBooks.value.push(book)
    else unreadBooks.value.push(book)
  } catch {
    showError('書籍の登録に失敗しました。もう一度お試しください。')
  }
}

function openEditModal(book: Book) {
  editingBook.value = { ...book }
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingBook.value = null
}

async function moveBook(book: Book, newStatus: BookStatus) {
  await handleUpdate({ ...book, status: newStatus })
}

function openDeleteDialog(book: Book) {
  deletingBook.value = book
}

async function confirmDelete() {
  if (!deletingBook.value) return
  try {
    await deleteBook(deletingBook.value.id)
    for (const arr of [unreadBooks, readingBooks, completedBooks]) {
      const idx = arr.value.findIndex(b => b.id === deletingBook.value!.id)
      if (idx !== -1) {
        arr.value.splice(idx, 1)
        break
      }
    }
    deletingBook.value = null
  } catch {
    showError('削除に失敗しました。もう一度お試しください。')
    deletingBook.value = null
  }
}

async function handleUpdate(updated: Book) {
  try {
    const saved = await updateBook(updated.id, updated)
    for (const arr of [unreadBooks, readingBooks, completedBooks]) {
      const idx = arr.value.findIndex(b => b.id === saved.id)
      if (idx !== -1) {
        arr.value.splice(idx, 1)
        break
      }
    }
    if (saved.status === 'reading') readingBooks.value.push(saved)
    else if (saved.status === 'completed') completedBooks.value.push(saved)
    else unreadBooks.value.push(saved)
  } catch {
    showError('書籍の更新に失敗しました。もう一度お試しください。')
  }
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

.error-toast {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 8px 24px 0;
  padding: 10px 16px;
  background: #c0392b;
  color: #fff;
  border-radius: 8px;
  font-size: 14px;
  gap: 12px;
}

.toast-close {
  background: none;
  border: none;
  color: #fff;
  font-size: 16px;
  cursor: pointer;
  padding: 0;
  line-height: 1;
}

.load-error {
  margin: 24px;
  padding: 16px;
  background: #fff3f3;
  border: 1px solid #e57373;
  border-radius: 8px;
  color: #c0392b;
  text-align: center;
  font-size: 14px;
}
</style>
