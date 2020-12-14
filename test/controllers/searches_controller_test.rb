require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @params = {
      attributes: {
        author: "Sambuchino",
        title: "How to Survive a Garden Gnome Attack"
      }
    }
  end

  test "search #create returns books by title and author" do
    VCR.use_cassette("service_book_search_query") do
      post searches_url, params: @params
      assert_response :success
      assert JSON.parse(response.body).count > 0
    end
  end
end
