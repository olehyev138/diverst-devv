class GroupsController < ApplicationController
  before_action :set_group, except: [:index, :new, :create]
  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :verify_authorized

  layout :resolve_layout

  helper ApplicationHelper

  def index
    authorize Group
    @groups = current_user.enterprise.groups
  end

  def new
    authorize Group
    @group = current_user.enterprise.groups.new
  end

  def show
    authorize @group

    @events = @group.events.limit(3)
    @news_links = @group.news_links.limit(3)
    @user_groups = @group.user_groups.order(created_at: :desc).includes(:user).limit(8)
    @messages = @group.messages.limit(3)
  end

  def create
    authorize Group

    @group = current_user.enterprise.groups.new(group_params)

    if @group.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group

    if @group.update(group_params)
      redirect_to :back
    else
      render :edit
    end
  end

  def destroy
    authorize @group

    @group.destroy
    redirect_to action: :index
  end

  def metrics
    authorize @group, :show?
  end

  def import_csv
    authorize @group, :edit?
  end

  def sample_csv
    authorize @group, :show?

    csv_string = CSV.generate do |csv|
      csv << ['Email']

      @group.members.limit(5).each do |user|
        csv << [user.email]
      end
    end

    send_data csv_string, filename: 'erg_import_example.csv'
  end

  def parse_csv
    authorize @group, :edit?

    @table = CSV.table params[:file].tempfile
    @failed_rows = []
    @successful_rows = []

    @table.each_with_index do |row, row_index|
      email = row[0]
      user = User.where(email: email).first

      if user
        @group.members << user unless @group.members.include? user

        @successful_rows << row
      else
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: 'There is no user with this email address in the database'
        }
      end
    end

    @group.save
  end

  def export_csv
    authorize @group, :show?

    users_csv = User.to_csv users: @group.members, fields: @group.enterprise.fields
    send_data users_csv, filename: "#{@group.file_safe_name}_users.csv"
  end

  protected

  def resolve_layout
    case action_name
    when 'show'
      'erg'
    when 'metrics'
      'plan'
    else
      'erg_manager'
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
        :yammer_sync_users,
        :lead_manager_id,
        manager_ids: [],
        member_ids: [],
        invitation_segment_ids: [],
        outcomes_attributes: [
          :id,
          :name,
          :_destroy,
          pillars_attributes: [
            :id,
            :name,
            :value_proposition,
            :_destroy
          ]
        ]
      )
  end
end
