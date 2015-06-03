require 'open-uri'
host = "http://localhost:3000/available?url="

while true
  url = ""
  5.times do |char|
    url += ("a".."z").to_a.sample
  end
  url += ".nl"

  endpoint = host + url
  r = open(endpoint).read
  puts r
end
