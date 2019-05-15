class Groups::TwitterAccountsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_group
  before_action :set_client

  layout 'erg'

  def index
    @accounts = sorted_accounts
  end

  def new
    @account = @group.twitter_accounts.new
  end

  def create
    @account = @group.twitter_accounts.new(twitter_params)

    while @account.account.chars.first .eql? '@'
      @account.account = @account.account[1..-1]
    end

    if @account.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def update
    @account = @group.twitter_accounts.find(params[:id])

    params = twitter_params

    while params[:account].chars.first .eql? '@'
      params[:account] = params[:account][1..-1]
    end

    if @account.update(params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @account = @group.twitter_accounts.find(params[:id])
    @account.destroy
    redirect_to group_twitter_accounts_path(@group)
  end

  def delete_all
    @group.twitter_accounts.destroy_all
    flash[:notice] = 'You un-followed all twitter accounts'
    redirect_to group_twitter_accounts_path(@group)
  end

  def show
    @account = @group.twitter_accounts.find(params[:id])
  end

  def edit
    @account = @group.twitter_accounts.find(params[:id])
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_client
    @client = TwitterClient.client
  end

  def twitter_params
    params.require(:twitter_account).permit(:name, :account)
  end

  def sorted_accounts
    @group.twitter_accounts.all.sort do |a, b|
      case
        when a.updated_at < b.updated_at
          1
        when a.updated_at > b.updated_at
          -1
        else
          0
      end
    end
  end


end
