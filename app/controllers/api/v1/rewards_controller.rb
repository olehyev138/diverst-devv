class Api::V1::RewardsController < DiverstController
  def action_map(action)
    case action
    when :create then 'create'
    else nil
    end
  end
end
