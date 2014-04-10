class DesignersController < ApplicationController
 
  def show
  	@designer = User.find(params[:id])
  	#@designer_products = @designer.products

  	@news = News.where('state = ?',true)
    #@orders = current_user.orders.where('state = complete', :include => {:order_items => {:varients => :product}})
   
    if(current_user)
    	 @orders = Order.where("user_id = ? && state = 'complete'",@designer.id).includes({:order_items => :variant})
    #@products = Product.all
    @products = []

    @orders.each do |order|
        order.order_items.each_with_index do |item, i|
            unless @products.include?(item.variant.product)
              @products << item.variant.product
            end
            
        end

    end

    @products = @products.paginate(:page => pagination_page, :per_page => 8)
    
    	@user = current_user
    @ratings = current_user.ratings
    if @ratings == []
      @rating = Rating.new(:id => 0,:score => 0, :designer_id => @designer.id)
    else
    	@rating = current_user.ratings.where('designer_id = ?', @designer.id)
    	if(@rating == nil)
    		Rating.new(:id => 0,:score => 0, :designer_id => @designer.id)
    	else
    		@rating = current_user.ratings.where('designer_id = ?', @designer.id).first
    	end
    end
    	
    else
    	#redirect_to login_url
    	@orders = Order.where("user_id = ? && state = 'complete'",@designer.id).includes({:order_items => :variant})
   # @products = Product.all
    @products = []

    @orders.each do |order|
        order.order_items.each_with_index do |item, i|
            unless @products.include?(item.variant.product)
              @products << item.variant.product
            end
            
        end

    end

    @products = @products.paginate(:page => pagination_page, :per_page => 8)
    
    	@user = current_user

   
    end
     @ratings = Rating.where('designer_id = ?',@designer.id)
    if @ratings == []
    	@avg_rating = 0
    	@count = 0
      #@rating = Rating.new(:id => 0,:score => 0, :designer_id => @designer.id)
    else
    	@count = Rating.where('designer_id = ?',@designer.id).count.to_s
    	@avg_rating = Rating.where('designer_id = ?',@designer.id).sum(:score).to_f/@count.to_f
    	
    end
    render :action => 'index_designer'
  end
end
