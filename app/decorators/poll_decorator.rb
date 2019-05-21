class PollDecorator < Draper::Decorator
  delegate_all

  def status
    published? ? 'Published' : 'Draft'
  end
end
