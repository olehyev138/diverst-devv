class CustomTextsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_custom_text
  after_action :verify_authorized
  after_action :visit_page, only: [:edit]

  layout 'global_settings'

  def edit
    authorize current_user.enterprise, :manage_branding?
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'edit'
      'Custom Text Editor'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
