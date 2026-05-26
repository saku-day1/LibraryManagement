require "test_helper"

class BookTest < ActiveSupport::TestCase
  # --- 正常系 ---

  test "title・author・status があれば有効" do
    book = Book.new(title: "テスト本", author: "著者", status: "unread")
    assert book.valid?
  end

  test "任意フィールドがすべて nil でも有効" do
    book = Book.new(title: "テスト本", author: "著者", status: "unread",
                    isbn: nil, cover_image_url: nil, rating: nil,
                    memo: nil, started_at: nil, completed_at: nil)
    assert book.valid?
  end

  test "rating が 1〜5 の整数なら有効" do
    (1..5).each do |n|
      book = Book.new(title: "本", author: "著者", status: "unread", rating: n)
      assert book.valid?, "rating=#{n} は有効なはず"
    end
  end

  test "isbn が 13 桁なら有効" do
    book = Book.new(title: "本", author: "著者", status: "unread", isbn: "9784873115658")
    assert book.valid?
  end

  test "isbn が空文字列なら有効" do
    book = Book.new(title: "本", author: "著者", status: "unread", isbn: "")
    assert book.valid?
  end

  # --- 異常系: title ---

  test "title が空なら無効" do
    book = Book.new(title: "", author: "著者", status: "unread")
    assert_not book.valid?
    assert_includes book.errors[:title], "can't be blank"
  end

  test "title が 256 文字以上なら無効" do
    book = Book.new(title: "a" * 256, author: "著者", status: "unread")
    assert_not book.valid?
    assert book.errors[:title].any?
  end

  test "title が 255 文字なら有効" do
    book = Book.new(title: "a" * 255, author: "著者", status: "unread")
    assert book.valid?
  end

  # --- 異常系: author ---

  test "author が空なら無効" do
    book = Book.new(title: "本", author: "", status: "unread")
    assert_not book.valid?
    assert_includes book.errors[:author], "can't be blank"
  end

  test "author が 101 文字以上なら無効" do
    book = Book.new(title: "本", author: "a" * 101, status: "unread")
    assert_not book.valid?
    assert book.errors[:author].any?
  end

  # --- 異常系: isbn ---

  test "isbn が 12 桁なら無効" do
    book = Book.new(title: "本", author: "著者", status: "unread", isbn: "978487311565")
    assert_not book.valid?
    assert book.errors[:isbn].any?
  end

  test "isbn が 14 桁なら無効" do
    book = Book.new(title: "本", author: "著者", status: "unread", isbn: "97848731156580")
    assert_not book.valid?
    assert book.errors[:isbn].any?
  end

  # --- 異常系: rating ---

  test "rating が 0 なら無効" do
    book = Book.new(title: "本", author: "著者", status: "unread", rating: 0)
    assert_not book.valid?
    assert book.errors[:rating].any?
  end

  test "rating が 6 なら無効" do
    book = Book.new(title: "本", author: "著者", status: "unread", rating: 6)
    assert_not book.valid?
    assert book.errors[:rating].any?
  end

  test "rating が小数なら無効" do
    book = Book.new(title: "本", author: "著者", status: "unread", rating: 3.5)
    assert_not book.valid?
    assert book.errors[:rating].any?
  end
end
