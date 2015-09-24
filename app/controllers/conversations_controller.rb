class ConversationsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_employee!
  before_action :set_conversation, only: [:destroy, :opt_in, :leave]
  serialization_scope :current_employee

  def index
    render json: current_employee.matches.not_archived.accepted, each_serializer: ConversationSerializer
  end

  def destroy
    return head :bad_request unless @match.both_accepted?

    if @match.update_attributes(archived: true)
      head :no_content
    else
      head :internal_server_error
    end
  end

  def opt_in
    return render json: {message: "You've already rejected this match"}, status: 400 if @match.status_for(current_employee) == Match.status[:rejected]
    return render json: {message: "Rating must be from 1 to 5"}, status: 400 unless !params[:rating].nil? && params[:rating].between?(1,5)
    return render json: {message: "Rating is already set"}, status: 400 if params[:rating] && !@match.rating_for(current_employee).nil?

    @match.set_status(employee: current_employee, status: Match.status[:saved])
    @match.set_rating(employee: current_employee, rating: params[:rating])

    if @match.save
      render nothing: true, status: 200
    else
      render @match.errors
    end
  end

  def leave
    return render json: {message: "Rating must be from 1 to 5"}, status: 400 unless !params[:rating] || params[:rating].between?(1,5)
    return render json: {message: "Rating is already set"}, status: 400 if params[:rating] && !@match.rating_for(current_employee).nil?

    @match.set_status(employee: current_employee, status: Match.status[:left])
    @match.set_rating(employee: current_employee, rating: params[:rating])

    if @match.save
      render nothing: true, status: 200
    else
      render @match.errors
    end
  end

  protected

  def set_conversation
    @match = current_employee.matches.conversations.where(id: params[:id]).first or not_found!
  end
end
