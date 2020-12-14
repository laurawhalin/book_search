class SearchesController < ApplicationController
  include Response

  def create
    search = Search.find_or_create_by(search_params)
    search ? search.update(search_params) : search.save

    @books = GoogleBooks::Books.search(search_params)
    json_response(@books, :ok)
  end

  private

  def search_params
    params.require(:attributes).permit(:author, :title)
  end
end
