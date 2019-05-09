module PollsHelper
  def poll_initiative_visibility_class(poll, params)
    if poll.initiative
      ''
    elsif params[:initiative_id].blank? || !(poll.groups + poll.segments).empty?
      'hidden'
    end
  end

  def poll_others_visibility_class(poll, params)
    if params[:initiative_id].blank? && poll.initiative
      'hidden'
    elsif params[:initiative_id].present? || poll.initiative
      'hidden'
    end
  end

  def disabled_input?
    params[:initiative_id].blank? ? false : true
  end

  def respondent_name(response)
    return 'Anonymous User' if response.anonymous?

    if response.user.present?
      response.user.name_with_status
    else
      'Deleted User'
    end
  end
end
