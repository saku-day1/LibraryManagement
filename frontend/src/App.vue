<template>
  <div>
    <header class="app-header">
      <h1>LibraryManagement</h1>
    </header>
    <main>
      <KanbanBoard />
    </main>
  </div>
</template>

<script setup lang="ts">
import KanbanBoard from './components/KanbanBoard.vue'
</script>

<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: 'Helvetica Neue', Arial, sans-serif;
  background: #e8eaf0;
}
</style>

<style scoped>
.app-header {
  background: #1a1a2e;
  color: #fff;
  padding: 16px 24px;
}

.app-header h1 {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
}
</style>
