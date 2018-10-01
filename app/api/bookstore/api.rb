# frozen_string_literal: true

module Bookstore
  class API < Grape::API
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    prefix :api

    resource :publishers do
      desc "Return a list of shops selling at least one publisher's book."
      params do
        requires :id, type: Integer, desc: 'Publisher id.'
      end
      route_param :id do
        get :stores, jbuilder: 'publishers/stores' do
          publisher = Publisher.find(params[:id])
          @result = ListStores.call(publisher: publisher)
        end
      end
    end

    resource :stores do
      desc 'Mark book(s) as sold.'
      params do
        requires :id, type: Integer, desc: 'Store id'
        requires :book_id, type: Integer, desc: 'Book id'
        requires :amount, type: Integer, desc: 'Number of books sold'
      end
      route_param :id do
        put jbuilder: 'stores/sold_books' do
          @result = MarkBookAsSold.call(
            store:  Store.find(params[:id]),
            book:   Book.find(params[:book_id]),
            amount: params[:amount]
          )
          status :unprocessable_entity if @result.failure?
        end
      end
    end

    add_swagger_documentation
  end
end