# frozen_string_literal: true

class ListStores
  include Interactor

  delegate :publisher, to: :context

  def call
    context.stores = Store.select('stores.id, stores.name')
                          .includes(stocks: :book).references(:books).where(books: { publisher_id: publisher.id })
                          .joins("left outer join sales on sales.store_id = stores.id and sales.publisher_id = #{publisher.id}")
                          .order('sales.books_sold_count desc, stores.name')
    context.sales = Sale.where(store_id: context.stores.ids).index_by(&:store_id)
  end
end