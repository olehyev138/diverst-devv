class Groups::TwitterAccountsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_group
  before_action :set_client
  before_action :set_account

  layout 'erg'

  def index
    @accounts = sorted_accounts
  end

  def new
    @account = @group.twitter_accounts.new
  end

  def create
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
    params = twitter_params

    params[:account] = strip_at_symbols(params[:account])

    if @account.update(params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @account.destroy
    redirect_to group_twitter_accounts_path(@group)
  end

  def delete_all
    @group.twitter_accounts.destroy_all
    flash[:notice] = 'You un-followed all twitter accounts'
    redirect_to group_twitter_accounts_path(@group)
  end

  def show
  end

  def edit
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_client
    @client = TwitterClient.client
  end

  def set_account
    @group.twitter_accounts.find(params[:id])
  end

  def twitter_params
    params.require(:twitter_account).permit(:name, :account)
  end

  def sorted_accounts(n = nil)
    if n
      @group.twitter_accounts.order_by(:updated_at).limit(n)
    else
      @group.twitter_accounts.order_by(:updated_at)
    end
  end

  def strip_at_symbols(account_name)
    while params[:account].chars.first .eql? '@'
      params[:account] = params[:account][1..-1]
    end
  end
end
