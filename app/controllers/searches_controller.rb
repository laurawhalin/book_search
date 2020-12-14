class SearchesController < ApplicationController
  include Response
  include ErrorHandler

  def create
    raise Exceptions::QueryError unless params_present?(search_params)

    search = Search.find_or_create_by(search_params)
    search ? search.update(search_params) : search.save

    @books = GoogleBooks::Books.search(search_params)
    json_response(@books, :ok)
  end

  private

  def search_params
    params.require(:attributes).permit(:author, :title)
  end

  def params_present?(search_params)
    search_params.values.map(&:present?).uniq.first
  end
end
