class Api::V1::UpdatesController < DiverstController
  def prototype
    item = if params[:group_id].present?
      Group.find(params[:group_id])
    elsif params[:initiative_id].present?
      Initiative.find(params[:initiative_id])
    else
      raise BadRequestException.new('Need either a group_id or an initiative_id')
    end

    base_authorize(klass)

    render status: 200, json: klass.create_prototype(item)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    type, id =
        if params[:group_id].present?
          ['Group', params[:group_id]]
        elsif params[:initiative_id].present?
          ['Initiative', params[:initiative_id]]
        else
          raise BadRequestException.new('Need either a group_id or an initiative_id')
        end

    params[:update][:updatable_type] = type
    params[:update][:updatable_id] = id

    super
  end

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

  def model_map(model)
    super if model.updatable_type == 'Group'
  end
end
