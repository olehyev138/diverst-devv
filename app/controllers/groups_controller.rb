class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :new, :create, :plan_overview,
                                      :calendar, :calendar_data]

  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :verify_authorized

  layout :resolve_layout

  helper ApplicationHelper

  def index
    authorize Group
    @groups = current_user.enterprise.groups
  end

  def plan_overview
    authorize Group, :index?
    @groups = current_user.enterprise.groups.includes(:initiatives)
  end

  # calendar for all of the groups
  def calendar
    authorize Group, :index?
    enterprise = current_user.enterprise
    @groups = enterprise.groups
    @segments = enterprise.segments
    @q_form_submit_path = calendar_groups_path
    @q = Initiative.ransack(params[:q])

    render 'shared/calendar/calendar_view'
  end

  def calendar_data
    authorize Group, :index?
    @events = current_user.enterprise.initiatives.ransack(
      params[:q]&.merge(m: 'or', outcome_group_id_in: params[:q]&.dig(:initiative_participating_groups_group_id_in))
    ).result

    render 'shared/calendar/events', format: :json
  end

  def new
    authorize Group
    @group = current_user.enterprise.groups.new
  end

  def show
    authorize @group

    @upcoming_events = @group.initiatives.upcoming.limit(3) + @group.participating_initiatives.upcoming.limit(3)
    @news_links = @group.news_links.limit(3).order(created_at: :desc)
    @user_groups = @group.user_groups.order(created_at: :desc).includes(:user).limit(8)
    @messages = @group.messages.includes(:owner).limit(3)
    @user_group = @group.user_groups.find_by(user: current_user)
  end

  def create
    authorize Group

    @group = current_user.enterprise.groups.new(group_params)
    @group.owner = current_user

    if @group.save
      track_activity(@group, :create)

      flash[:notice] = "Your ERG was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your ERG was not created. Please fix the errors"
      render :new
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group

    if @group.update(group_params)
      track_activity(@group, :update)

      flash[:notice] = "Your ERG was updated"
      redirect_to :back
    else
      flash[:alert] = "Your ERG was not updated. Please fix the errors"
      render :edit
    end
  end

  def settings
    authorize @group, :update?
  end

  def destroy
    authorize @group

    track_activity(@group, :destroy)
    if @group.destroy
      flash[:notice] = "Your ERG was deleted"
      redirect_to action: :index
    else
      flash[:alert] = "Your ERG was not deleted. Please fix the errors"
      redirect_to :back
    end
  end

  def metrics
    authorize @group, :show?
    @updates = @group.updates
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

  def edit_fields
    authorize @group, :edit?
  end

  def delete_attachment
    authorize @group, :update?

    @group.banner = nil
    if @group.save
      flash[:notice] = "Group attachment was removed"
      redirect_to :back
    else
      flash[:alert] = "Group attachment was not removed. Please fix the errors"
      render :back
    end
  end

  protected

  def resolve_layout
    case action_name
    when 'show'
      'erg'
    when 'metrics'
      'plan'
    when 'edit_fields', 'plan_overview'
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
        :banner,
        :yammer_create_group,
        :yammer_sync_users,
        :pending_users,
        :members_visibility,
        :messages_visibility,
        :calendar_color,
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
        ],
        fields_attributes: [
          :id,
          :title,
          :_destroy,
          :gamification_value,
          :show_on_vcard,
          :saml_attribute,
          :type,
          :min,
          :max,
          :options_text,
          :alternative_layout
        ]
      )
  end
end
