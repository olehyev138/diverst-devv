class UsageDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to

  def initialize(view_context)
    super(view_context)
    @user = view_context.current_user
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(PageVisitationDatum.page PageVisitationDatum.times_visited)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['PageVisitationDatum.page']
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
    @user.page_visitation_data
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
