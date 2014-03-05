class DesignersController < ApplicationController
  def index
  end

  def show
  	@designer = User.find(params[:id])
  	@designer_products = @designer.products
  end
end
