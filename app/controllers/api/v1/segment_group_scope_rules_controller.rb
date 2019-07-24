class Api::V1::SegmentGroupScopeRulesController < DiverstController
  def payload
    params
      .require(klass.symbol)
      .permit(
        :segment_id,
        :operator,
        group_ids: []
      )
  end
end
