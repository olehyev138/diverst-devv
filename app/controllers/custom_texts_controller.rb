class CustomTextsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_custom_text
  after_action :verify_authorized

  layout 'global_settings'

  def edit
    authorize current_user.enterprise, :manage_branding?
    visit_page('Custom Text Editor')
  end

  def update
    authorize current_user.enterprise, :manage_branding?
    if @custom_text.update(custom_texts_params)
      flash[:notice] = 'Your texts were updated'
      track_activity(@custom_text, :update)
    else
      flash[:alert] = 'Your texts were not updated. Please fix the errors'
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
