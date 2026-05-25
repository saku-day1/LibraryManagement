module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: [:show]

      def index
        books = Book.all.order(created_at: :desc)
        render json: books
      end

      def show
        render json: @book
      end

      private

      def set_book
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Book not found" }, status: :not_found
      end
    end
  end
end
