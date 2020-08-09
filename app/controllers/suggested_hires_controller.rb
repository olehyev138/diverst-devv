class SuggestedHiresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:create]

  layout 'erg'
  
  def index
  end

  def show
  end

  def create
    authorize [@group, current_user], :create?, policy_class: SuggestedHirePolicy

    suggested_hire = SuggestedHire.new(suggested_hire_params)

    if suggested_hire.save
      flash[:notice] = 'You just suggested a hire'
      redirect_to group_path(@group)
    else
      flash[:alert] = "Something went wrong."
      redirect_to group_path(@group)
    end
  end

  def edit
  end


  private

  def suggested_hire_params
    params.require(:suggested_hire).permit(:user_id, 
                                           :group_id, 
                                           :suggested_hire_id,
                                           :resume)
  end

  def set_group
    @group = Group.find(suggested_hire_params[:group_id])
  end
end
