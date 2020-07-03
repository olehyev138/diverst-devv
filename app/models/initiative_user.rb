class InitiativeUser < ApplicationRecord
  include InitiativeUser::Actions

  belongs_to :initiative
  belongs_to :user, counter_cache: :initiatives_count

  validates_presence_of :initiative
  validates_presence_of :user
  validates_uniqueness_of :user_id, scope: [:initiative_id], message: 'has already joined this event'
end
