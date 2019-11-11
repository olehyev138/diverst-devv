class UserUsageDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to

  def initialize(view_context, user = nil)
    super(view_context)
    @user = user || view_context.current_user
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(
      PageVisitation.page_name
      PageVisitation.visits_week
      PageVisitation.visits_month
      PageVisitation.visits_year
      PageVisitation.visits_all
    )
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(PageVisitation.page_name PageVisitation.page_url)
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
    Rails.cache.fetch("user/#{@user.id}/page_visitations", expires_in: 15.minutes) do
      @user.pages_visited
    end
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
