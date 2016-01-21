class SaveEmployeeAvatarFromUrlJob < ActiveJob::Base
  queue_as :default

  def perform(employee, url)
    employee.avatar = open(url)
    employee.save
  end
end
