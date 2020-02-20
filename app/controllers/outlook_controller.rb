class OutlookController < ApplicationController
  include OutlookAuthHelper
  layout 'outlook'

  before_action :get_token, except: [:index]

  def index
    @login_url = get_login_url
  end

  def mail
    @messages = @graph.me.mail_folders.find('inbox').messages.order_by('receivedDateTime desc')
  end

  def calendar
    @events = @graph.me.events.order_by('start/dateTime asc')
    pp @graph.me.events.methods - Object.instance_methods
  end

  def contacts
    @contacts = @graph.me.contacts.order_by('givenName asc')
  end

  def add_event
    @participation = InitiativeUser.find_by(user: current_user, initiative_id: params[:initiative_id])
    if @participation.update_outlook(@graph)
      flash[:notice] = 'Successfully added event to your calendar'
    else
      flash[:alert] = 'Failed to Add Event'
    end
    redirect_to :back
  end

  protected

  def get_token
    @token = get_access_token

    if @token
      # If a token is present in the session, get contacts
      callback = Proc.new do |r|
        r.headers['Authorization'] = "Bearer #{@token}"
      end

      @graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)
    else
      raise RuntimeError
    end
  rescue
    flash[:alert] = 'You are not connected to an Outlook account'
    redirect_to outlook_index_url
  end
end
