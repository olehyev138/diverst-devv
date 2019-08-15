class Api::V1::FieldsController < DiverstController
  private

  # Override klass when params are passed to load field subclass given type param
  # Fallback to super if params not passed (ie: index)
  #  ex: params: { field: { type: 'TextField '}} => loads TextField subclass
  def klass
    params[:field] ? payload[:type].classify.constantize : super
  end

  def payload
    params
      .require(:field)
      .permit(
        :type,
        :title
      )
  end
end
