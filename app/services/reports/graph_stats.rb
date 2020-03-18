class Reports::GraphStats
  def initialize(graph, elements, date_range_str, unset_series)
    @parser = BaseGraph::ElasticsearchParser.new
    @parser.extractors = {
      label: -> (e, _) { e[:key] },
      count: @parser.date_range(key: :doc_count)
    }

    @graph = graph
    @elements = elements
    @date_range = ui_parse_date_range(date_range_str)
    @unset_series = unset_series
  end

  def get_header
    header = []
    header << [@graph.title]
    header << ['From' + @date_range[:from], 'To:' + @date_range[:to]]

    # If aggregation, add each aggregation field value as a column
    header_row = [@graph.field.title]
    if @graph.aggregation.present?
      child_elements = get_elements(@elements[0])
      child_elements.each do |child_element|
        # skip series/aggregation values that are unset in UI
        aggregation_field_value = @parser.parse(child_element)[:label]

        next if @unset_series.include? aggregation_field_value

        header_row << aggregation_field_value
      end
    end

    header << header_row
    header
  end

  def get_body
    body = []

    if @graph.aggregation.present?
      @elements.each do |parent_element|
        row = []
        child_elements = get_elements(parent_element)

        next if child_elements.size == 0

        row << @parser.parse(parent_element)[:label]
        child_elements.each do |child_element|
          label, count = @parser.parse(child_element).fetch_values(:label, :count)

          next if @unset_series.include?(label)

          row << count
        end

        body << row
      end
    else
      @elements.each do |element|
        label, count = @parser.parse(element).fetch_values(:label, :count)

        next if count == 0

        body << [label, count]
      end
    end

    body
  end

  private

  def get_elements(parent)
    @parser.get_elements(parent, extractor: @parser.nested_terms_list).sort_by { |child|
      child[:key]
    }
  end

  def ui_parse_date_range(date_range)
    default_from_date = 'All'
    default_to_date = DateTime.tomorrow.strftime('%F')

    return { from: default_from_date, to: default_to_date } if date_range.blank?

    from_date = date_range[:from_date].presence || default_from_date
    to_date = DateTime.parse((date_range[:to_date].presence || default_to_date)).strftime('%F')

    from_date = case from_date
                when '1m'     then 1.month.ago.strftime('%F')
                when '3m'     then 3.months.ago.strftime('%F')
                when '6m'     then 6.months.ago.strftime('%F')
                when 'ytd'    then Time.now.beginning_of_year.strftime('%F')
                when '1y'     then 1.year.ago.strftime('%F')
                when 'all'    then 'All'
                else
                  DateTime.parse(from_date).strftime('%F')
    end

    { from: from_date, to: to_date }
  end
end
