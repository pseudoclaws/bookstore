class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.references :publisher, foreign_key: true
      t.references :store, foreign_key: true
      t.integer :books_sold_count, default: 0, null: false

      t.timestamps
    end
    add_index :sales, %i[store_id publisher_id], unique: true
  end
end
