require 'securerandom'

module Activity::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
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

    def valid_scopes
      [
          :joined_from,
          :joined_to,
          :for_segment_ids
      ].map { |scope| scope.to_s }
    end

  end
end
