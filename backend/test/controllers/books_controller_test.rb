require "test_helper"

class Api::V1::BooksControllerTest < ActionDispatch::IntegrationTest
  # --- GET /api/v1/books ---

  test "一覧取得: 200 と配列を返す" do
    get "/api/v1/books"
    assert_response :success
    assert_equal "application/json", @response.media_type
    body = JSON.parse(@response.body)
    assert_kind_of Array, body
  end

  # --- GET /api/v1/books/:id ---

  test "詳細取得: 存在する ID なら 200 を返す" do
    book = books(:unread_book)
    get "/api/v1/books/#{book.id}"
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal book.title, body["title"]
  end

  test "詳細取得: 存在しない ID なら 404 を返す" do
    get "/api/v1/books/0"
    assert_response :not_found
  end

  # --- POST /api/v1/books ---

  test "登録: 正常なパラメータなら 201 と書籍を返す" do
    assert_difference "Book.count", 1 do
      post "/api/v1/books",
        params: { book: { title: "新しい本", author: "著者名", status: "unread" } },
        as: :json
    end
    assert_response :created
    body = JSON.parse(@response.body)
    assert_equal "新しい本", body["title"]
  end

  test "登録: title が空なら 422 を返す" do
    assert_no_difference "Book.count" do
      post "/api/v1/books",
        params: { book: { title: "", author: "著者", status: "unread" } },
        as: :json
    end
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert body["errors"].any?
  end

  test "登録: author が空なら 422 を返す" do
    assert_no_difference "Book.count" do
      post "/api/v1/books",
        params: { book: { title: "本", author: "", status: "unread" } },
        as: :json
    end
    assert_response :unprocessable_entity
  end

  # --- PATCH /api/v1/books/:id ---

  test "更新: ステータス変更なら 200 と更新後データを返す" do
    book = books(:unread_book)
    patch "/api/v1/books/#{book.id}",
      params: { book: { status: "reading" } },
      as: :json
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal "reading", body["status"]
  end

  test "更新: 存在しない ID なら 404 を返す" do
    patch "/api/v1/books/0",
      params: { book: { status: "reading" } },
      as: :json
    assert_response :not_found
  end

  test "更新: 無効な値なら 422 を返す" do
    book = books(:unread_book)
    patch "/api/v1/books/#{book.id}",
      params: { book: { title: "" } },
      as: :json
    assert_response :unprocessable_entity
  end

  # --- DELETE /api/v1/books/:id ---

  test "削除: 存在する ID なら 204 を返す" do
    book = books(:unread_book)
    assert_difference "Book.count", -1 do
      delete "/api/v1/books/#{book.id}"
    end
    assert_response :no_content
  end

  test "削除: 存在しない ID なら 404 を返す" do
    delete "/api/v1/books/0"
    assert_response :not_found
  end
end
