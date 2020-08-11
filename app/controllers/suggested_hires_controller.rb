class SuggestedHiresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:index, :edit, :create]
  before_action :set_suggested_hire, only: [:edit, :update, :destroy]

  layout 'erg'

  def index
    authorize [@group, current_user], :index?, policy_class: SuggestedHirePolicy
    @suggested_hires = @group.suggested_hires
  end

  def create
    authorize [@group, current_user], :create?, policy_class: SuggestedHirePolicy

    suggested_hire = SuggestedHire.new(suggested_hire_params)

    if suggested_hire.save
      track_activity(@group, :suggest_a_hire)
      flash[:notice] = 'You just suggested a hire'
      redirect_to group_path(@group)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to group_path(@group)
    end
  end

  def edit
    authorize [@group, @suggested_hire], :edit?, policy_class: SuggestedHirePolicy
  end

  def update
    authorize [@group, @suggested_hire], :update?, policy_class: SuggestedHirePolicy

    if @suggested_hire.update(suggested_hire_params)
      flash[:notice] = 'Suggested hire was updated'
      redirect_to suggested_hires_path(group_id: @group.id)
    else
      flash[:alert] = 'Suggested hire was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize [@group, @suggested_hire], :destroy?, policy_class: SuggestedHirePolicy

    @suggested_hire.destroy 
    redirect_to suggested_hires_path(group_id: @group.id)
  end


  private

  def set_group
    group_id = params[:group_id].presence || suggested_hire_params[:group_id]
    @group = Group.find_by(id: group_id)
  end

  def set_suggested_hire
    set_group
    @suggested_hire = @group.suggested_hires.find(params[:id])
  end

  def suggested_hire_params
    params.require(:suggested_hire).permit(:user_id,
                                           :group_id,
                                           :suggested_hire_id,
                                           :resume)
  end
end
