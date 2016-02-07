class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  layout 'global_settings'

  def index
    @users = current_user.enterprise.users.page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def update
    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])

    if @user.save
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to :back
  end

  def sample_csv
    send_data current_user.enterprise.users_csv(5), filename: 'diverst_import.csv'
  end

  def parse_csv
    @table = CSV.table params[:file].tempfile
    @failed_rows = []
    @successful_rows = []

    @table.each_with_index do |row, row_index|
      user = User.from_csv_row(row, enterprise: current_user.enterprise)

      if user
        if user.save
          user.invite!(current_user)
          @successful_rows << row
        else
          # ActiveRecord validation failed on user
          @failed_rows << {
            row: row,
            row_index: row_index + 1,
            error: user.errors.full_messages.join(', ')
          }
        end
      else
        # User.from_csv_row returned nil
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: 'Missing required information'
        }
      end
    end
  end

  def export_csv
    send_data current_user.enterprise.users_csv(nil), filename: 'diverst_users.csv'
  end

  protected

  def set_user
    @user = current_user.enterprise.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
