require 'mysql2'
require 'aws-sdk-s3'
require 'json'

def main(event:, context:)
  dbh = Mysql2::Client.new(
    :host => "devops-db.chzb878zcht6.us-east-1.rds.amazonaws.com",
    :database=> "diverst",
    :username => "mainuser",
    :password=> "password123",
    :port => 3306)

  s3 = Aws::S3::Resource.new(region: ENV['AWS_DEFAULT_REGION'])
  bucket_name = 'diverst-analytics'
  data_bucket = s3.bucket(bucket_name)

  graph_data = {
      group_population: group_population(dbh).to_json,
      group_growth: group_growth(dbh).to_json
  }

  # Create s3 object per graph
  graph_data.each do |graph, data|
    data_bucket.object(graph.to_s).put(body: data, content_type: 'application/json')
  end
end


# Graph functions

def group_population(dbh)
  # Retrieve membership count for each group

  sql = %{
    SELECT name, count(u.group_id) AS count
    FROM groups AS g
    LEFT OUTER JOIN user_groups AS u on u.group_id = g.id
    WHERE enterprise_id = 1
    GROUP BY g.id;
  }

  dbh.query(sql).to_a
end

def group_growth(dbh)
  # Retrieve membership growth for each group
  #  - Uses window functions

  sql = %{
    SELECT DISTINCT g.name, DATE_FORMAT(u.created_at, '%Y-%m-%d') as date,
           COUNT(*) OVER(PARTITION by g.id ORDER BY DATE_FORMAT(u.created_at, '%Y-%m-%d')) count
    FROM user_groups u
    INNER JOIN groups g on g.id = u.group_id
  }

  dbh.query(sql).to_a
end
