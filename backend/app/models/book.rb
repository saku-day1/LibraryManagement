class Book < ApplicationRecord
  enum :status, { unread: "unread", reading: "reading", completed: "completed" }

  validates :title,  presence: true, length: { maximum: 255 }
  validates :author, presence: true, length: { maximum: 100 }
  validates :isbn,   length: { is: 13 }, allow_nil: true, allow_blank: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
end
