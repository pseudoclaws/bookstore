# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :publisher
  has_many :sold_books, dependent: :destroy
  has_many :stocks, dependent: :destroy
end
