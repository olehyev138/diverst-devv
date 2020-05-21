class Api::V1::UsersController < Api::V1::ApiController
  def index
    authorize(self.current_user, :index?)
    render json: self.current_user.enterprise.users
  end

  def show
    # return the user
    render json: find_and_authorize(params, :show?)
  end

  def create
    # create the user
    user = self.current_user.enterprise.users.new(user_params)

    # save the user
    if user.save
      return render status: 201, json: user
    else
      return render status: 422, json: { message: user.errors.full_messages.first }
    end
  end

  def update
    # update the user
    user = find_and_authorize(params, :update?)

    if user.update_attributes(user_params)
      return render json: user
    else
      return render status: 422, json: { message: user.errors.full_messages.first }
    end
  end

  def destroy
    find_and_authorize(params, :destroy?).destroy
    head :no_content
  end

  private

  def find_and_authorize(params, action)
    # find the user
    user = self.current_user.enterprise.users.find(params[:id])
    # authorize
    authorize user, action
    # return the user
    user
  end

  def user_params
    params.require(:user).permit(
      :password,
      :avatar,
      :email,
      :first_name,
      :last_name,
      :biography,
      :time_zone
    )
  end
end
