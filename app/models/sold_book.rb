# frozen_string_literal: true

class SoldBook < ApplicationRecord
  belongs_to :sale
  belongs_to :book
end
