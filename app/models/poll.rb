class Poll < ActiveRecord::Base
  has_many :fields, inverse_of: :poll
  has_many :responses, class_name: "PollResponse", inverse_of: :poll
  has_and_belongs_to_many :segments, inverse_of: :polls
  has_and_belongs_to_many :groups, inverse_of: :polls
  belongs_to :enterprise, inverse_of: :polls

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
end
