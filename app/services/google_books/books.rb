module GoogleBooks
  class Books
    attr_reader :author,
                :description,
                :ebook,
                :error,
                :publish_date,
                :title

    def initialize(attrs = {})
      volume_info   = attrs["volumeInfo"]
      access_info   = attrs["accessInfo"]
      @author       = volume_info.fetch("authors", "").join(",")
      @description  = volume_info.fetch("description", "")
      @ebook        = access_info.dig("epub", "isAvailable")
      @publish_date = volume_info.fetch("publishedDate", "")
      @title        = volume_info.fetch("title", "")
    end

    def self.search(params)
      query    = format_author_and_title_query(params)
      response = Request.books_search(query)
      books    = response.fetch("items", []).map do |book|
        Books.new(book)
      end

      [books, response[:errors]]
    end

    # convert query params into format Google Books API expects
    def self.format_author_and_title_query(params)
      query = ""

      params.each_key do |key|
        query_string = params[key].split(" ").map do |word|
          "+in#{key}:".concat(word.downcase)
        end.join("")
        query.concat(query_string)
      end

      query
    end
  end
end
