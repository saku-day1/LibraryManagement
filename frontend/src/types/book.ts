export type BookStatus = 'unread' | 'reading' | 'completed'

export interface Book {
  id: number
  title: string
  author: string
  status: BookStatus
  isbn?: string | null
  cover_image_url?: string | null
  rating?: number | null
  memo?: string | null
  started_at?: string | null
  completed_at?: string | null
  created_at?: string
}
