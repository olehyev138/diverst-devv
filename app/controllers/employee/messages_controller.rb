class Employee::MessagesController < ApplicationController
  before_action :authenticate_employee!

  layout 'employee'

  def index
    @messages = current_employee.messages.order(created_at: :desc)
  end
end
