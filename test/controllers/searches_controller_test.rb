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

  test "#create saves a new search" do
    assert_difference "Search.count", 1 do
      VCR.use_cassette("service_book_search_query") do
        post searches_url, params: @params
      end
    end
  end

  test "#create updates refreshed_at of an existing search" do
    assert_difference "Search.count", 0 do
      VCR.use_cassette("update_existing_search") do
        existing_search = Search.first
        refresh_date = existing_search.refreshed_at
        params = {
          attributes: {
            author: existing_search.author,
            title: existing_search.title
          }
        }

        post searches_url, params: params
        updated_search = existing_search.reload
        refute_equal refresh_date, updated_search.refreshed_at
      end
    end
  end

  test "#create 400 status for empty query" do
    VCR.use_cassette("search_errors") do
      params = { attributes: { author: "", title: "" } }
      post searches_url, params: params
      assert 400, response.status
      assert "Missing query.", response.body
    end
  end
end
