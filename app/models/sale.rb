# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :publisher
  belongs_to :store
  has_many :sold_books, dependent: :destroy
end
