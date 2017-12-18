class GroupsController < ApplicationController
    before_action :authenticate_user!, except: [:calendar_data]
    before_action :set_group, except: [:index, :new, :create, :plan_overview,
                                       :calendar, :calendar_data, :close_budgets]

    skip_before_action :verify_authenticity_token, only: [:create, :calendar_data]
    after_action :verify_authorized, except: [:calendar_data]

    layout :resolve_layout

    helper ApplicationHelper

    def index
        authorize Group
        @groups = current_user.enterprise.groups.includes(:children).where(:parent_id => nil)
    end

    def plan_overview
        authorize Group
        @groups = current_user.enterprise.groups.includes(:initiatives)
    end
    
    def close_budgets
        authorize Group
        @groups = current_user.enterprise.groups.includes(:children).where(:parent_id => nil)
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

    # missing a template
    def calendar_data
        #To allow logged users see embedded calendars of other enterprises, we check for token first
        if params[:token]
            enterprise = Enterprise.find_by_iframe_calendar_token(params[:token])
        else
            enterprise = current_user&.enterprise
        end

        not_found! if enterprise.nil?

        @events = enterprise.initiatives
            .ransack(
                initiative_participating_groups_group_id_in: params[:q]&.dig(:initiative_participating_groups_group_id_in),
                outcome_group_id_in: params[:q]&.dig(:initiative_participating_groups_group_id_in),
                m: 'or'
            )
            .result
            .ransack(
                initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
            )
            .result

        render 'shared/calendar/events', format: :json
    end

    def new
        authorize Group
        @group = current_user.enterprise.groups.new
    end

    def show
        authorize @group

        if policy(@group).erg_leader_permissions?
            base_show

            @posts = @group.news_feed_links
                            .includes(:link)
                            .approved
                            .order(created_at: :desc)
                            .limit(5)
        else
            if @group.active_members.include? current_user
                base_show

                @posts = @group.news_feed_links
                            .includes(:link)
                            .approved
                            .joins(joins)
                            .where(where, current_user.segments.pluck(:id))
                            .order(created_at: :desc)
                            .limit(5)

            else
                @upcoming_events = []
                @user_groups = []
                @messages = []
                @user_group = []
                @leaders = []
                @user_groups = []
                @top_user_group_participants = []
                @top_group_participants = []
                @posts = []
            end
        end
    end

    def create
        authorize Group

        @group = current_user.enterprise.groups.new(group_params)
        @group.owner = current_user

        if @group.save
            track_activity(@group, :create)
            flash[:notice] = "Your #{c_t(:erg)} was created"
            redirect_to action: :index
        else
            flash[:alert] = "Your #{c_t(:erg)} was not created. Please fix the errors"
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

            flash[:notice] = "Your #{c_t(:erg)} was updated"
            redirect_to :back
        else
            flash[:alert] = "Your #{c_t(:erg)} was not updated. Please fix the errors"
            render :settings
        end
    end

    def settings
        authorize @group, :update?
    end

    def destroy
        authorize @group

        track_activity(@group, :destroy)
        if @group.destroy
            flash[:notice] = "Your #{c_t(:erg)} was deleted"
            redirect_to action: :index
        else
            flash[:alert] = "Your #{c_t(:erg)} was not deleted. Please fix the errors"
            redirect_to :back
        end
    end

    def metrics
        authorize @group
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
            redirect_to :back
        end
    end

    protected

    def base_show
        @upcoming_events = @group.initiatives.upcoming.limit(3) + @group.participating_initiatives.upcoming.limit(3)
        @messages = @group.messages.includes(:owner).limit(3)
        @user_group = @group.user_groups.find_by(user: current_user)
        @leaders = @group.group_leaders.visible

        @members = @group.active_members.order(created_at: :desc).limit(8)

        @top_user_group_participants = @group.user_groups.active.top_participants(10).includes(:user)
        @top_group_participants = @group.enterprise.groups.top_participants(10)
    end

    def where
        "news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)"
    end

    def joins
        "LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id"
    end

    def resolve_layout
        case action_name
        when 'show'
            'erg'
        when 'metrics'
            'plan'
        when 'edit_fields', 'plan_overview', 'close_budgets'
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
                :active,
                :sponsor_name,
                :sponsor_title,
                :sponsor_image,
                :sponsor_media,
                :sponsor_message,
                :company_video_url,
                :parent_id,
                manager_ids: [],
                child_ids: [],
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
                ],
                survey_fields_attributes: [
                    :id,
                    :title,
                    :_destroy,
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
