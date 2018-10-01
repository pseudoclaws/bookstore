require 'rails_helper'

describe Bookstore::API do
  before do
    Bookstore::API.before { env["api.tilt.root"] = Rails.root.join 'app', 'views', 'api' }
  end

  def app
    Bookstore::API
  end

  let(:publisher) { FactoryBot.create(:publisher) }
  let!(:book) { FactoryBot.create(:book, publisher: publisher) }
  let!(:other_publisher_book) { FactoryBot.create(:book) }
  let!(:store1) { FactoryBot.create(:store) }
  let!(:store2) { FactoryBot.create(:store) }
  let(:other_store) { FactoryBot.create(:store) }
  let(:amount) { 5 }
  let(:in_stock1) { 10 }
  let(:in_stock2) { 100 }
  let!(:stock1) { FactoryBot.create(:stock, store: store1, book: book, copies_in_stock: in_stock1) }
  let!(:stock2) { FactoryBot.create(:stock, store: store2, book: book, copies_in_stock: in_stock2) }

  shared_context 'resource not found' do
    # before { subject }

    it do
      # expect(last_response.status).to eq 400
      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  shared_context "everything's all right" do
    before { subject }

    it do
      expect(last_response.status).to eq 200
    end
  end

  shared_context 'unprocessable entity' do
    before { subject }

    it 'has :unprocessable_entity status' do
      expect(last_response.status).to eq 422
    end
  end

  shared_context 'bad request' do
    before { subject }

    it 'has :bad_request status' do
      expect(last_response.status).to eq 400
    end
  end

  context 'GET /api/v1/publishers/:id/stores' do
    let(:subject) { get "/api/v1/publishers/#{publisher.id}/stores" }

    let!(:sale1) { FactoryBot.create(:sale, store: store1, publisher: publisher, books_sold_count: amount)}
    let!(:sale2) { FactoryBot.create(:sale, store: store2, publisher: publisher, books_sold_count: 1)}

    context 'with valid publisher' do
      it_behaves_like "everything's all right"

      it 'matches response schema' do
        get "/api/v1/publishers/#{publisher.id}/stores"
        expect(last_response).to match_response_schema('publishers/shops')
      end
    end

    context 'with invalid publisher' do
      let(:subject) { get '/api/v1/publishers/100/stores' }
      it_behaves_like 'resource not found'
    end
  end

  context 'PUT /api/v1/stores/:id' do
    let(:subject) { put "/api/v1/stores/#{store1.id}", params }
    let(:params) do
      { book_id: book.id, amount: 5 }
    end

    context 'with valid params' do
      it 'creates sale' do
        expect { subject }.to change { Sale.count }.by(1)
      end

      it 'creates sold_book' do
        expect { subject }.to change { SoldBook.count }.by(1)
      end

      it 'matches response schema' do
        subject
        expect(last_response).to match_response_schema('stores/sold_books')
      end
    end

    shared_context 'mark book as sold failure' do
      before { subject }

      it 'matches errors schema' do
        expect(last_response).to match_response_schema('stores/errors')
      end
    end

    context 'with invalid amount' do
      context 'without amount value' do
        let(:params) do
          { book_id: book.id }
        end

        it_behaves_like 'bad request'
      end

      context 'with zero amount' do
        let(:params) do
          { book_id: book.id, amount: 0 }
        end

        it_behaves_like 'unprocessable entity'
        it_behaves_like 'mark book as sold failure'
      end
    end

    context 'with insufficient amount in stock' do
      let(:params) do
        { book_id: book.id, amount: 1000 }
      end

      it_behaves_like 'unprocessable entity'
      it_behaves_like 'mark book as sold failure'
    end

    context 'with invalid store id' do
      let(:subject) do
        put "/api/v1/stores/100", params
      end

      it_behaves_like 'resource not found'
    end

    context 'with invalid book id' do
      let(:params) do
        { book_id: 100, amount: amount }
      end

      it_behaves_like 'resource not found'
    end
  end

  def response_body
    MultiJson.load(last_response.body)
  end
end