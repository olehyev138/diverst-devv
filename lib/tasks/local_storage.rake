namespace :local_storage do
  desc 'Moves files stored from Paperclip to the ActiveStorage storage directory'
  task migrate_to_active_storage: :environment do
    ActiveStorage::Attachment.find_each do |attachment|
      name = attachment.name

      source = attachment.record.send("#{name}_paperclip").path
      dest_dir = File.join(
        'storage',
        attachment.blob.key.first(2),
        attachment.blob.key.first(4).last(2))
      dest = File.join(dest_dir, attachment.blob.key)

      FileUtils.mkdir_p(dest_dir)
      puts "Moving #{source} to #{dest}"
      FileUtils.cp(source, dest)
    end
  end
end
