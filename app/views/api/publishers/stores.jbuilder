json.shops(
  @result.stores.map do |store|
    {
      id: store.id,
      name: store.name,
      books_sold_count: @result.sales[store.id]&.books_sold_count || 0,
      books_in_stock: store.stocks.map do |stock|
        {
          id: stock.book.id,
          title: stock.book.title,
          copies_in_stock: stock.copies_in_stock
        }
      end
    }
  end
)