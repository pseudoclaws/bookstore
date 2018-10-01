# frozen_string_literal: true

class MarkBookAsSold
  class Form < Reform::Form
    model :transaction
    properties :amount, :store, :book, :stock
    validates :amount, :store, :book, :stock, presence: true
    validates :amount, numericality: { only_integer: true, greater_than: 0 }

    validate do
      next if amount.nil? || stock.nil?

      errors.add(:amount, 'in stock is less than required quantity') if amount > stock.copies_in_stock
    end
  end
end