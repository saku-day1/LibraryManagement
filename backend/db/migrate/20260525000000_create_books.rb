class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false, limit: 255
      t.string :author, null: false, limit: 100
      t.column :status, "ENUM('unread','reading','completed')", null: false, default: "unread"
      t.string :isbn, limit: 13
      t.text :cover_image_url
      t.integer :rating, limit: 1
      t.text :memo
      t.date :started_at
      t.date :completed_at

      t.timestamps
    end
  end
end
