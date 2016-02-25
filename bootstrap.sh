sudo redis-server /etc/redis/6379.conf
bundle exec sidekiq -C config/sidekiq.yml -d -L ~/log/sidekiq.log
nohup bundle exec guard >/dev/null 2>&1 &