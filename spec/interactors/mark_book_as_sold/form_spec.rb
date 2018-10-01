# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkBookAsSold::Form, type: :class do
  let(:form) { described_class.new(Transaction.new) }
  let(:subject) { form.validate(params) }

  let(:amount) { 3 }
  let(:in_stock) { 10 }
  let!(:book) { FactoryBot.create(:book) }
  let!(:store) { FactoryBot.create(:store) }
  let!(:stock) { FactoryBot.create(:stock, store: store, book: book, copies_in_stock: in_stock) }

  context 'with valid params' do
    let(:params) do
      {
        store: store,
        book:  book,
        stock: stock,
        amount: amount
      }
    end

    it 'validates params successfully' do
      expect(subject).to eq true
    end
  end

  context 'with invalid params' do
    let(:params) do
      {}
    end

    it 'does not validate successfully' do
      expect(subject).to eq false
    end

    it 'has errors' do
      subject
      expect(form.errors).not_to be_blank
    end

    it 'has error messages' do
      subject
      expect(form.errors.full_messages).to contain_exactly(
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
          store:  store,
          book:   book,
          stock:  stock,
          amount: in_stock + 3
        }
      end
      it 'does not validate successfully' do
      end

      it 'has errors' do
        subject
        expect(form.errors).not_to be_blank
      end

      it 'has error messages' do
        subject
        expect(form.errors.full_messages).to contain_exactly('Amount in stock is less than required quantity')
      end
    end
  end
end