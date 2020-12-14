class SearchesController < ApplicationController
  include Response

  def create
    @books = GoogleBooks::Books.search(search_params)
    json_response(@books, :ok)
  end

  private

  def search_params
    params.require(:attributes).permit(:author, :title)
  end
end
