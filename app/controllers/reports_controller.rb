class ReportsController < ApplicationController
  def index
  end

  def publications_by_year
    @result = Researcher.publications_by_year

    @chart =  @result
  end
end
