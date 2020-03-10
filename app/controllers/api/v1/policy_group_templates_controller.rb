class Api::V1::PolicyGroupTemplatesController < DiverstController
  def payload
    params.require(klass.symbol).permit(
        klass.attribute_names - ['id', 'created_at', 'updated_at', 'enterprise_id', 'manage_all']
      )
  end
end
