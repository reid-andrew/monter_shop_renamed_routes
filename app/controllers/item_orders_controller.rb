class ItemOrdersController <ApplicationController

  def show
    @item_order = ItemOrder.find(item_order_params[:item_order_id])
  end

  def update
    @item_order = ItemOrder.find(item_order_params[:item_order_id])
    if item_order_params[:type] == "fulfill"
      @item_order.update(:status => "Fulfilled")
      if @item_order.order.item_orders.count == @item_order.order.item_orders.where("status = 'Fulfilled'").count
        @item_order.order.update(:status => "Packaged")
      end
    end
  end

  private

  def item_order_params
    params.permit(:item_order_id, :type)
  end
end
