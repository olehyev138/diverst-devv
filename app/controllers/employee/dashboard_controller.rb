class Employee::DashboardController < ApplicationController
  before_action :authenticate_employee!

  layout 'employee'

  def home
    @upcoming_events = current_employee.events.upcoming.limit(4)
    @news_links = current_employee.news_links.limit(3)
    @messages = current_employee.messages.limit(3)
  end
end
