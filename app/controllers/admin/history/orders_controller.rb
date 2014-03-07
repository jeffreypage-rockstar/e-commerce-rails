class Admin::History::OrdersController < Admin::BaseController
  # GET /admin/history/orders
  def index
    @orders = Order.find_finished_order_grid(params).paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  # GET /admin/history/orders/1
  def show
    # if current_user.designer?
    #   @designer_products = product.where(["user_id=?",current_user.id]).map { |e| e.id  }
    #   @order = Order.includes([:ship_address, :invoices,
    #                          {:shipments => :shipping_method},
    #                          {:order_items => [
    #                                             {:variant => [:product, :variant_properties]}]
    #                           }]).find_by_number(params[:id])
    # else
      @order = Order.includes([:ship_address, :invoices,
                             {:shipments => :shipping_method},
                             {:order_items => [
                                                {:variant => [:product, :variant_properties]}]
                              }]).find_by_number(params[:id])
    # end
  end

end
