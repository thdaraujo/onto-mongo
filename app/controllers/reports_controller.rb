class ReportsController < ApplicationController
  def index
  end

  def publications_by_year
    @result = Researcher.publications_by_year
    @chart =  @result
  end

  def publications_by_country
    @result = Researcher.publications_by_country
    @chart =  @result
  end

end
