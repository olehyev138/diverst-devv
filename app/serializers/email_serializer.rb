class EmailSerializer < ApplicationRecordSerializer
  attributes :variables

  def serialize_all_fields
    true
  end

  def variables
    object.vars.map do |var|
      join_vars = EmailVariableSerializer.new(var).as_json
      real_vars = EnterpriseEmailVariableSerializer.new(var.enterprise_email_variable).as_json

      join_vars.merge(real_vars)
    end
  end
end
