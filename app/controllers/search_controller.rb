class SearchController < ApplicationController
  def index
    @result = Researcher.all
  end
end
