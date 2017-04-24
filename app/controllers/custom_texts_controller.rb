class CustomTextsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_custom_text
  after_action :verify_authorized

  layout 'global_settings'

  def edit
    authorize current_user.enterprise
  end

  def update
    authorize current_user.enterprise
    if @custom_text.update(custom_texts_params)
      flash[:notice] = "Your texts were updated"
    else
      flash[:alert] = "Your texts were not updated. Please fix the errors"
    end
    render :edit
  end

  protected
  def set_custom_text
    @custom_text = current_user.enterprise.custom_text
  end

  def custom_texts_params
    params.require(:custom_text).permit(CustomText.keys)
  end
end
