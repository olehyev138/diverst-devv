class ReplaceEnterpriseAndGroupSponsorsWithOnePolymorphicSponsorModel < ActiveRecord::Migration
  def up
    Enterprise.all.each do |enterprise|
      if enterprise.cdo_name.present? || (enterprise.cdo_name.present? && enterprise.cdo_title.present?)
        enterprise.sponsors.create(sponsor_name: enterprise.cdo_name,
          sponsor_title: enterprise.cdo_title,
          sponsor_message: enterprise.cdo_message_email,
          sponsor_media_file_name: enterprise.sponsor_media_file_name,
          sponsor_media_content_type: enterprise.sponsor_media_content_type,
          sponsor_media_file_size: enterprise.sponsor_media_file_size,
          sponsor_media_updated_at: enterprise.sponsor_media_updated_at,
          disable_sponsor_message: enterprise.disable_sponsor_message,
          )
      end
    end
    say "***enterprise sponsors created***"
    Group.all.each do |group|
      if group.sponsor_name.present? || (group.sponsor_message.present? && group.sponsor_title.present?)
        group.sponsors.create(sponsor_name: group.sponsor_name,
          sponsor_title: group.sponsor_title,
          sponsor_message: group.sponsor_message,
          sponsor_media_file_name: group.sponsor_media_file_name,
          sponsor_media_content_type: group.sponsor_media_content_type,
          sponsor_media_file_size: group.sponsor_media_file_size,
          sponsor_media_updated_at: group.sponsor_media_updated_at,
          disable_sponsor_message: false)
      end
    end
    say "***group sponsors created***"


    remove_column :groups, :sponsor_name, :string
    remove_column :groups, :sponsor_title, :string
    remove_column :groups, :sponsor_message, :text
    remove_attachment :groups, :sponsor_media

    remove_column :enterprises, :cdo_title, :string
    remove_column :enterprises, :cdo_name, :string
    remove_column :enterprises, :cdo_message_email, :text
    remove_column :enterprises, :disable_sponsor_message, :boolean
    remove_attachment :enterprises, :sponsor_media
  end

  def down
    add_attachment :enterprises, :sponsor_media
    add_column :enterprises, :disable_sponsor_message, :boolean, default: false
    add_column :enterprises, :cdo_message_email, :text
    add_column :enterprises, :cdo_name, :string
    add_column :enterprises, :cdo_title, :string

    add_attachment :groups, :sponsor_media
    add_column :groups, :sponsor_message, :text
    add_column :groups, :sponsor_title, :string
    add_column :groups, :sponsor_name, :string
  end
end
