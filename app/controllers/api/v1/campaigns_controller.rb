class Api::V1::CampaignsController < DiverstController
  def payload
    params
      .require(klass.symbol)
      .permit(
        :title,
        :description,
        :start,
        :end,
        :nb_invites,
        :image,
        :banner,
        :status,
        :input,
        group_ids: [],
        segment_ids: [],
        manager_ids: [],
        questions_attributes: [
          :id,
          :_destroy,
          :title,
          :description
        ],
        sponsors_attributes: [
          :id,
          :sponsor_name,
          :sponsor_title,
          :sponsor_message,
          :sponsor_media,
          :disable_sponsor_message,
          :_destroy
        ]
      )
  end
end
