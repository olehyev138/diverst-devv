class GroupsController < ApplicationController
    before_action :authenticate_user!, except: [:calendar_data]
    before_action :set_group, except: [:index, :new, :create, :calendar, :calendar_data, :close_budgets, :close_budgets_export_csv, :sort, :get_all_groups]
    skip_before_action :verify_authenticity_token, only: [:create, :calendar_data]
    after_action :verify_authorized, except: [:calendar_data]

    layout :resolve_layout

    helper ApplicationHelper

    def index
        authorize Group

        @groups = GroupPolicy::Scope.new(current_user, current_user.enterprise.groups, :groups_manage)
        .resolve.includes(:children).order(:position)

        respond_to do |format|
          format.html
          format.json { render json: GroupDatatable.new(view_context, @groups) }
        end
    end

    def get_all_groups
      authorize Group, :index?

      @groups = GroupPolicy::Scope.new(current_user, current_user.enterprise.groups, :groups_manage)
      .resolve.includes(:children).order(:position)

      respond_to do |format|
        format.json { render json: @groups.map { |g| {id: g.id, text: g.name} }.as_json }
      end
    end

    def close_budgets
        authorize Group, :manage_all_group_budgets?
        @groups = policy_scope(Group).includes(:children).all_parents
    end

    def close_budgets_export_csv
      authorize Group, :manage_all_group_budgets?
      GroupsCloseBudgetsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
      flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
      redirect_to :back
    end

    # calendar for all of the groups
    def calendar
        authorize Group
        enterprise = current_user.enterprise
        @groups = []
        enterprise.groups.each do |group|
            if group.is_parent_group?
                @groups << group
                group.children.each do |sub_group|
                    @groups << sub_group
                end
            elsif group.is_standard_group?
                @groups << group
            end
        end
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

        @events = enterprise.initiatives.includes(:initiative_participating_groups).where(:groups => {:parent_id => nil})
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

        @events += enterprise.initiatives.includes(:initiative_participating_groups).where.not(:groups => {:parent_id => nil})
            .ransack(
                initiative_participating_groups_group_id_in: Group.where(:parent_id => params[:q]&.dig(:initiative_participating_groups_group_id_in)).pluck(:id),
                outcome_group_id_in: Group.where(:parent_id => params[:q]&.dig(:initiative_participating_groups_group_id_in)).pluck(:id),
                m: 'or'
            )
            .result
            .ransack(
                initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
            )
            .result

        render 'shared/calendar/events', formats: :json
    end

    def new
        authorize Group
        @group = current_user.enterprise.groups.new
        @categories = current_user.enterprise.group_categories
        # groups available to be parents or children
        @available_groups = @group.enterprise.groups.where.not(id: @group.id)
    end

    def show
        authorize @group
        @group_sponsors = @group.sponsors

        if policy(@group).manage?
            base_show

            @posts = without_segments
        else
            if policy(@group).is_an_accepted_member?
                base_show
                @posts = with_segments
            else
                @upcoming_events = @group.initiatives.upcoming.limit(3) + @group.participating_initiatives.upcoming.limit(3)
                @user_groups = []
                @messages = []
                @user_group = []
                @leaders = @group.group_leaders.includes(:user).visible
                @user_groups = []
                @top_user_group_participants = []
                @top_group_participants = []
                @posts = with_segments
            end
        end
    end

    def create
        authorize Group

        @group = current_user.enterprise.groups.new(group_params)
        @group.owner = current_user

        if group_params[:group_category_id].present?
          @group.group_category_type_id = GroupCategory.find_by(id: group_params[:group_category_id])&.group_category_type_id
        else
            @group.group_category_type_id = nil
        end

        if @group.save
            track_activity(@group, :create)
            flash[:notice] = "Your #{c_t(:erg)} was created"
            redirect_to groups_url
        else
            flash.now[:alert] = "Your #{c_t(:erg)} was not created. Please fix the errors"
            @categories = current_user.enterprise.group_categories
            render :new
        end
    end

    def edit
        authorize @group
        @categories = current_user.enterprise.group_categories
        # groups available to be parents or children
        @available_groups = @group.enterprise.groups.where.not(id: @group.id)
    end

    def update
        authorize @group
        update_group
    end

    def update_group
        if group_params[:group_category_id].present?
          @group.group_category_type_id = GroupCategory.find_by(id: group_params[:group_category_id])&.group_category_type_id
        end

        if @group.update(group_params)
            track_activity(@group, :update)
            flash[:notice] = "Your #{c_t(:erg)} was updated"

            if request.referer == settings_group_url(@group)
                redirect_to @group
            elsif request.referer == group_outcomes_url(@group)
                redirect_to group_outcomes_url(@group)
            elsif request.referer == group_questions_url(@group)
                redirect_to group_questions_url(@group)
            elsif request.referer == layouts_group_url(@group)
                redirect_to layouts_group_url(@group)
            else
                redirect_to [:edit, @group]
            end
        else
            flash.now[:alert] = "Your #{c_t(:erg)} was not updated. Please fix the errors"

            if request.referer == edit_group_url(@group) || request.referer == group_url(@group)
              @categories = current_user.enterprise.group_categories
              render :edit
            else
              render :settings
            end
        end
    end

    def update_questions
        authorize @group, :insights?
        update_group
    end

    def update_layouts
        authorize @group, :layouts?
        update_group
    end

    def update_settings
        authorize @group, :settings?
        update_group
    end

    def layouts
        authorize @group
    end

    def settings
        authorize @group
    end

    def plan_overview
        authorize [@group], :index?, :policy_class => GroupBudgetPolicy
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
        authorize @group, :manage?
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

        if params[:file].nil?
            flash[:alert] = "CSV file is required"
            redirect_to :back
            return
        end

        file = CsvFile.new( import_file: params[:file].tempfile, user: current_user, :group_id => @group.id)

        @message = ''
        @success = false
        @email = ENV['CSV_UPLOAD_REPORT_EMAIL']

        if file.save
          @success = true
          @message = '@success'
        else
          @success = false
          @message = 'error'
          @errors = file.errors.full_messages
        end
    end

    def export_csv
        authorize @group, :show?
        GroupMemberDownloadJob.perform_later(current_user.id, @group.id)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
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

    def sort
        authorize Group
        params[:group].each_with_index do |id, index|
            current_user.enterprise.groups.find(id).update(position: index+1)
        end
        render nothing: true
    end

    protected

    def base_show
        @upcoming_events = @group.initiatives.upcoming.limit(3) + @group.participating_initiatives.upcoming.limit(3)
        @messages = @group.messages.includes(:owner).limit(3)
        @user_group = @group.user_groups.find_by(user: current_user)
        @leaders = @group.group_leaders.includes(:user).visible

        @members = @group.active_members.order(created_at: :desc).limit(8)

        @top_user_group_participants = @group.user_groups.active.top_participants(10).includes(:user)
        @top_group_participants = @group.enterprise.groups.non_private.top_participants(10)
    end

    def without_segments
        NewsFeed.all_links_without_segments(@group.news_feed.id, @group.enterprise)
                            .includes(:news_link, :group_message, :social_link)
                            .order(is_pinned: :desc, created_at: :desc)
                            .limit(5)
    end

    def with_segments
        if GroupPostsPolicy.new(current_user, [@group]).view_latest_news?
            segment_ids = current_user.segments.ids
            if not segment_ids.empty?
                NewsFeed.all_links(@group.news_feed.id, segment_ids, @group.enterprise)
                    .order(is_pinned: :desc, created_at: :desc)
                    .limit(5)
            else
                return without_segments
            end
        else
            []
        end
    end

    def resolve_layout
        case action_name
        when 'show', 'layouts', 'settings', 'plan_overview', 'metrics', 'edit_fields'
            'erg'
        when 'close_budgets'
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
                :short_description,
                :description,
                :home_message,
                :logo,
                :private,
                :banner,
                :yammer_create_group,
                :yammer_sync_users,
                :yammer_group_link,
                :pending_users,
                :members_visibility,
                :messages_visibility,
                :latest_news_visibility,
                :upcoming_events_visibility,
                :calendar_color,
                :active,
                :contact_email,
                :sponsor_image,
                :company_video_url,
                :layout,
                :parent_id,
                :group_category_id,
                :group_category_type_id,
                :position,
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
                ],
                sponsors_attributes: [
                  :id,
                  :sponsor_name,
                  :sponsor_title,
                  :sponsor_message,
                  :sponsor_media,
                  :disable_sponsor_message,
                  :_destroy
                ]
            )
    end
end
