class Api::V1::FieldDataController < DiverstController
  def update_field_data
    # iterate through each field_datum & update
    payload[:field_data].each do |field_datum_attrs|
      field_datum = FieldData.find(field_datum_attrs[:id])
      raise InvalidInputException unless field_datum.update_attributes(field_datum_attrs)
    end

    # if we made it here - were good
    render status: 204, json: {}
  end

  private

  def klass
    FieldData
  end

  def payload
    params
      .require(:field_data)
      .permit(
        field_data: [
          :id,
          :user_id,
          :field_id,
          :data
        ],
      )
  end
end
