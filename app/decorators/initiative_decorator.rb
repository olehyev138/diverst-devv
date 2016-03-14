class InitiativeDecorator < Draper::Decorator
  decorates_association :updates

  def progress_percentage
    return 100 if Time.current >= initiative.end
    (Time.current - initiative.start) / (initiative.end - initiative.start) * 100
  end
end