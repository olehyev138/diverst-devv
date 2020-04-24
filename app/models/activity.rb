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

  belongs_to :owner, -> { where(activities: { owner_type: 'User' }).includes(:activities) }, class_name: 'User'

  # filter for group (the logs of the users who are in selected groups)
  scope :for_group_ids, -> (group_ids) { where('activities.owner_id' => (UserGroup.where('group_id' => group_ids)).map { |p| p.user_id }).distinct if group_ids.any? }
  # filter for date
  scope :joined_from, -> (from) { where('DATE(activities.created_at) >= ?', from.to_date) }
  scope :joined_to, -> (to) { where('DATE(activities.created_at) <= ?', to.to_date) }
end
