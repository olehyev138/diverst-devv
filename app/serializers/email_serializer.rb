class EmailSerializer < ApplicationRecordSerializer
  attributes_with_permission :variables, if: :singular_action?

  def serialize_all_fields
    true
  end

  def variables
    object.email_variables.reduce({}) do |sum, var|
      join_vars = EmailVariableSerializer.new(var).as_json
      real_vars = EnterpriseEmailVariableSerializer.new(var.enterprise_email_variable).as_json

      sum.merge({ var.enterprise_email_variable.key => join_vars.merge(real_vars) })
    end
  end
end
