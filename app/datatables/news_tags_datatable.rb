class NewsTagsDatatable < AjaxDatatablesRails::Base
  def initialize(view_context, tag)
    super(view_context)
    @tag = tag
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['NewsTag.name']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['NewsTag.name']
  end

  private

  def data
    records.map do |record|
      [
        record.name
      ]
    end
  end

  def get_raw_records
    @tags
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
