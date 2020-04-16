class ItemOrdersController <ApplicationController

  def show
    @item_order = ItemOrder.find(item_order_params[:item_order_id])
  end

  def update
    @item_order = ItemOrder.find(item_order_params[:item_order_id])
    if item_order_params[:type] == "fulfill"
      @item_order.update(:status => "Fulfilled")
      total_items = @item_order.order.item_orders
      fulfilled_items = total_items.where("status = 'Fulfilled'")
      if total_items.count == fulfilled_items.count
        @item_order.order.update(:status => "Packaged")
      end
    end
  end

  private

  def item_order_params
    params.permit(:item_order_id, :type)
  end
end
