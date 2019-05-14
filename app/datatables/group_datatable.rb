class GroupDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :group_path
  def_delegator :@view, :policy

  def initialize(view_context, groups)
    super(view_context)
    @groups = groups
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Group.name']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Group.name']
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
    @groups
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
