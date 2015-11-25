class Employee::NewsLinksController < ApplicationController
  before_action :authenticate_employee!

  layout "employee"

  def index
    @news_links = current_employee.news_links.order(created_at: :desc)
  end

end
