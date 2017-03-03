module PollsHelper
  def visibility_class
    params[:initiative_id].blank? ? "" : "hidden"
  end

  def disabled_input?
    params[:initiative_id].blank? ? false : true
  end
end
