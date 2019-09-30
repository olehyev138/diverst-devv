class Api::V1::OutcomesController < DiverstController
  def payload
    params
      .require(:outcome)
      .permit(
        :name,
        :group_id,
        pillars_attributes: [
          :id,
          :name,
          :value_proposition,
          :_destroy,
        ]
      )
  end
end
