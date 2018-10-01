class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.references :store, foreign_key: true
      t.references :book, foreign_key: true
      t.integer :copies_in_stock, default: 0, null: false

      t.timestamps
    end
    add_index :stocks, %i[book_id store_id], unique: true
  end
end
