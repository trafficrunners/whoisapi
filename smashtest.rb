require 'open-uri'
host = "http://localhost:3000/available?url="

threads = []

10.times do
  threads << Thread.new do

    while true
      url = ""
      4.times do |char|
        url += ("a".."z").to_a.sample
      end
      url += ".org"

      endpoint = host + url
      r = open(endpoint).read
      puts "#{url}: #{r}"
    end

  end
end

threads.map(&:join)
