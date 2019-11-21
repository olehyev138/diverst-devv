class Api::V1::UserRolesController < DiverstController

  def payload
    params
      .require(klass.symbol)
      .permit(
        :role_name,
        :role_type,
        :priority,
     )
  end
end
