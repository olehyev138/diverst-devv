module Api::V1::Concerns::DefinesFields
  extend ActiveSupport::Concern

  def fields
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Field.index(self.diverst_request, params.except(:id).permit!, base: item.fields)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create_field
    params[:field] = field_payload
    base_authorize(klass)
    item = klass.find(params[:id])

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
            )
  end
end
