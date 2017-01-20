class PollDecorator < Draper::Decorator
  delegate_all
  
  def status
    if published?
      "Published"
    else
      "Draft"
    end
  end
end
