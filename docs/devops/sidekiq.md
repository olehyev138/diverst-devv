# Sidekiq

### Overview

The goal of this document is to describe our sidekiq configuration & implementation from a devops perspective. 

Generally speaking, sidekiq is a server that runs along side the puma/web server & it is mandatory that it runs with the application code. Additionally, sidekiq uses _redis_ as a store for persistence (as opposed to a cache, which is another common use for redis). 

#### Sidekiq configuration files

- `initializers/sidekiq.rb`

Here, we set some initial sidekiq options - redis url & logging.

- `config/sidekiq_worker.yml`

Here we configure sidekiq worker options, queues, concurrency for each environment. Note, it is considered better to have only a handful of sidekiq queues. 

- `config/application.rb`

Here, we configure Rails to use sidekiq. Relevant lines are:

```
config.active_job.queue_adapter = :sidekiq
```

```
config.middleware.insert_before ActionDispatch::Static, Rack::Rewrite do
  rewrite %r{^(?!/sidekiq|\/api|\/system|\/rails).*}, '/', not: %r{(.*\..*)}
end
```

- `.ebextensions/`

There are multiple files in EB Extensions to get Elastic Beanstalk to run sidekiq on deployment and will be detailed in the _aws setup_ section.

## AWS Setup

Currently, sidekiq is run inside the same ec2 instances as the application server. Sidekiq _must_ run with the application code, so this is the setup most people seem to use and the easiest. In the future, if need be, we can deploy a near identical Elastic Beanstalk environment as the backend, but run only sidekiq. Because everything is stored in redis, no communication between the environments is necessary. 

##### Redis

As part of the IAC infrastructure setup, we setup a Elasticache, Redis cluster. We then set the endpoint as an environment variable, `REDIS_URL`, for our Rails app to use. Additionally we set `REDIS_PROVIDER = REDIS_URL`, to tell sidekiq where to find the url. 

The redis url be must be defined in the format: `redis://<elasticache-endpoint>:<port>/0`.


##### Elastic Beanstalk

To get Elastic Beanstalk to run the sidekiq server, we setup several files & hooks. As of Sidekiq 6 (the major version we are running), daemonization through sidekiq (support for pid files & so forth is deprecated). To run sidekiq as a service/daemon it is mandatory to make use of the operating systems init/service software, ie _systemd_. For Elastic Beanstalk, this is _upstart_. 

Therefore, we setup files to run sidekiq with upstart & then add hooks to start sidekiq at on the appropriate events. 

All of these files are stored in `.ebextensions/` & the configuration is heavily based off of [this article](https://medium.com/kite-srm/setting-up-sidekiq-6-0-on-aws-b4f2e01f451c).
