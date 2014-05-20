class Admin::History::OrdersController < Admin::BaseController
  # GET /admin/history/orders
  def index
    if current_user.designer?
      product_ids = current_user.products.map(&:id)
      @orders = Order.joins(:order_items,"LEFT JOIN variants ON variants.id = order_items.variant_id").find_finished_order_grid(params).paginate(:page => pagination_page, :per_page => pagination_rows).where("variants.product_id IN (?)",product_ids).group("orders.id")
    else
      @orders = Order.find_finished_order_grid(params).paginate(:page => pagination_page, :per_page => pagination_rows)
    end
  end

  # GET /admin/history/orders/1
  def show
    if current_user.designer?      
      product_ids = current_user.products.map(&:id)      
      @order = Order.includes([:ship_address, :invoices,
                             {:shipments => :shipping_method},
                             {:order_items => [
                                                {:variant => [:product, :variant_properties]}]
                              }]).where("products.id IN (?)",product_ids).find_by_number(params[:id])
    else
      @order = Order.includes([:ship_address, :invoices,
                             {:shipments => :shipping_method},
                             {:order_items => [
                                                {:variant => [:product, :variant_properties]}]
                              }]).find_by_number(params[:id])
    end
  end

end
