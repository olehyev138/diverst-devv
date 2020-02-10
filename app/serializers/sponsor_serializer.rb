class SponsorSerializer < ApplicationRecordSerializer
  attributes :group, :enterprise, :sponsor_media_location, :sponsor_name, :sponsor_title

  def serialize_all_fields
    true
  end
end
