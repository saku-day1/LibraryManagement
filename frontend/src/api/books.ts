import axios from 'axios'
import type { Book } from '../types/book'

const api = axios.create({ baseURL: '/api/v1' })

export interface BookSearchParams {
  q?: string
  status?: string
}

export function getBooks(params?: BookSearchParams) {
  return api.get<Book[]>('/books', { params }).then(r => r.data)
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
