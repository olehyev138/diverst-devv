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

  #scope :for_groups_ids, -> (group_ids) { joins(user: [:groups]).where('groups.id' => group_ids).distinct if group_ids.any? }

  scope :joined_from, -> (from) { where('activities.created_at >= ?', from) }
  scope :joined_to, -> (to) { where('activities.created_at <= ?', to) }

end
