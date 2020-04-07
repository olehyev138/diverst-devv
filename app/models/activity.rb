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

  scope :for_group_ids, -> (group_ids) { where('activities.owner_id' => group_ids).distinct if group_ids.any? }
  scope :joined_from, -> (from) { where('activities.created_at >= ?', from) }
  scope :joined_to, -> (to) { where('activities.created_at <= ?', to) }
end
