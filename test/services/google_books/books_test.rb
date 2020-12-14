require "test_helper"

class BooksTest < ActiveSupport::TestCase
  test "formats a book query for author and title" do
    params = { author: "Bakeley", title: "Goblinproofing One's Chicken Coop" }
    result = GoogleBooks::Books.format_author_and_title_query(params)
    expected_result = "+inauthor:bakeley+intitle:goblinproofing+intitle:one's+intitle:chicken+intitle:coop"
    assert_equal expected_result, result
  end

  test "format returns empty string for empty params" do
    result = GoogleBooks::Books.format_author_and_title_query({})
    assert_equal "", result
  end

  test "can create book objects" do
    attrs = {
      "volumeInfo"=>{
        "title"=>"Strangers Have the Best Candy",
        "authors"=>["Margaret Meps Schulte"],
        "publishedDate"=>"2015-03-25",
        "description"=>"'The antidote to cynicism.' A humorous nonfiction book about the lessons, adventures, and lifelong friendships that come from talking to strangers. Through the author's experiences, the book makes the case that talking to strangers is good for you. Includes over 100 original pen-and-ink illustrations by the author."
      },
      "accessInfo"=>{
        "epub"=>{
          "isAvailable"=>true
        }
      }
    }
    book = GoogleBooks::Books.new(attrs)
    assert book.author
    assert book.title
    assert book.description
    assert book.publish_date
    assert book.ebook
  end

  test "searches a book title" do
    VCR.use_cassette("service_book_search_query") do
      params = { author: "Sambuchino", title: "How to Survive a Garden Gnome Attack" }
      books = GoogleBooks::Books.search(params)
      assert books.first.is_a?(GoogleBooks::Books)
    end
  end

  test "can create multiple books from one response" do
    VCR.use_cassette("multiple_books_query") do
      params = { title: "Fashion Cats" }
      response = GoogleBooks::Books.search(params)
      books = GoogleBooks::Books.search(params)
      assert books.count > 1
    end
  end

  test "error raises Exceptions::QueryError" do
    VCR.use_cassette("empty_query") do
      assert_raises Exceptions::QueryError do
        result = GoogleBooks::Books.search({})
        assert_equal 400, result.last[:status]
        assert result.last[:message]
      end
    end
  end
end
