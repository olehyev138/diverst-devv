class Api::V1::RegionsController < DiverstController
  def group_regions
    group = Group.find(params[:group_id])
    base_authorize(group)

    render status: 200, json: klass.index(self.diverst_request, params.permit!.merge({ parent_id: group.id })), family: true
  rescue => e
    raise BadRequestException.new(e.message)
  end

  private

  def payload
    params
    .require(klass.symbol)
    .permit(
      :name,
      :short_description,
      :description,
      :home_message,
      :parent_id,
      child_ids: [],
      #:position,
      #:private
    )
  end
end
