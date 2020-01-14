class Api::V1::UpdatesController < DiverstController
  def payload
    params.require(klass.symbol).permit(
      klass.attribute_names - ['id', 'updated_at', 'created_at'] + [
          field_data_attributes: [
              :id,
              :data,
              :field_id,
          ],
      ]
    )
  end
end
