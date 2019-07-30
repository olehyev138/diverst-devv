class AggregateUrlStatsDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to

  def initialize(view_context)
    super(view_context)
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(TotalPageVisitation.page TotalPageVisitation.times_visited)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['TotalPageVisitation.page']
  end

  private

  def data
    records.map do |record|
      [
        "#{link_to(record.page)}",
        record.times_visited
      ]
    end
  end

  def get_raw_records
    Rails.cache.fetch("total_page_visitations", expires_in: 1.hour) do
      TotalPageVisitation.all
    end

  end

  # ==== Insert 'presenter'-like methods below if necessary
end
