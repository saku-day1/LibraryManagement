<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal">
      <h2 class="modal-title">書籍を追加</h2>

      <form @submit.prevent="handleSubmit">
        <div class="field">
          <label>タイトル <span class="required">*</span></label>
          <input v-model="form.title" type="text" placeholder="例: リーダブルコード" />
          <p v-if="errors.title" class="error">{{ errors.title }}</p>
        </div>

        <div class="field">
          <label>著者 <span class="required">*</span></label>
          <input v-model="form.author" type="text" placeholder="例: Dustin Boswell" />
          <p v-if="errors.author" class="error">{{ errors.author }}</p>
        </div>

        <div class="field">
          <label>ISBN</label>
          <input v-model="form.isbn" type="text" placeholder="例: 9784873115658" />
        </div>

        <div class="field">
          <label>ステータス</label>
          <select v-model="form.status">
            <option value="unread">未読</option>
            <option value="reading">読書中</option>
            <option value="completed">読了</option>
          </select>
        </div>

        <div class="actions">
          <button type="button" class="btn-cancel" @click="$emit('close')">キャンセル</button>
          <button type="submit" class="btn-submit">登録</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import type { Book, BookStatus } from '../types/book'

const emit = defineEmits<{
  close: []
  add: [book: Omit<Book, 'id'>]
}>()

const form = reactive({
  title: '',
  author: '',
  isbn: '',
  status: 'unread' as BookStatus,
})

const errors = reactive({
  title: '',
  author: '',
})

function validate(): boolean {
  errors.title = form.title.trim() ? '' : 'タイトルは必須です'
  errors.author = form.author.trim() ? '' : '著者は必須です'
  return !errors.title && !errors.author
}

function handleSubmit() {
  if (!validate()) return
  emit('add', {
    title: form.title.trim(),
    author: form.author.trim(),
    isbn: form.isbn.trim() || null,
    status: form.status,
  })
  emit('close')
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}

.modal {
  background: #fff;
  border-radius: 12px;
  padding: 28px 32px;
  width: 420px;
  max-width: 95vw;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18);
}

.modal-title {
  font-size: 18px;
  font-weight: 700;
  margin: 0 0 20px;
  color: #1a1a2e;
}

.field {
  margin-bottom: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.field label {
  font-size: 13px;
  font-weight: 600;
  color: #444;
}

.required {
  color: #e53e3e;
}

.field input,
.field select {
  border: 1px solid #ccc;
  border-radius: 6px;
  padding: 8px 10px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}

.field input:focus,
.field select:focus {
  border-color: #1a1a2e;
}

.error {
  font-size: 12px;
  color: #e53e3e;
  margin: 0;
}

.actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 24px;
}

.btn-cancel {
  padding: 8px 18px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background: #f5f5f5;
  color: #555;
  font-size: 14px;
  cursor: pointer;
}

.btn-cancel:hover {
  background: #e8e8e8;
}

.btn-submit {
  padding: 8px 18px;
  border: none;
  border-radius: 6px;
  background: #1a1a2e;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
}

.btn-submit:hover {
  background: #2d2d4e;
}
</style>
