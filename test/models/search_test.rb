require "test_helper"

class SearchTest < ActiveSupport::TestCase
  test "creates a search" do
    assert_difference "Search.count", 1 do
      attrs = {
        title: "How to Teach Physics to Your Dog",
        author: "Chad Orzel"
      }
      Search.create(attrs)
    end
  end

  test "requires either title or author to create a search" do
    assert_difference "Search.count", 0 do
      attrs = { author: nil, title: nil }
      Search.create(attrs)
    end
  end

  test "adds refreshed_at when record is saved" do
    attrs = {
      title: "People Who Don't Know They're Dead",
      author: "Gary Leon Hill"
    }
    search = Search.create(attrs)
    assert search.refreshed_at
  end

  test "does not require both title and author to create a search" do
    assert_difference "Search.count", 2 do
      attrs = { author: "Fred", title: nil }
      Search.create(attrs)

      attrs = { author: nil, title: "Treasures" }
      Search.create(attrs)
    end
  end

  test "saves title and author in downcased alphabetized string" do
    attrs = {
      title: "Crocheting Adventures with Hyperbolic Planes" ,
      author: "Taimina, Daina"
    }
    search = Search.create(attrs)
    assert_equal "adventures crocheting hyperbolic planes with", search.title
    assert_equal "daina taimina", search.author
  end

  test "only stores unique title/author pairs" do
    existing_search = Search.last
    assert_difference "Search.count", 0 do
      attrs = {
        author: existing_search.author,
        title: existing_search.title
      }
      result = Search.create(attrs)
      assert "Title/author pairing already exists", result
    end
  end
end
