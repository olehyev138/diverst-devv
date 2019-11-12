class InitiativesDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id, initiative_ids)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.find_by_id(group_id)
    return if group.nil?

    csv = Initiative.to_csv(initiatives: group.initiatives.where(id: initiative_ids), enterprise: user.enterprise)
    file = CsvFile.new(user_id: user.id, download_file_name: 'initiatives')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
