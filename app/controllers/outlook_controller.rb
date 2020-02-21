class OutlookController < ApplicationController
  layout 'outlook'

  def add_event
    @participation = InitiativeUser.find_by(user: current_user, initiative_id: params[:initiative_id])
    if @participation.update_outlook
      flash[:notice] = 'Successfully added event to your calendar'
    else
      flash[:alert] = 'Failed to Add Event'
    end
    redirect_to :back
  end
end
