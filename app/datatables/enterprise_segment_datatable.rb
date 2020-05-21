class EnterpriseSegmentDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :segment_path
  def_delegator :@view, :edit_segment_path
  def_delegator :@view, :policy

  def initialize(view_context, segments)
    super(view_context)
    @segments = segments
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Segment.name', 'Segment.rules.count', 'Segment.created_at.to_s']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Segment.name']
  end

  private

  def data
    records.map do |record|
      [
        record.id,
        ActionController::Base.helpers.sanitize(record.name).gsub('&amp;', '&')
      ]
    end
  end

  def get_raw_records
    @segments
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
