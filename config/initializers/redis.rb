require 'redis-namespace'

conf_file = File.join('config', 'redis.yml')

$redis =
  if File.exists?(conf_file)
    conf = YAML.load(File.read(conf_file))
    conf[Rails.env.to_s].blank? ? Redis.new(timeout: 10) : Redis.new(conf[Rails.env.to_s].merge(timeout: 10))
  else
    Redis.new(timeout: 10)
  end

$redis = Redis::Namespace.new(:whoisapi, redis: $redis)
