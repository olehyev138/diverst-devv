class Api::V1::RegionsController < DiverstController
  private

  def payload
    params
    .require(klass.symbol)
    .permit(
      :name,
      :short_description,
      :description,
      :home_message,
      :private,
      :parent_id,
      :position,
      child_ids: [],
    )
  end
end
