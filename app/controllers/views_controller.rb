class ViewsController < ApplicationController
  
  def track
    view = View.create!(view_params)
    track_activity(view, :track, {group_id: view.group_id, 
                                  new_link_id: view.news_feed_link&.news_link_id, 
                                  folder_id: view.folder_id,
                                  resource_id: view.resource_id})
    render nothing: true
  end
  
  def view_params
    params
      .require(:view)
      .permit(
        :news_feed_link_id,
        :group_id,
        :user_id,
        :enterprise_id,
        :folder_id,
        :resource_id
        )
  end
end
