module Api::V1::Concerns::DefinesFields
  extend ActiveSupport::Concern

  def fields
    item = klass.find(params[:id])
    base_authorize(item)

    response = Field.index(self.diverst_request, params.except(:id).permit!, base: item.fields)
    response = { page: response.as_json } if diverst_request.minimal

    render status: 200, json: response, **diverst_request.options
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create_field
    if (['SelectField', 'CheckboxField'].include? field_payload[:type]) && field_payload[:options_text].strip.empty?
      raise InvalidInputException
    end

    params[:field] = field_payload
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 201, json: Field.build(self.diverst_request, params, base: item.fields)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def field_payload
    params
        .require(:field)
        .permit(
            :type,
            :title,
            :options_text,
            :min,
            :max,
            :show_on_vcard,
            :alternative_layout,
            :private,
            :required,
            :add_to_member_list,
          )
  end
end
