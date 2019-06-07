class Metrics::MentorshipGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    @data = {
      mentoring_sessions: current_user.enterprise.mentoring_sessions.where('start <= ?', 1.month.ago).count,
      active_mentorships: Mentoring.active_mentorships(current_user.enterprise).count,
      total_mentors: current_user.enterprise.users.joins('JOIN mentorings ON users.id = mentorings.mentor_id').select(:id).distinct.count(:id),
      total_mentees: current_user.enterprise.users.joins('JOIN mentorings ON users.id = mentorings.mentee_id').select(:id).distinct.count(:id)
    }
  end

  def top_mentors
    authorize MetricsDashboard, :index?

    number = params[:number].to_i rescue 10
    type = params[:type] || 'mentor'
    other = type == 'mentor' ? 'mentee' : 'mentor'

    top_users = User.all.joins("JOIN mentorings ON users.id = mentorings.#{type}_id").
      select("users.id as id, first_name, last_name, count(mentorings.id) as number_of_#{other}s").group(:id).
      order("number_of_#{other}s DESC").limit(number)

    values = top_users.map do |user|
      {
        x: "#{user.first_name} #{user.last_name}",
        y: user.send("number_of_#{other}s".to_sym),
        children: {}
      }
    end

    render json: {
      title: "User with most number of #{other}s",
      type: 'bar',
      series: [{
                 key: "#{other.capitalize}s Per User",
                 values: values
               }]
    }
  end

  def mentors_per_group
    authorize MetricsDashboard, :index?
    respond_to do |format|
      format.json {
        groups = current_user.enterprise.groups

        values_mentees = groups.map do |group|
          {
            x: group.name,
            y: group.members.joins('JOIN mentorings ON users.id = mentorings.mentee_id').select(:id).distinct.count(:id),
            children: {}
          }
        end

        values_mentors = groups.map do |group|
          {
            x: group.name,
            y: group.members.joins('JOIN mentorings ON users.id = mentorings.mentor_id').select(:id).distinct.count(:id),
            children: {}
          }
        end

        render json: {
          title: 'Mentors and Mentees per Group',
          type: 'bar',
          series:
            [
              {
                key: "Number of Mentors Per Group",
                values: values_mentors.sort_by { |group| -group[:y] }
              },
              {
                key: "Number of Mentees Per Group",
                values: values_mentees
              }
            ]
        }
      }
      format.csv {
        # TODO Later
      }
    end
  end

  def user_mentorship_interest_per_group
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    respond_to do |format|
      format.json {
        render json: @graph.user_mentorship_interest_per_group
      }
      format.csv {
        GenericGraphsMentorshipDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_mentorship)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def mentoring_sessions_per_creator
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    respond_to do |format|
      format.json {
        render json: @graph.mentoring_sessions_per_creator(metrics_params[:date_range])
      }
      format.csv {
        GenericGraphsMentoringSessionsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          @from_date,
          @to_date
        )
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_sessions)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def mentoring_interests
    MentoringInterestPolicy.new(current_user, MentoringInterest).index?

    respond_to do |format|
      format.json {
        render json: @graph.mentoring_interests
      }
      format.csv {
        GenericGraphsMentoringInterestsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_interests)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end
end
