# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListStores, type: :class do
  let(:subject) { described_class.call(publisher: publisher) }
  context 'with valid publisher' do
    let(:publisher) { FactoryBot.create(:publisher) }
    let!(:book) { FactoryBot.create(:book, publisher: publisher) }
    let!(:other_publisher_book) { FactoryBot.create(:book) }
    let!(:store1) { FactoryBot.create(:store) }
    let!(:store2) { FactoryBot.create(:store) }
    let(:other_store) { FactoryBot.create(:store) }
    let!(:stock1) { FactoryBot.create(:stock, store: store1, book: book, copies_in_stock: 10) }
    let!(:stock2) { FactoryBot.create(:stock, store: store2, book: book, copies_in_stock: 100) }
    let!(:other_stock) { FactoryBot.create(:stock, store: other_store, book: other_publisher_book) }

    let!(:sale1) { FactoryBot.create(:sale, store: store1, publisher: publisher, books_sold_count: 5)}
    let!(:sale2) { FactoryBot.create(:sale, store: store2, publisher: publisher, books_sold_count: 1)}
    let!(:other_sale) { FactoryBot.create(:sale, store: other_store, publisher: other_publisher_book.publisher) }

    it "lists publisher's stores" do
      expect(subject.stores.where(id: [store1.id, store2.id])).not_to be_blank
    end

    it "doesn't list other publisher's store" do
      expect(subject.stores.where(id: other_store.id)).to be_blank
    end

    it 'orders stores by sold books quantity' do
      expect(subject.stores.to_a).to contain_exactly(store1, store2)
    end
  end

  context 'without publisher' do
    it 'raises exception' do
      expect { subject }.to raise_error
    end
  end
end