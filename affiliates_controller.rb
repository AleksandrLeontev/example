#app/controllers/affiliates_controller.rb
class AffiliatesController < ApplicationController
  authorize_resource
  before_action :load_affiliate, except: :index

  def index
    render json: Affiliate.order(:created_at)
  end

  def show
    render json: @affiliate
  end

  def update
    result = Affiliates::UpdateService.call(object: @affiliate, params: update_params)
    respond_with_service(result)
  end

  def approve
    result = Affiliates::ApproveService.call(object: @affiliate, user: current_user)
    respond_with_service(result)
  end

  private

  def load_affiliate
    @affiliate = Affiliate.find(params[:id])
  end

  def update_params
    params.require(:affiliate).permit(:participation_start, :participation_end)
  end
end
