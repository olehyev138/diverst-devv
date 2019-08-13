class SlackController < ApplicationController
  def interactive_message_response
    print("============================================================\n")
    print("Slack Interactive Message\n")
    print("============================================================\n")
    print("#{params}\n")
    print("============================================================\n")
  end
end
