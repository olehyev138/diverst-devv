class SponsorSerializer < ApplicationRecordSerializer
  attributes :group, :enterprise, :sponsor_media_location

  def serialize_all_fields
    true
  end
end
