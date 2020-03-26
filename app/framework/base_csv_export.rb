module BaseCsvExport
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def to_csv(records:, nb_rows: nil, current_user: nil, params: {})
      CSV.generate do |csv|
        attrs = csv_attributes(current_user, params)

        csv << attrs[:titles]

        enumerator = case records
                     when ActiveRecord::Relation then records.order(created_at: :desc).limit(nb_rows).find_each
                     when Enumerable then records.each
                     else raise ::ArgumentError.new('Records should be an Enumerable')
        end

        enumerator.each do |record|
          record_columns = attrs[:values].map do |att|
            value = case att
                    when Proc, Method then att.call(record)
                    when String then record.send_chain(att.split('.'))
                    when Symbol then record.send(att)
                    else raise ::ArgumentError.new('Values should either be a name of a field, or a Method to get the value')
                    end

            case value
            when TrueClass, FalseClass then value ? 'Yes' : 'No'
            else value
            end
          end

          csv << record_columns
        end
      end
    end

    def file_name(params)
      partials = set_query_scopes(params).map do |scope|
        parameter_name(scope)
      end
      partials.append self.model_name.plural

      file_name = partials.map { |part| part.split(/[ .]/).join('_') }.join('_')
      ActiveStorage::Filename.new(file_name).sanitized
    end

    def parameter_name(scope)
      case scope
      when String, Symbol
        scope.to_s
      when Array
        scope.first + scope[1..-1].map(&:to_s).join('_')
      else
        raise ::ArgumentError.new('query scopes should either be a string or an array starting with a string')
      end
    end

    def csv_attributes(diverst_request = nil, params = {})
      attrs = attribute_names - ['id', 'created_at', 'updated_at', 'enterprise_id']
      attrs.reject { |attr| ['password', 'token', 'sent_at'].any? { |invalid| attr.include?(invalid) } }
      {
          titles: attrs.map { |att| att.capitalize.split('_').join(' ') },
          values: attrs
      }
    end
  end
end
