# A Module to define controller actions for Models with `belongs_to :anything, polymorphic: true`
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
