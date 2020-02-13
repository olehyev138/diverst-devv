require 'securerandom'

module UserGroup::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def csv_attributes(current_user = nil, params = {})
      group = params[:group_id].present? ? Group.find(params[:group_id]) : nil
      user_fields = current_user.present? ? current_user.fields : Field.none
      survey_fields = group.present? ? group.survey_fields : Field.none

      {
          titles: ['First name',
                   'Last name',
                   'Email',
                   'Accepted',
                   'Biography',
                   'Active',
          ].concat(survey_fields.map(&:title)).concat(user_fields.map(&:title)),
          values: [
              'user.first_name',
              'user.last_name',
              'user.email',
              'accepted_member',
              'user.biography',
              'user.active',
          ].concat(
              survey_fields.map do |field|
                -> (membership) { field.csv_value(membership.get_field_data(field).deserialized_data) }
              end
            ).concat(
              user_fields.map do |field|
                -> (membership) { field.csv_value(membership.user.get_field_data(field).deserialized_data) }
              end
            )
      }
    end

    def parameter_name(scope)
      scope_map = {
          all: 'all',
          active: 'active',
          pending: 'pending',
          inactive: 'inactive',
          accepted_users: 'accepted'
      }
      function_scope_map = {
          joined_from: -> (from) { "from #{from.to_time.strftime('%Y-%m-%d')}" },
          joined_to: -> (to) { "to #{to.to_time.strftime('%Y-%m-%d')}" },
          for_segment_ids: -> (segment_ids) { "of segments #{Segment.where(id: segment_ids).pluck(:name).join(', ')}" }
      }

      case scope
      when String, Symbol
        scope_map[scope.to_sym] || scope
      when Array
        function_scope_map[scope.first.to_sym].call(*scope[1..-1]) || scope.first.to_s
      else
        raise ::ArgumentError.new('query scopes should be an array of either strings or arrays starting with a string')
      end
    end

    def file_name(params)
      group = params[:group_id].present? ? Group.find(params[:group_id]) : nil
      raise ArgumentError.new('Valid group_id needs to be given') if group.blank?

      scopes = set_query_scopes(params)
      pre_scopes = scopes.select { |scope| [String, Symbol].include? scope.class }
      post_scopes = scopes.select { |scope| Array === scope }

      pre = pre_scopes.map do |scope|
        parameter_name(scope)
      end

      post = post_scopes.map do |scope|
        parameter_name(scope)
      end

      parts = pre + ["members of #{group.name}"] + post

      file_name = parts.map { |part| part.split(/[ .]/).join('_') }.join('_')
      ActiveStorage::Filename.new(file_name).sanitized
    end

    def valid_scopes
      [
          :active,
          :pending,
          :inactive,
          :accepted_users,
          :all,
          :joined_from,
          :joined_to,
          :for_segment_ids
      ].map { |scope| scope.to_s }
    end

    def base_includes
      [ :user, :group ]
    end

    def base_preloads
      [ :group, :user, group: Group.base_attributes_preloads, user: User.base_attribute_preloads ]
    end
  end
end
