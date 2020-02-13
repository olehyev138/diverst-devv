class AggregateUrlStatsDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to

  def initialize(view_context, enterprise_id)
    super(view_context)
    @enterprise = Enterprise.find(enterprise_id)
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(
      TotalPageVisitation.page_name
      TotalPageVisitation.visits_week
      TotalPageVisitation.visits_month
      TotalPageVisitation.visits_year
      TotalPageVisitation.visits_all
    )
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(TotalPageVisitation.page_name TotalPageVisitation.page_url)
  end

  private

  def valid_path?(path)
    path.present? && Rails.application.routes.recognize_path(path)[:action] != 'routing_error'
  rescue ActionController::RoutingError
    false
  end

  def data
    records.map do |record|
      [
        valid_path?(record.page_url) ? link_to(record.page_name, record.page_url) : record.page_name,
        record.visits_week,
        record.visits_month,
        record.visits_year,
        record.visits_all,
      ]
    end
  end

  def get_raw_records
    Rails.cache.fetch("total_page_visitations:#{@enterprise.id}", expires_in: 15.minutes) do
      @enterprise.total_page_visitations
    end
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
