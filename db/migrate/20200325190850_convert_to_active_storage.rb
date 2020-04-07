class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  require 'open-uri'

  def up
    # postgres
    # get_blob_id = 'LASTVAL()'

    # mariadb
    get_blob_id = 'LAST_INSERT_ID()'

    # sqlite
    # get_blob_id = 'LAST_INSERT_ROWID()'

    active_storage_blob_statement = ActiveRecord::Base.connection.raw_connection.prepare(<<-SQL)
      INSERT INTO active_storage_blobs (
        `key`, filename, content_type, metadata, byte_size, checksum, created_at
      ) VALUES (?, ?, ?, '{}', ?, ?, ?)
    SQL

    active_storage_attachment_statement = ActiveRecord::Base.connection.raw_connection.prepare(<<-SQL)
      INSERT INTO active_storage_attachments (
        name, record_type, record_id, blob_id, created_at
      ) VALUES (?, ?, ?, #{get_blob_id}, ?)
    SQL

    Rails.application.eager_load!
    models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

    transaction do
      models.each do |model|
        attachments = model.column_names.map do |c|
          if c =~ /(.+)_content_type$/
            $1
          end
        end.compact

        if attachments.blank?
          next
        end

        model.find_each.each do |instance|
          attachments.each do |attachment|
            if instance.send("#{attachment}_paperclip").path.blank? || instance.send(attachment).try(:attached?)
              next
            end

            updated_at = instance.try(:updated_at).try(:to_datetime) || DateTime.current

            active_storage_blob_statement.execute(
                key(instance, attachment),
                instance.send("#{attachment}_file_name"),
                instance.send("#{attachment}_content_type"),
                instance.send("#{attachment}_file_size"),
                checksum(instance.send("#{attachment}_paperclip")),
                updated_at
            )

            active_storage_attachment_statement.execute(
                attachment,
                model.name,
                instance.id,
                updated_at
            )
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def key(instance, attachment)
    # Use paperclip path as key so ActiveStorage can find them within S3
    instance.send("#{attachment}_paperclip").path.delete_prefix('/')
  end

  def checksum(attachment)
    if Rails.env.production? || Rails.env.staging?
      # remote files stored on another person's computer:
      url = attachment.url
      Digest::MD5.base64digest(Net::HTTP.get(URI(url)))
    else
      # local files stored on disk:
      url = attachment.path
      Digest::MD5.base64digest(File.read(url))
    end
  end
end
