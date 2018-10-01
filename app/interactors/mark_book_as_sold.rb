# frozen_string_literal: true

class MarkBookAsSold
  include Interactor

  delegate :store, :book, :stock, :sale, :sold_book, :amount, to: :context

  def call
    if store.present? && book.present?
      init_sale
      init_sold_book
    end

    ApplicationRecord.transaction do
      context.stock = context.store&.stocks&.where(book_id: context.book.id)&.lock&.first
      validate_context!
      process_sale!
      process_sold_book!
      process_stock!
    end
    context.fail!(errors: form.errors) unless form.errors.blank?
  end

  private

  def form
    @form ||= Form.new(Transaction.new)
  end

  def init_sale
    context.sale = store.sales.lock(true).create(publisher_id: book.publisher_id)
  rescue ActiveRecord::RecordNotUnique
    context.sale = store.sales.where(publisher_id: book.publisher_id).first
  end

  def init_sold_book
    context.sold_book = sale.sold_books.lock(true).create(book_id: book.id)
  rescue ActiveRecord::RecordNotUnique
  end

  def validate_context!
    return if form.validate(context.to_h)

    raise ActiveRecord::Rollback
  end

  def process_sale!
    context.sale = store.sales.where(publisher_id: book.publisher_id).lock(true).first
    return if sale.increment!(:books_sold_count, context.amount)

    form.errors.merge!(sale.errors)
    raise ActiveRecord::Rollback
  end

  def process_sold_book!
    context.sold_book = sale.sold_books.where(book_id: book.id).lock(true).first
    return if sold_book.increment!(:books_sold_count, context.amount)

    form.errors.merge!(sold_book.errors)
    raise ActiveRecord::Rollback
  end

  def process_stock!
    return if stock.decrement!(:copies_in_stock, context.amount)

    form.errors.merge!(sold_book.errors)
    raise ActiveRecord::Rollback
  end
end