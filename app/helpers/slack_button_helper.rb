module SlackButtonHelper
  def slack_button_url(group)
    "https://slack.com/oauth/authorize?client_id=#{ENV['SLACK_CLIENT_ID']}"\
    "&redirect_uri=#{slack_button_redirect_group_url(group)}"\
    '&scope=incoming-webhook,commands,links:read'
  end

  def slack_button_image
    '<img alt="Add to Slack" height="40" width="139" '\
    'src="https://platform.slack-edge.com/img/add_to_slack.png" '\
    'srcset="https://platform.slack-edge.com/img/add_to_slack.png 1x, '\
    'https://platform.slack-edge.com/img/add_to_slack@2x.png 2x">'
  end
end
