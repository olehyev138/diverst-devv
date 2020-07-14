class Api::V1::FieldsController < DiverstController
  private

  # Override klass when params are passed to load field subclass given type param
  # Fallback to super if params not passed (ie: index)
  #  ex: params: { field: { type: 'TextField '}} => loads TextField subclass
  def klass
    params[:field].presence ? payload[:type].classify.constantize : super
  end

  def payload
    params
      .require(:field)
      .permit(
        :field_definer_id,
        :field_definer_type,
        :type,
        :title,
        :options_text,
        :min,
        :show_on_vcard,
        :alternative_layout,
        :private,
        :required,
        :add_to_member_list,
        :position
      )
  end
end
