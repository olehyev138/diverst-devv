class Activity < PublicActivity::Activity
  include BaseBuilder
  include BasePager
  include BaseSearcher
  include BaseSearch
  include BaseElasticsearch
  include BaseGraph
  include BaseCsvExport
  include ActionView::Helpers::DateHelper
end
