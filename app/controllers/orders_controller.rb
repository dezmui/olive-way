class OrdersController < ApplicationController
  before_action :require_log_in

  def index
    @orders = Order.checked_out current_user
  end

  def checkout
      @shipping_cost = 10
      @order_objects = OrderObject.pending(current_user);
      @total_price = 0
      @order_objects.find_each do |order_object|
          @total_price += order_object.price
          if order_object.suit != nil
            @shipping_cost = 25
          end
      end
  end

  def new
    @shipping_cost = 10
    @order = Order.new
    @order.user = current_user
    @order_objects = OrderObject.pending(current_user);
    @order.total_price = 0
    @order_objects.find_each do |order_object|
        @order.total_price += order_object.price
        if order_object.suit != nil
          @shipping_cost = 25
        end
    end
  end

  def create
    @shipping_cost = 10
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.user.update_attributes(address_params)
      if @order.user.save
      else
        if @order.user.errors.any?
          flash[:error] = @order.user.errors.full_messages[0]
        end
        redirect_to new_order_path
        return
      end
    else
      if @order.user.errors.any?
        flash[:error] = @order.user.errors.full_messages[0]
      end
      redirect_to new_order_path
      return
    end

    @order_objects = OrderObject.pending(current_user);

    @order_objects.find_each do |order_object|
      if order_object.suit != nil
        @shipping_cost = 25
        if order_object.suit.quantity <= 0
          flash[:error] = "This item is out of stock!"
          redirect_to checkout_path
          return
        end
      else
        if order_object.accessory.quantity <= 0
          flash[:error] = "This item is out of stock!"
          redirect_to checkout_path
          return
        end
      end
    end

    if @order.save!
      @order_objects.find_each do |order_object|
        order_object.checked_out!
        order_object.order = @order
        order_object.suit != nil ? order_object.suit.decrement(:quantity)
        : order_object.accessory.decrement(:quantity)
        order_object.save
      end
      flash[:success] = "Your Order was placed successfully!"
    else
      flash[:error] = @order.errors.full_messages[0]
      redirect_to checkout_path
      return
    end

    customer = Stripe::Customer.create(
    :email => stripe_params["stripeEmail"],
    :source => stripe_params["stripeToken"],
    )

    charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @order.total_price,
    :description => 'Rails Stripe customer',
    :currency    => 'aud'
    )
    redirect_to orders_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to checkout_path
  end

  private

  def address_params
    params.require(:user).permit(
    shipping_address_attributes: [:first_name, :last_name,
      :postcode, :suburb, :company, :state, :street, :country, :phone,
      :address_type, :id],
    billing_address_attributes: [:first_name, :last_name,
      :postcode, :suburb, :company, :state, :street, :country, :phone,
      :address_type, :id])
  end

  def order_params
    params.require(:order).permit(:total_price)
  end

  def stripe_params
    params.permit :stripeEmail, :stripeToken
  end
end
