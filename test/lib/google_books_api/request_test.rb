require "test_helper"

class RequestTest < ActiveSupport::TestCase
  test "returns book results" do
    VCR.use_cassette("request_book_search_query") do
      query = "+intitle:the+intitle:do+intitle:it+intitle:yourself+intitle:lobotomy"
      response = Request.books_search(query, nil, nil)
      assert_equal 200, response.code
      assert response["totalItems"] > 0
    end
  end

  test "error with empty query" do
    VCR.use_cassette("empty_query") do
      query = ""
      response = Request.books_search(query, nil, nil)
      assert response[:errors]
      assert_equal 400, response[:errors][:status]
      assert response[:errors][:message]
    end
  end
end
