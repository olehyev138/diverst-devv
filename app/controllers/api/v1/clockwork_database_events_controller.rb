class Api::V1::ClockworkDatabaseEventsController < DiverstController
  def action_map(action)
    case action
    when :update then 'update'
    else nil
    end
  end
end
