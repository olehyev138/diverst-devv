class PollDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, poll_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    poll = Poll.find_by_id(poll_id)
    return if poll.nil?

    csv = poll.responses_csv
    file = CsvFile.new(user_id: user.id, download_file_name: "#{poll.title}_responses")

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
