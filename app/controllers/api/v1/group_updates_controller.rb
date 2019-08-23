class Api::V1::GroupUpdatesController < DiverstController
  def payload
    params.require(klass.symbol).permit(
      klass.attribute_names - ['id', 'updated_at', 'enterprise_id']
    )
  end
end
