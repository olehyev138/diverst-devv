# A Module to define controller actions for Models with `has_many :updates`
module Api::V1::Concerns::Updatable
  extend ActiveSupport::Concern

  def updates
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Update.index(self.diverst_request, params.except(:id).permit!, base: item.updates)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update_prototype
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Update.create_prototype(item)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create_update
    params[:update] = update_payload
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 201, json: Update.build(self.diverst_request, params, base: item.updates)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def update_payload
    params
        .require(:update)
        .permit(
            :report_date,
            :comments,
            field_data_attributes: [
                :id,
                :data,
                :field_id,
            ],
          )
  end
end