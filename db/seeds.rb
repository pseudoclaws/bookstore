# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

publisher1 = Publisher.create(name: 'Apress')
publisher2 = Publisher.create(name: 'Manning Publications')

book1 = Book.create(title: 'Yiddish songs', publisher: publisher1)
book2 = Book.create(title: 'Go in Practice', publisher: publisher2)

store1 = Store.create(name: 'Amazon')
store2 = Store.create(name: 'Manning store')

Stock.create(store: store1, book: book1, copies_in_stock: 100)
Stock.create(store: store1, book: book2, copies_in_stock: 100)
Stock.create(store: store2, book: book2, copies_in_stock: 100)

