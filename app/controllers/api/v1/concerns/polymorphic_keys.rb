# A Module to define controller actions for Models with `belongs_to :anything, polymorphic: true`
#
# These allow you to define callbacks to transform reasonable API params to the correct params
# EXAMPLE
#
# class RegionLeadersController
#   for_queries, for_commits = create_polymorphize_callbacks(:leader_of, Region)
#
#   before_action for_queries, only: [:show, :index]
#   before_action for_commits, only: [:create, :update]
# end
#
# for_queries: transforms params from   { region_id: 1 }
#                                   =>  { leader_of_id: 1, leader_of_type: 'Region' }
# for_commits: transforms params from   { region_leader: { region_id: 1 } }
#                                   =>  { group_leader: { leader_of_id: 1, leader_of_type: 'Region' } }
module Api::V1::Concerns::PolymorphicKeys
  extend ActiveSupport::Concern

  class_methods do
    def create_polymorphize_callbacks(field, association_klass)
      base = ->(temp_params) {
        if temp_params["#{association_klass.model_name.singular}_id"]
          temp_params["#{field}_type"] ||= association_klass.model_name.name
          temp_params["#{field}_id"] ||= temp_params["#{association_klass.model_name.singular}_id"]
          temp_params.delete("#{association_klass.model_name.singular}_id")
        end
      }

      query = -> {
        base[params]
      }

      commit = -> {
        unless params.key?(klass.model_name.singular)
          params[klass.model_name.singular] = params[controller_name.singularize]
          params.delete(controller_name.singularize)
        end
        base[params[klass.model_name.singular]]
      }

      [query, commit]
    end
  end
end
