class CreateSoldBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :sold_books do |t|
      t.references :sale, foreign_key: true
      t.references :book, foreign_key: true
      t.integer :books_sold_count, default: 0, null: false

      t.timestamps
    end
    add_index :sold_books, %i[sale_id book_id], unique: true
  end
end
