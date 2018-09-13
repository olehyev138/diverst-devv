class ViewsController < ApplicationController
  
  def track
    view = View.find_or_create_by(view_params)
    view.view_count += 1
    view.save!

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
        :folder_id
        )
  end
end
