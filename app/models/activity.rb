class Activity < PublicActivity::Activity
  include BaseBuilder
  include BasePager
  include BaseSearcher
  include BaseSearch
  include BaseElasticsearch
  include BaseGraph
  include BaseCsvExport
  include ActionView::Helpers::DateHelper
  include Activity::Actions

  belongs_to :user, -> { where(activities: { owner_type: 'User' }).includes(:activities) }, foreign_key: :owner_id

  # need to be revised for group filter
  scope :for_group_ids, -> (group_ids) { where('activities.owner_id' => group_ids).distinct if group_ids.any? }
  # filter for date
  scope :joined_from, -> (from) { where('DATE(activities.created_at) >= ?', from.to_date) }
  scope :joined_to, -> (to) { where('DATE(activities.created_at) <= ?', to.to_date) }
end
