# frozen_string_literal: true

class Transaction
  attr_accessor :amount
  attr_accessor :store
  attr_accessor :book
  attr_accessor :stock
  def initialize(opts = {}); end
end