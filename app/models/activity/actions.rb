require 'securerandom'

module Activity::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def set_defaults
      @default_order = :desc
      @default_order_by = "#{self.table_name}.created_at"
      @page = 0
      @count = 10
    end

    def csv_attributes(current_user = nil, params = {})
      {
          titles: [
              'User_id',
              'First_name',
              'Last_name',
              'Trackable_id',
              'Trackable_type',
              'Action',
              'Created_at'
          ],
          values: [
              'owner_id',
              'owner.first_name',
              'owner.last_name',
              'trackable_id',
              'trackable_type',
              'key',
              'created_at'
          ]
      }
    end

    def parameter_name(scope)
      function_scope_map = {
          joined_from: -> (from) { "from #{from.to_time.strftime('%Y-%m-%d')}" },
          joined_to: -> (to) { "to #{to.to_time.strftime('%Y-%m-%d')}" },
          for_group_ids: -> (group_ids) { "of groups #{Group.where(id: group_ids).pluck(:name).join(', ')}" }
      }
      case scope
      when Array
        function_scope_map[scope.first.to_sym].call(*scope[1..-1]) || scope.first.to_s
      else
        raise ::ArgumentError.new('query scopes should be an array of either strings or arrays starting with a string')
      end
    end

    def file_name(params)
      partials = set_query_scopes(params).map do |scope|
        parameter_name(scope)
      end
      partials.append 'Logs'

      file_name = partials.map { |part| part.split(/[ .]/).join('_') }.join('_')
      ActiveStorage::Filename.new(file_name).sanitized
    end

    def valid_scopes
      [
          :joined_from,
          :joined_to,
          :for_group_ids
      ].map { |scope| scope.to_s }
    end

    def base_includes
      [ :owner ]
    end

    def base_preloads
      [ :owner, owner: User.base_preloads ]
    end
  end
end
