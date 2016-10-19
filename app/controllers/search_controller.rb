class SearchController < ApplicationController
  def index
    if !params[:search].blank?
      @result = execute_query(params[:search])
    else
      @result = nil
    end
  end

  private

    def execute_query(sparql)
      Researcher.query(sparql)
    end

end
