class Api::V1::MentoringSessionsController < DiverstController
  def payload
    params
      .require(klass.symbol)
      .permit(
        klass.attribute_names - ['id', 'created_at', 'updated_at', 'enterprise_id'] + [
          mentoring_interest_ids: [],
          user_ids: [],
          resource_ids: []
        ]
      )
  end
end
