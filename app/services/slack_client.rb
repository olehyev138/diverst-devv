class SlackClient
  require 'slack-ruby-client'
  delegate :url_helpers, to: 'Rails.application.routes'

  def self.init
    Slack.configure do |config|
      config.token = 'xoxb-6867881287-709481551059-CbXWqpdakswamGX0QrW4GrlX'
      config.logger = Logger.new(STDOUT)
      config.logger.level = Logger::INFO
      raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    end
  end

  def self.client
    @client ||= Slack::RealTime::Client.new
  end

  def self.bot_init
    client.on :hello do
      puts(
        "Successfully connected, welcome '#{client.self.name}' to " \
    "the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
      )
    end

    client.on :message do |data|
      puts data

      client.typing channel: data.channel

      case data.text
      when 'bot upcoming events?'
        upcoming_events = Initiative.where('start BETWEEN ? AND ?', Time.now, 1.month.from_now)
        pages = upcoming_events.map { |event| [event.name, group_event_url(event.group, event)] }
        client.message channel: data.channel, text: 'The events which are starting within a month are:'
        pages.each do |pg|
          client.message channel: data.channel, text: "<#{pg[1]}|#{pg[0]}>"
        end
      when 'bot show me a picture'
        client.web_client.files_upload(
          channels: '#slack_integration_test',
          as_user: true,
          file: Faraday::UploadIO.new('/home/aoxorn/Pictures/Cat2.jpg', 'image/jpeg'),
          title: 'Panther',
          filename: 'Cat2.jpg',
          initial_comment: 'Here is my cat'
        )
      when /^bot/
        client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
      else
        # type code here
      end
    end

    client.on :close do |_data|
      puts 'Connection closing, exiting.'
    end

    client.on :closed do |_data|
      puts 'Connection has been disconnected.'
    end
  end

  def self.bot_start
    client.start!
  end

  def self.bot_stop
    client.stop!
  end

  def self.post_web_hook_message(encrypted_webhook, message)
    HTTP.post(RsaEncryption.decode(encrypted_webhook), body: message.to_json)
  end
end
