require 'aws-sdk-s3'

module Metrics
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    @@analytics_bucket = ENV['AWS_ACCESS_KEY_ID'] ?
        Aws::S3::Resource.new(region: 'us-east-1')
                           .bucket("#{ENV['ENV_NAME']}-diverst-analytics") : nil

    #
    ## Group metrics
    #

    def group_population
      @@analytics_bucket&.object('group_population').get.body.read
    end

    def growth_of_groups
      @@analytics_bucket&.object('group_growth').get.body.read
    end

    def news_posts_per_group
      @@analytics_bucket&.object('news_posts_per_group').get.body.read
    end

    def views_per_folder
      @@analytics_bucket&.object('views_per_folder').get.body.read
    end
  end
end
