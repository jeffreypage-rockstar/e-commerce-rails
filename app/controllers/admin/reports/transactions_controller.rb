class Admin::Reports::TransactionsController < Admin::Reports::BaseController
 
  def index
  	@transactions = Transaction.all
  	@invoices = []
  	@accounting_adjustments = []
  	@transactions.each do |transaction|
  		@trans_type = transaction.batch.batchable
      @products = []
  		if(@trans_type.class.to_s == "Invoice")
  			
      
        @trans_type.order.order_items.each_with_index do |item, i|
            unless @invoices.include?(@trans_type)
              if(item.variant.product.user==current_user && current_user.designer?)
                @invoices << @trans_type
              elsif(current_user.admin? || current_user.super_admin?)
                @invoices << @trans_type
              end
            end
            
        end

       
  		elsif(@trans_type.class.to_s == "AccountingAdjustment")
  			@accounting_adjustments << @trans_type
  		end
  	end
  	
  end

  def show
    
  end

end
