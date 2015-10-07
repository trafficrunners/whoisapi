require 'open-uri'

class Buyproxies
  def self.from_config
    new(Rails.application.secrets.buyproxies['pid'], Rails.application.secrets.buyproxies['key'])
  end

  def initialize(pid, key)
    @pid = pid
    @key = key
  end

  def proxies(bypass_cache: false, expires_in: 12.hours)
    response = Rails.cache.fetch(force: bypass_cache, expires_in: expires_in) { request }
    parse_response(response)
  end

  protected

  URL_WILD = "http://api.buyproxies.org/?a=showProxies&pid=%{pid}&key=%{key}"

  def request
    $proxy = nil
    uri = URL_WILD % { pid: @pid, key: @key }
    uri = URI(uri)
    uri.read
  end

  def parse_proxy(line)
    res = line.split(':')

    {
      ip: res[0],
      port: res[1].to_i,
      user: res[2],
      pass: res[3]
    }
  end

  def parse_response(response)
    response.lines.map {|l| parse_proxy(l.strip) }
  end
end

