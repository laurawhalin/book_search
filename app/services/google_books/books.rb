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

    def self.search(params, filter, sort)
      query    = format_author_and_title_query(params)
      filter   = format_filter_query(filter) if filter
      sort     = format_sort_query(sort) if sort
      response = Request.books_search(query, filter, sort)

      # Errors are rendered in the error_handler concern.
      # To-Do: Could raise other errors depending on status.
      raise Exceptions::QueryError, response[:errors][:message] if response[:errors]

      response.fetch("items", []).map do |book|
        Books.new(book)
      end
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

    def self.format_filter_query(filter)
      "&filter=ebooks" if filter[:ebook] == "true"
    end

    def self.format_sort_query(filter)
      "&orderBy=#{filter.keys.first}"
    end
  end
end
