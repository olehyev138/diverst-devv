class BiasesController < ApplicationController
  before_action :set_bias, only: [:edit, :update, :destroy, :show]

  layout :resolve_layout

  def index
    @biases = current_user.enterprise.biases

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
      redirect_to :back
    else
      render :new
    end
  end

  def update
    if @bias.update(bias_params)
      redirect_to action: :index
    else
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
        groups_from_ids: [],
        groups_to_ids: []
      )
  end
end
