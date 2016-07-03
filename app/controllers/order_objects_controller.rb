class OrderObjectsController < ApplicationController
  def new
    @order_object = OrderObject.new
    @order_object.measurement ||= Measurement.new
  end

  def create
    @order_object = OrderObject.new(order_object_params)
    @order_object.status = 0
    if @order_object.save
      flash[:notice] = 'Success! New Item Added to Cart!'
    else
      flash[:alert] = "Oops! Invalid input. #{@offer.errors.full_messages.join('. ')}"
    end
    redirect_to root_path
  end

  def destroy
  end

  private

  def order_object_params
    params.require(:order_object).permit(:jacket_lapels, :jacket_vents,
      :jacket_buttons, :status, measurement_attributes: [:shoulder, :half_chest,
        :half_jacket_waist, :half_hem, :back_length, :sleeve_outstem, :bicep,
        :pant_outseam, :half_pant_waist, :half_bottom, :crotch, :thigh, :hip])
  end
end