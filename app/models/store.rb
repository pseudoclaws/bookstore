# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :sales, dependent: :destroy
  has_many :publishers, through: :sales
  has_many :stocks, dependent: :destroy
  has_many :books, through: :stocks
end
