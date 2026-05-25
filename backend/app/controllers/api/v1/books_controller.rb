module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: [:show, :update]

      def index
        books = Book.all.order(created_at: :desc)
        render json: books
      end

      def show
        render json: @book
      end

      def create
        book = Book.new(book_params)
        if book.save
          render json: book, status: :created
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @book.update(book_params)
          render json: @book
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_book
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Book not found" }, status: :not_found
      end

      def book_params
        params.require(:book).permit(:title, :author, :status, :isbn, :cover_image_url, :rating, :memo, :started_at, :completed_at)
      end
    end
  end
end
