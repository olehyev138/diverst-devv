require 'aws-sdk-s3'

module Metrics
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    @@analytics_bucket = Aws::S3::Resource::new(region: 'us-east-1')
                           .bucket('diverst-analytics')

    # Group metrics

    def group_population
      @@analytics_bucket.object('group_population').get.body.read
    end
  end
end
