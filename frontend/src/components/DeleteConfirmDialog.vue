<template>
  <div class="dialog-overlay" @click.self="$emit('cancel')">
    <div class="dialog" role="alertdialog" aria-modal="true">
      <h3 class="dialog-title">書籍を削除しますか？</h3>
      <p class="dialog-target">『{{ title }}』を削除します。</p>
      <p class="dialog-warning">この操作は取り消せません。</p>
      <div class="dialog-actions">
        <button class="btn-cancel" @click="$emit('cancel')">キャンセル</button>
        <button class="btn-delete" @click="$emit('confirm')">削除する</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{ title: string }>()
defineEmits<{ confirm: []; cancel: [] }>()
</script>

<style scoped>
.dialog-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
}

.dialog {
  background: #fff;
  border-radius: 10px;
  padding: 28px 32px;
  width: 340px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.18);
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.dialog-title {
  font-size: 16px;
  font-weight: 700;
  margin: 0;
  color: #1a1a2e;
}

.dialog-target {
  font-size: 14px;
  color: #333;
  margin: 4px 0 0;
}

.dialog-warning {
  font-size: 13px;
  color: #c0392b;
  margin: 0 0 8px;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 8px;
}

.btn-cancel {
  padding: 7px 18px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background: #f0f0f0;
  color: #555;
  font-size: 14px;
  cursor: pointer;
}

.btn-cancel:hover {
  background: #e0e0e0;
}

.btn-delete {
  padding: 7px 18px;
  border: none;
  border-radius: 6px;
  background: #c0392b;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
}

.btn-delete:hover {
  background: #a93226;
}
</style>
