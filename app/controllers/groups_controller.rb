class GroupsController < ApplicationController
  before_action :authenticate_admin!, except: [:show]
  before_action :authenticate_user!, only: [:show]
  before_action :set_group, except: [:index, :new, :create]
  skip_before_action :verify_authenticity_token, only: [:create]

  layout :resolve_layout

  helper ApplicationHelper

  def index
    @groups = current_admin.enterprise.groups
  end

  def new
    @group = current_admin.enterprise.groups.new
  end

  def show
    @events = @group.events.limit(3)
    @news_links = @group.news_links.limit(3)
    @employee_groups = @group.employee_groups.order(created_at: :desc).limit(8)
    @messages = @group.messages.limit(3)
  end

  def create
    @group = current_admin.enterprise.groups.new(group_params)

    if @group.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    if @group.update(group_params)
      redirect_to :back
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to action: :index
  end

  def sample_csv
    csv_string = CSV.generate do |csv|
      csv << ["Email"]

      @group.members.limit(5).each do |employee|
        csv << [employee.email]
      end
    end

    send_data csv_string, filename: "erg_import_example.csv"
  end

  def parse_csv
    @table = CSV.table params[:file].tempfile
    @failed_rows = []
    @successful_rows = []

    @table.each_with_index do |row, row_index|
      email = row[0]
      employee = Employee.where(email: email).first

      if employee
        if !@group.members.include? employee
          @group.members << employee
        end

        @successful_rows << row
      else
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: "There is no employee with this email address in the database"
        }
      end
    end

    @group.save
  end

  def export_csv
    employees_csv = Employee.to_csv employees: @group.members, fields: @group.enterprise.fields
    send_data employees_csv, filename: "#{@group.file_safe_name}_employees.csv"
  end

  protected

  def resolve_layout
    case action_name
    when "show"
      "erg"
    else
      "erg_manager"
    end
  end

  def set_group
    @group = current_user.enterprise.groups.find(params[:id])
  end

  def group_params
    params
    .require(:group)
    .permit(
      :name,
      :description,
      :logo,
      :send_invitations,
      :yammer_create_group,
      :yammer_sync_employees,
      :manager_id,
      member_ids: [],
      invitation_segment_ids: []
    )
  end
end
