class Api::V1::FieldDataController < DiverstController
  # TODO:
  #  - write a strict policy for updating field data
  #  - field_data will be auto generated therefore:
  #     - field_id & user_id will 'constant' & not accepted as params
  #     - creating field_data through controller will not possible

  def update_field_data
    # iterate through each field_datum & update
    payload[:field_data].each do |field_datum_attrs|
      field_datum = FieldData.find(field_datum_attrs[:id])

      unless field_datum.update_attributes(field_datum_attrs)
        raise InvalidInputException.new({
                                            message: field_datum.errors.full_messages.first,
                                            attribute: field_datum.errors.messages.first.first
                                        })
    end

    # if we made it here - were good
    render status: 204, json: {}
    end
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
          :data
        ],
      )
  end
end
