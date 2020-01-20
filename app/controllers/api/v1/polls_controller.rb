class Api::V1::PollsController < DiverstController
  include Api::V1::Concerns::DefinesFields

  def payload
    params.require(klass.symbol).permit(
      :title,
      :description,
      :status,
      :initiative_id,
      :owner_id,
      group_ids: [],
      segment_ids: [],
      fields_attributes: [
        :id,
        :title,
        :_destroy,
        :gamification_value,
        :show_on_vcard,
        :saml_attribute,
        :type,
        :match_exclude,
        :match_weight,
        :match_polarity,
        :min,
        :max,
        :options_text,
        :alternative_layout
      ]
    )
  end
end
