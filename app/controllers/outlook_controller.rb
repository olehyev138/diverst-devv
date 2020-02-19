class OutlookController < ApplicationController
  include OutlookAuthHelper
  layout 'outlook'

  before_action

  def index
    @login_url = get_login_url
  end

  def mail
    if @token
      # If a token is present in the session, get messages from the inbox
      callback = Proc.new do |r|
        r.headers['Authorization'] = "Bearer #{@token}"
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      @messages = graph.me.mail_folders.find('inbox').messages.order_by('receivedDateTime desc')
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to outlook_index_url
    end
  end

  def calendar
    if @token
      # If a token is present in the session, get events from the calendar
      callback = Proc.new do |r|
        r.headers['Authorization'] = "Bearer #{@token}"
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      @events = graph.me.events.order_by('start/dateTime asc')
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to outlook_index_url
    end
  end

  def contacts
    if @token
      # If a token is present in the session, get contacts
      callback = Proc.new do |r|
        r.headers['Authorization'] = "Bearer #{@token}"
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      @contacts = graph.me.contacts.order_by('givenName asc')
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to outlook_index_url
    end
  end

  protected

  def get_token
    @token = get_access_token
  rescue
    redirect_to outlook_index_url
  end
end
