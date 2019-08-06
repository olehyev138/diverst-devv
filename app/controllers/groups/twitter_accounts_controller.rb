class Groups::TwitterAccountsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_group
  before_action :set_client
  before_action :set_account

  layout 'erg'

  def index
    visit_page("#{@group.name}'s Twitter Accounts")
    @accounts = sorted_accounts
  end

  def new
    visit_page("#{@group.name}'s Twitter Account Follow")
    @account = @group.twitter_accounts.new
  end

  def create
    @account = @group.twitter_accounts.new(twitter_params)

    @account.account = strip_at_symbols(@account.account)

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
    visit_page("#{@account.name}'s Twitter Feed")
  end

  def edit
    visit_page("#{@group.name}'s Twitter Account Edit")
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_client
    @client = TwitterClient.client
  end

  def set_account
    if params[:id]
      @account = @group.twitter_accounts.find(params[:id])
    else

    end
  end

  def twitter_params
    params.require(:twitter_account).permit(:name, :account)
  end

  def sorted_accounts(n = nil)
    if n
      @group.twitter_accounts.order(updated_at: :desc).limit(n)
    else
      @group.twitter_accounts.order(updated_at: :desc)
    end
  end

  def strip_at_symbols(account_name)
    while account_name.chars.first .eql? '@'
      account_name = account_name[1..-1]
    end
    account_name
  end
end
