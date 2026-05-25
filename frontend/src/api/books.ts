import axios from 'axios'
import type { Book } from '../types/book'

const api = axios.create({ baseURL: '/api/v1' })

export function getBooks() {
  return api.get<Book[]>('/books').then(r => r.data)
}

export function createBook(payload: Omit<Book, 'id' | 'created_at'>) {
  return api.post<Book>('/books', payload).then(r => r.data)
}

export function updateBook(id: number, payload: Partial<Omit<Book, 'id' | 'created_at'>>) {
  return api.patch<Book>(`/books/${id}`, payload).then(r => r.data)
}

export function deleteBook(id: number) {
  return api.delete(`/books/${id}`)
}
