class Api::V1::SegmentsController < DiverstController
  def payload
    params
      .require(:segment)
      .permit(
        :name,
        :active_users_filter,
        :limit,
        :parent_id,
        :owner_id,
        field_rules_attributes: [
          :id,
          :field_id,
          :operator,
          :_destroy,
          :data
        ],
        order_rules_attributes: [
          :id,
          :field,
          :operator,
          :_destroy,
        ],
        group_rules_attributes: [
          :id,
          :operator,
          :_destroy,
          group_ids: []
        ]
      )
  end
end
