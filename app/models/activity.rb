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
  scope :joined_from, -> (from) { where('DATE_FORMAT(activities.created_at, '"'%Y-%m-%d'"') >= ?', from.to_time.strftime('%Y-%m-%d')) }
  scope :joined_to, -> (to) { where('DATE_FORMAT(activities.created_at, '"'%Y-%m-%d'"') <= ?', to.to_time.strftime('%Y-%m-%d')) }
end
