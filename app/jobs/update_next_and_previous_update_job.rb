# To be called whenever an update is updated
# Modifies the :previous_id column of updates to ensure that they are correctly ordered by report date
class UpdateNextAndPreviousUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(*update_ids)
    Update.transaction do
      if update_ids.present?
        Update.where(id: update_ids).lock('FOR UPDATE').each do |u|
          set_locals(u)
          assert_proper_order
          if swap?
            swap(u)
          else
            insert(u)
          end
        end
      else
        raise StandardError
      end
    rescue
      Update.lock('FOR UPDATE').each do |u|
        plane_insertion(u)
      end
    end
  end

  def swap?
    @on.present? || @op.present?
  end

  def set_locals(u)
    @rp = u.raw_previous
    @rn = u.raw_next

    @on = u.next
    @op = u.previous
    nil
  end

  def assert_proper_order
    return true if @rn == nil
    return true if @rp == nil
    return true if @rn.previous_id == @rp.id

    raise StandardError 'Improper Order'
  end

  def insert(u)
    @rn.update_column(:previous_id, u.id) if @rn.present?
    u.update_column(:previous_id, @rp&.id)
  end

  def swap(u)
    @on.update_column(:previous_id, @op&.id) if @on.present?
    @rn.update_column(:previous_id, u.id) if @rn.present?
    u.update_column(:previous_id, @rp&.id)
  end

  def plane_insertion(u)
    u.update_column(:previous_id, u.raw_previous&.id)
  end
end
