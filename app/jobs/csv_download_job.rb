class CsvDownloadJob < ApplicationJob
  queue_as :default

  PseudoRequest = Struct.new(:user)

  def perform(user_id, json_params = '{}', search_method = 'lookup', klass_name:)
    klass = klass_name.constantize
    params = JSON.parse(json_params, symbolize_names: true)

    return unless klass.respond_to?(:to_csv)
    return unless klass.respond_to?(:file_name)
    return unless (klass.method(:to_csv).parameters & [[:keyreq, :records], [:key, :records]]).any?

    user = User.find(user_id)
    return if user.nil?

    enterprise = user.enterprise
    return if enterprise.nil?

    records = get_records(PseudoRequest.new(user), params, search_method, klass: klass)
    csv = klass.to_csv(
        records: records,
        params: params,
        current_user: user,
    )

    file = CsvFile.new(user_id: user.id, download_file_name: klass.file_name(params))

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end

  def get_records(diverst_request, params = {}, search_method = :lookup, klass:)
    # get the search method
    search_method_obj = klass.method(search_method)

    # search
    search_method_obj.call(params, diverst_request, base: klass)
  end
end
