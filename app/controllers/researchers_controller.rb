class ResearchersController < ApplicationController
  def index
    @result = Researcher.page params[:page]
  end

  def show
    @result = Researcher.find(id: params[:id])
  end
end
