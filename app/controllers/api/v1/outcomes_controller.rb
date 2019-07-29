class Api::V1::OutcomesController < DiverstController
  def payload
    params
      .require(:outcome)
      .permit(
        :name,
        :group_id
      )
  end
end
