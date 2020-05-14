require 'mysql2'
require 'aws-sdk-s3'
require 'json'

BASE_BUCKET_NAME = 'diverst-analytics'
$s3 = Aws::S3::Resource.new(region: ENV['AWS_DEFAULT_REGION'])

# TODO: env variables & secrets management
$dbh = Mysql2::Client.new(
    host: 'devops-db.chzb878zcht6.us-east-1.rds.amazonaws.com',
    database: 'diverst',
    username: 'mainuser',
    password: 'password123',
    port: 3306)

def main(event:, context:)
  graph_data = {
      group_population: group_population($dbh).to_json,
      group_growth: group_growth($dbh).to_json,
      news_posts_per_group: news_posts_per_group($dbh).to_json,
      views_per_folder: views_per_folder($dbh).to_json
  }

  upload_s3(event['env_name'], graph_data)
end

def upload_s3(env_name, graph_data)
  data_bucket = $s3.bucket("#{env_name}-#{BASE_BUCKET_NAME}")

  # Create s3 object per graph
  graph_data.each do |graph, data|
    data_bucket.object(graph.to_s).put(body: data, content_type: 'application/json')
  end
end

# Graph functions

def group_population(dbh)
  # Retrieve membership count for each group
  #  - left join such that we get groups with no members

  sql = %{
    SELECT name, count(u.group_id) AS count
    FROM groups AS g
      LEFT JOIN user_groups AS u on u.group_id = g.id
    WHERE enterprise_id = 1
    GROUP BY g.id
    ORDER BY count DESC;
  }

  dbh.query(sql).to_a
end

def group_growth(dbh)
  # Retrieve membership growth for each group
  #  - Uses window functions

  sql = %{
    SELECT DISTINCT g.name, DATE_FORMAT(u.created_at, '%Y-%m-%d') as date,
           COUNT(*) OVER(PARTITION by g.id ORDER BY DATE_FORMAT(u.created_at, '%Y-%m-%d')) count,
           COUNT(*) OVER(PARTITION by g.id) total
    FROM user_groups u
    INNER JOIN groups g on g.id = u.group_id
    ORDER BY total DESC;
  }

  dbh.query(sql).to_a
end

def news_posts_per_group(dbh)
  # Retrieve total news posts (social, links, messages) per group
  #  - Treats shared posts as any other

  sql = %{
    SELECT g.name, count(nl.id) AS count
    FROM groups g
      JOIN news_feeds AS nf on nf.group_id = g.id
      LEFT JOIN news_feed_links nl on nl.news_feed_id = nf.id
    WHERE enterprise_id = 1
    GROUP BY nf.id
    ORDER BY count DESC;
  }

  dbh.query(sql).to_a
end

def views_per_folder(dbh)
  sql = %{
    SELECT f.name AS folder, g.name AS `group`, count(f.id) count
    FROM folders f
      JOIN groups g on g.id = f.group_id
      LEFT JOIN views v on v.folder_id = f.id
    WHERE g.enterprise_id = 1
    GROUP BY f.id
    ORDER BY count DESC;
  }

  dbh.query(sql).to_a
end
