class SegmentDatatable < AjaxDatatablesRails::Base
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

  def generate_edit_link(record)
    if policy(record).edit?
      link_to "Edit", edit_segment_path(record)
    end
  end

  def generate_destroy_link(record)
    if policy(record).destroy?
      link_to "Delete", segment_path(record), method: :delete, 
      class: "error", data: { confirm: "Are you sure?" }
    end
  end

  def data
    records.map do |record|
      edit_link = generate_edit_link(record)
      destroy_link = generate_destroy_link(record)
      [
        "#{link_to(html_escape(record.name), segment_path(record))}",
        html_escape(record.members.uniq.count),
        html_escape(record.rules.count),
        html_escape(record.created_at.to_s :reversed_slashes), 
        "#{edit_link} - #{destroy_link}"
      ]
    end
  end

  def get_raw_records
    @segments
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
