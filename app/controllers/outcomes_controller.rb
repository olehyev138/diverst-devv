class OutcomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_outcome, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :edit]

  layout 'erg'

  def index
    authorize Outcome
  end

  # MISSING TEMPLATE
  def new
    authorize Outcome
    @outcome = Outcome.new
  end

  def create
    authorize Outcome
    @outcome = Outcome.new(outcome_params)

    # don't think this belongs here
    # @outcome.enterprise = current_user.enterprise
    # @outcome.estimated_funding *= 100
    # @outcome.owner = current_user

    if @outcome.save
      flash[:notice] = "Your #{ c_t(:outcome) } was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your #{ c_t(:outcome) } was not created. Please fix the errors"
      render :new # new template does not exist
    end
  end

  def edit
    authorize @outcome
  end

  def update
    authorize @outcome
    if @outcome.update(outcome_params)
      flash[:notice] = "Your #{ c_t(:outcome) } was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your #{ c_t(:outcome) } was not updated. Please fix the errors"
      render :edit # edit template exist. however, form partial does not
    end
  end

  def destroy
    authorize @outcome
    @outcome.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.includes(outcomes: :pillars).find(params[:group_id])
  end

  def set_outcome
    @outcome = @group.outcomes.find(params[:id])
  end

  def outcome_params
    params
      .require(:outcome)
      .permit(
        :name,
        :group_id
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Outcomes'
    when 'new'
      'Outcome Creation'
    when 'edit'
      "Outcome Edit: #{@outcome.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
