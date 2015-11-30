def test_pr
resp = nil
uri = URI.parse('http://whois.verisign-grs.com:43')
# binding.pry
Net::HTTP.new(uri.host, nil, '198.199.82.181', '22225', "lum-customer-domainreanimator-zone-gen-session-#{Random.rand(100000000)}", 'cbde2045a4f4').start do |http|
  request = Net::HTTP::Get.new uri

  resp = http.request request
end
end


http://lum-customer-domainreanimator-zone-gen-session-47990507:cbde2045a4f4@208.68.37.17:22225



Proxy-Authorization: Basic bHVtLWN1c3RvbWVyLWRvbWFpbnJlYW5pbWF0b3Item9uZS1nZW4tc2Vzc2lv\nbi00Nzk5MDUwNzpjYmRlMjA0NWE0ZjQ=\n





# NET::Http

# {"accept-encoding"=>["gzip;q=1.0,deflate;q=0.6,identity;q=0.3"],
#  "accept"=>["*/*"],
#  "user-agent"=>["Ruby"],
#  "host"=>["www.livejournal.com"],
#  "proxy-authorization"=>["Basic bHVtLWN1c3RvbWVyLWRvbWFpbnJlYW5pbWF0b3Item9uZS1nZW4tc2Vzc2lvbi0xNjE5MTMxNzpjYmRlMjA0NWE0ZjQ="]}

#    322: def write_header(sock, ver, path)
#    323:   buf = "#{@method} #{path} HTTP/#{ver}\r\n"
# => 324:   each_capitalized do |k,v|
#    325:     buf << "#{k}: #{v}\r\n"
#    326:   end
#    327:   buf << "\r\n"
#    328:   sock.write buf
#    329: end


# Proxifier

# =>  9:   socket << "CONNECT #{host}:#{port} HTTP/1.1\r\n"
#    10:   socket << "Host: #{host}:#{port}\r\n"
#    11:   socket << "Proxy-Authorization: Basic #{["#{user}:#{password}"].pack("m").chomp}\r\n" if user
#    12:   socket << "\r\n"

# "CONNECT whois.verisign-grs.com:43 HTTP/1.1\r\n"
# "Host: whois.verisign-grs.com:43\r\n"
# "Proxy-Authorization: Basic bHVtLWN1c3RvbWVyLWRvbWFpbnJlYW5pbWF0b3Item9uZS1nZW4tc2Vzc2lv\nbi02NTIzODY2NjpjYmRlMjA0NWE0ZjQ=\r\n"


