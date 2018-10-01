# frozen_string_literal: true

class Stock < ApplicationRecord
  belongs_to :store
  belongs_to :book
end
