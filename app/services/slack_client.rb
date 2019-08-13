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

  def self.web_hook
    @web_hook ||= 'https://hooks.slack.com/services/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'
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

  def self.post_web_hook_message(message)
    HTTP.post(web_hook, body: message.to_json)
  end

  # @param [Object] event
  def self.event_to_attachment(event)
    pk, sk = get_colours(event.enterprise)
    {
      fallback: "New Event: #{event.name}",
      color: pk,
      author_name: "#{event.group.name}",
      author_link: Rails.application.routes.url_helpers.group_url(event.group),
      title: "New Event: #{event.name}",
      title_link: Rails.application.routes.url_helpers.group_event_url(event.group, event),
      image_url: 'http://diverst-testing-sandbox.s3.amazonaws.com/enterprises/banners/000/000/001/original/Ribbons_image_for_Culture_banner_%281%29.jpg?AWSAccessKeyId=AKIAJ4INVSLKHAINO57Q&Expires=1565640806&Signature=PkK3pQPAvbSV0dQdyqFuNiaOA%2FE%3D',
      text: "#{HtmlHelper.strip_truncate(event.description, 200)}",
      fields: [
        {
          title: 'Start Time',
          value: "#{event.start.strftime('%F %T')}",
          short: true
        },
        {
          title: 'End Time',
          value: "#{event.end.strftime('%F %T')}",
          short: true
        }
      ],
      actions: [{
        type: 'button',
        text: 'View Event',
        url: Rails.application.routes.url_helpers.group_event_url(event.group, event),
        style: 'primary'
      }],
      footer: 'Diverst',
      footer_icon: 'https://media.licdn.com/dms/image/C560BAQHtJ5kSFSZ0eQ/company-logo_400_400/0?e=1573689600&v=beta&t=A9cF9VH8X0blrsIk_frcMatL604NK0-ajMNRatn8KzM',
    }
  end

  def self.event_image(event)
    if event.picture_file_name.present?
      "#{ENV['DOMAIN'] || 'localhost:3000'}#{event.picture.url}"
    else
      nil
    end
  end

  def self.get_colours(enterprise)
    theme = enterprise.theme
    if theme.nil?
      %w(#7B77C9 #7B77C9)
    else
      p_color = theme.primary_color || '#7B77C9'
      s_color = theme.secondary_color || p_color
      [p_color, s_color]
    end
  end

  def self.post_upcoming_events
    upcoming_events = Initiative.where('start BETWEEN ? AND ?', Time.now, 1.month.from_now)
    message = {
      text: 'The Upcoming Events Are:',
      username: 'Diverst Bot',
      mrkdwn: true,
      attachments: upcoming_events.map { |event| event_to_attachment(event) }
    }
    post_web_hook_message(message)
  end
end
