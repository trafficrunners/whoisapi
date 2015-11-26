resp = nil
uri = URI.parse('http://www.livejournal.com/')
Net::HTTP.new(uri.host, nil, '198.199.82.181', '22225', "lum-customer-domainreanimator-zone-gen-session-#{Random.rand(100000000)}", 'cbde2045a4f4').start do |http|
  request = Net::HTTP::Get.new uri

  resp = http.request request
end



http://lum-customer-domainreanimator-zone-gen-session-47990507:cbde2045a4f4@208.68.37.17:22225



Proxy-Authorization: Basic bHVtLWN1c3RvbWVyLWRvbWFpbnJlYW5pbWF0b3Item9uZS1nZW4tc2Vzc2lv\nbi00Nzk5MDUwNzpjYmRlMjA0NWE0ZjQ=\n
