# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkBookAsSold, type: :class do
  let(:amount) { 5 }
  let(:in_stock) { 10 }
  let(:subject) { described_class.call(params) }
  let!(:book) { FactoryBot.create(:book) }
  let!(:store) { FactoryBot.create(:store) }
  let!(:stock) { FactoryBot.create(:stock, store: store, book: book, copies_in_stock: in_stock) }
  context 'with valid params' do
    let(:params) do
      {
        book:   book,
        store:  store,
        amount: amount
      }
    end

    context 'without sale for that publisher' do
      it "creates sale" do
        expect { subject }.to change { Sale.count }.by(1)
      end

      it "sets sold books count" do
        sale = subject.sale
        expect(sale.books_sold_count).to eq amount
      end

      it "creates sold_book record" do
        expect { subject }.to change { SoldBook.count }.by(1)
      end

      it 'sets sold_book record books quantity' do
        sold_book = subject.sold_book
        expect(sold_book.books_sold_count).to eq amount
      end

      it 'decrements copies in stock count' do
        expect { subject }.to change { stock.reload.copies_in_stock }.by(-amount)
      end
    end

    context 'with sale for that publisher' do
      let(:prev_sold_count) { 10 }
      let!(:sale) { FactoryBot.create(:sale, store: store, publisher: book.publisher, books_sold_count: prev_sold_count) }

      it "doesn't create sale" do
        expect { subject }.not_to change { Sale.count }
      end

      it "sets sold books count" do
        sale = subject.sale
        expect(sale.books_sold_count).to eq prev_sold_count + amount
      end

      it 'sets sold_book record books quantity' do
        sold_book = subject.sold_book
        expect(sold_book.books_sold_count).to eq amount
      end

      context "with this book already sold via this store" do
        let!(:sold_book) { FactoryBot.create(:sold_book, sale: sale, book: book, books_sold_count: prev_sold_count) }
        it "doesn't create sold_book record" do
          expect { subject }.not_to change { SoldBook.count }
        end

        it 'sets sold_book record books quantity' do
          sold_book = subject.sold_book
          expect(sold_book.books_sold_count).to eq prev_sold_count + amount
        end
      end
    end
  end

  context 'with invalid params' do
    let(:params) do
      {}
    end

    it 'has errors' do
      subject
      expect(subject.errors).not_to be_blank
    end

    it 'has error messages' do
      expect(subject.errors.full_messages).to contain_exactly(
                                                "Amount can't be blank",
                                                "Amount is not a number",
                                                "Book can't be blank",
                                                "Stock can't be blank",
                                                "Store can't be blank"
                                           )
    end

    context 'with lack of books' do
      let(:params) do
        {
          book:  book,
          store: store,
          amount: in_stock + amount
        }
      end

      it 'has errors' do
        subject
        expect(subject.errors).not_to be_blank
      end

      it 'has error messages' do
        expect(subject.errors.full_messages).to contain_exactly(
                                                  'Amount in stock is less than required quantity'
                                                )
      end
    end
  end
end