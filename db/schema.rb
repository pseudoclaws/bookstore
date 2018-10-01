# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_29_112305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.bigint "publisher_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "publisher_id"
    t.bigint "store_id"
    t.integer "books_sold_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_sales_on_publisher_id"
    t.index ["store_id", "publisher_id"], name: "index_sales_on_store_id_and_publisher_id", unique: true
    t.index ["store_id"], name: "index_sales_on_store_id"
  end

  create_table "sold_books", force: :cascade do |t|
    t.bigint "sale_id"
    t.bigint "book_id"
    t.integer "books_sold_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_sold_books_on_book_id"
    t.index ["sale_id", "book_id"], name: "index_sold_books_on_sale_id_and_book_id", unique: true
    t.index ["sale_id"], name: "index_sold_books_on_sale_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "store_id"
    t.bigint "book_id"
    t.integer "copies_in_stock", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "store_id"], name: "index_stocks_on_book_id_and_store_id", unique: true
    t.index ["book_id"], name: "index_stocks_on_book_id"
    t.index ["store_id"], name: "index_stocks_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "books", "publishers"
  add_foreign_key "sales", "publishers"
  add_foreign_key "sales", "stores"
  add_foreign_key "sold_books", "books"
  add_foreign_key "sold_books", "sales"
  add_foreign_key "stocks", "books"
  add_foreign_key "stocks", "stores"
end
