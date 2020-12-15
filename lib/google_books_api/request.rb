class Request
  BASE_URI = "https://www.googleapis.com/books/v1/volumes".freeze
  FIELD_LIMITS = "&printType=books&projection=lite".freeze

  def self.books_search(query, filter, sort)
    response = HTTParty.get("#{BASE_URI}?q=#{query}#{FIELD_LIMITS}#{filter}#{sort}&key=#{ENV["google_books_api_key"]}")
    response.code == 200 ? response : error(response)
  end

  def self.error(response)
    { errors: { status: response.code, message: response["error"]["message"] } }
  end
end
