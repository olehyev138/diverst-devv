module FieldsHelper
  def required_class(field)
    !field.required ? "hidden" : ""
  end
end
