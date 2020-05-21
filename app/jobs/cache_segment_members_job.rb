# Calculates the members of a segment and cache them in the segment's "members" association

class CacheSegmentMembersJob < ActiveJob::Base
  queue_as :default

  after_perform :set_status

  @segment = nil

  def perform(segment_id)
    @segment = Segment.find_by_id(segment_id)
    return if @segment.nil?

    @segment.update_members
  end

  private

  def set_status
    @segment.update_column(:job_status, 0) unless @segment.nil?
  end
end
