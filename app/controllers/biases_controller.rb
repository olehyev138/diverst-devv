class BiasesController < ApplicationController
  before_action :set_bias, only: [:edit, :update, :destroy, :show]

  layout :resolve_layout

  def index
    @biases = current_user.enterprise.biases.includes(:user)

    @claims = @biases.map{ |bias|
      bias.groups_from.pluck(:name).map{ |group_from|
        bias.groups_to.pluck(:name).map{ |group_to|
          [group_from, group_to]
        }.flatten(1)
      }
    }
  end

  def new
    @bias = current_user.enterprise.biases.new
  end

  def create
    @bias = current_user.enterprise.biases.new(bias_params)
    @bias.user = current_user

    if @bias.save
      flash[:notice] = "Bias was reported"
      redirect_to :back
    else
      flash[:alert] = "Bias was not reported. Please fix the errors"
      render :new
    end
  end

  def update
    if @bias.update(bias_params)
      flash[:notice] = "Bias report was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Bias report was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    @bias.destroy
    redirect_to action: :index
  end

  protected

  def resolve_layout
    case action_name
    when 'new'
      'user'
    else
      'bias'
    end
  end

  def set_bias
    @bias = @group.biases.find(params[:id])
  end

  def bias_params
    params
      .require(:bias)
      .permit(
        :anonymous,
        :severity,
        :description,
        :spoken_words,
        :marginalized_in_meetings,
        :called_name,
        :contributions_ignored,
        :in_documents,
        :unfairly_criticized,
        :sexual_harassment,
        :inequality,
        groups_from_ids: [],
        groups_to_ids: [],
        cities_from_ids: [],
        cities_to_ids: [],
        departmrnts_from_ids: [],
        departmrnts_to_ids: []
      )
  end
end
