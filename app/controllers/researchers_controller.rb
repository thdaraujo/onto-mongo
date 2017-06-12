class ResearchersController < ApplicationController
  def index
    @result = Researcher.order_by(name: :asc).page(params[:page])
  end

  def show
    @result = Researcher.find(id: params[:id])
  end
end
