
class DesignersController < ApplicationController
 
  def index
    @role = Role.find_by_name("designer")
    @designers = @role.users
  end

  def show  
  	@designer = User.find(params[:id])
  	

  	@news = News.where('state = ?',true)
    
   
    if(current_user)
    	 @orders = Order.where("user_id = ? && state = 'complete'",@designer.id).includes({:order_items => :variant})
   
    @products = []

    @orders.each do |order|
        order.order_items.each_with_index do |item, i|
            unless @products.include?(item.variant.product)
              @products << item.variant.product
            end
            
        end

    end
    if(@products != [])
    @products = @products.paginate(:page => pagination_page, :per_page => 8)
    end    
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
    	
    	@orders = Order.where("user_id = ? && state = 'complete'",@designer.id).includes({:order_items => :variant})
 
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
     
    else
    	@count = Rating.where('designer_id = ?',@designer.id).count.to_s
    	@avg_rating = Rating.where('designer_id = ?',@designer.id).sum(:score).to_f/@count.to_f
    	
    end
    @prts = Product.none
    @prts = @designer.products.paginate(:page => pagination_page, :per_page => 8)
    
    render :action => 'index_designer'
    #render :text => @prts.inspect
  end
end
