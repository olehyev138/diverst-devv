module FieldsHelper
  def required_class(field)
    !field.required ? 'hidden' : ''
  end

  def field_error_class(resource, field)
    field_errors(resource, field).present? ? 'field_with_errors' : ''
  end

  def field_errors(resource, field)
    resource.errors[field.title.parameterize.underscore.to_sym].join(', ')
  end
end
