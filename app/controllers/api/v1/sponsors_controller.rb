class Api::V1::SponsorsController < DiverstController
  private

  def model_map(model)
    current_user.enterprise
  end

  def action_map(action)
    case action
    when :create, :update, :destroy then 'update_branding'
    else nil
    end
  end
end
