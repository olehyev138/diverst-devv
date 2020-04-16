class Api::V1::ActivitiesController < DiverstController
  private def model_map(model)
    case model
    when NilClass then current_user.enterprise
    else nil
    end
  end

  private def action_map(action)
    case action
    when :export_csv then 'export_logs'
    else nil
    end
  end
end
