class GroupPopulationGraph
  def self.data
    {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Number of users',
          data: current_user.enterprise.groups.map { |g| g.members.count }
        }],
        categories: current_user.enterprise.groups.map(&:name),
        xAxisTitle: 'Nb. of users'
      },
      hasAggregation: false,
      title: 'Number of users per ERG'
    }
  end
end
