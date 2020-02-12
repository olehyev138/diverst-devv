module BaseCsvExport
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def to_csv(records:, nb_rows: nil)
      CSV.generate do |csv|
        attrs = csv_attributes

        csv << attrs

        records.order(created_at: :desc).limit(nb_rows).find_each do |record|
          record_columns = attrs.map { |att| record.send(att) }

          csv << record_columns
        end
      end
    end

    def file_name(params)
      partials = []
      params[:query_scopes].each do |scope|
        partials.append case scope.class
                        when String
                          scope
                        when Array
                          raise ::ArgumentError.new('query scopes should either be a string or an array starting with a string') unless scope.first.class <= String

                          [scope.first] + scope[1..-1].map(&:to_s).join(' ')
                        else
                          raise ::ArgumentError.new('query scopes should either be a string or an array starting with a string')
        end
      end
      partials.append self.model_name.plural

      partials.map { |part| part.split(' ').join('_') }.join('_')
    end

    def csv_attributes
      attrs = attribute_names - ['id', 'created_at', 'updated_at', 'enterprise_id']
      attrs.reject { |attr| ['password', 'token', 'sent_at'].any? { |invalid| attr.include?(invalid) } }
    end
  end
end
