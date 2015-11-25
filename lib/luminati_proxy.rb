class LuminatiProxy
  def self.get_super_proxy
    super_proxy = $redis.get("super_proxy")

    if super_proxy
      return JSON.parse(super_proxy)
    else
      l = Luminati::Client.new("lum-customer-domainreanimator-zone-gen", "cbde2045a4f4", zone: 'gen', port: 22225)
      conn = l.get_connection(country: nil, dns_resolution: nil, session: nil)

      $redis.setex("super_proxy", 60 * 10, conn.to_json)

      return conn.to_json
    end
  end
end
