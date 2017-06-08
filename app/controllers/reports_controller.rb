class ReportsController < ApplicationController

  def index
  end

  def researchers
    @result = Researcher.page params[:page]
  end
end
