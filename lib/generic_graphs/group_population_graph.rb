class GroupPopulationGraph
  def self.data
    {
      type: "bar",
      highcharts: {
        series: [{
          title: "Number of employees",
          data: current_admin.enterprise.groups.map{ |g| g.members.count }
        }],
        categories: current_admin.enterprise.groups.map(&:name),
        xAxisTitle: "Nb. of employees"
      },
      hasAggregation: false,
      title: "Number of employees per BRG"
    }
  end
end