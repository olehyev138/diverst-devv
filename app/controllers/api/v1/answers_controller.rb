class Api::V1::AnswersController < DiverstController
  private def action_map(action)
    case action
    when :create then 'create'
    else nil
    end
  end
end
