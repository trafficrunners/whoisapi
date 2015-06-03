require "proxifier/env"

class ProxyPool < Array

  def self.instance
    @instance ||= new
  end

  def initialize
    @lock = Mutex.new
    @pos = 0
  end

  def checkout
    if any?
      @lock.synchronize do
        next_item = self[@pos % length]
        @pos += 1
        next_item
      end
    end
  end

  module Hook
    def self.included(klass)
      klass.class_eval do
        def self.environment_proxy
          ProxyPool.instance.checkout || super
        end
      end
    end
  end

end # class ProxyPool

class TCPSocket
  include ProxyPool::Hook
end

proxies = %w{
  176.61.137.27:80:trafficr:BTzuZKs4wm4sWbz
  188.214.55.198:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.23:80:trafficr:BTzuZKs4wm4sWbz
  185.8.63.19:80:trafficr:BTzuZKs4wm4sWbz
  188.214.14.59:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.93:80:trafficr:BTzuZKs4wm4sWbz
  5.34.240.188:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.27:80:trafficr:BTzuZKs4wm4sWbz
  37.72.188.85:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.124:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.23:80:trafficr:BTzuZKs4wm4sWbz
  188.214.14.61:80:trafficr:BTzuZKs4wm4sWbz
  46.29.251.206:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.172:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.9:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.95:80:trafficr:BTzuZKs4wm4sWbz
  178.216.51.45:80:trafficr:BTzuZKs4wm4sWbz
  5.34.244.195:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.144:80:trafficr:BTzuZKs4wm4sWbz
  5.34.240.166:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.118:80:trafficr:BTzuZKs4wm4sWbz
  5.34.244.201:80:trafficr:BTzuZKs4wm4sWbz
  5.34.244.203:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.53:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.6:80:trafficr:BTzuZKs4wm4sWbz
  37.203.214.183:80:trafficr:BTzuZKs4wm4sWbz
  37.203.214.190:80:trafficr:BTzuZKs4wm4sWbz
  151.237.190.139:80:trafficr:BTzuZKs4wm4sWbz
  185.8.63.25:80:trafficr:BTzuZKs4wm4sWbz
  176.61.138.76:80:trafficr:BTzuZKs4wm4sWbz
  191.101.121.209:80:trafficr:BTzuZKs4wm4sWbz
  46.29.251.182:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.19:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.94:80:trafficr:BTzuZKs4wm4sWbz
  188.214.14.113:80:trafficr:BTzuZKs4wm4sWbz
  37.203.214.73:80:trafficr:BTzuZKs4wm4sWbz
  37.72.188.83:80:trafficr:BTzuZKs4wm4sWbz
  46.29.251.207:80:trafficr:BTzuZKs4wm4sWbz
  151.237.190.67:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.26:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.8:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.34:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.4:80:trafficr:BTzuZKs4wm4sWbz
  37.72.188.19:80:trafficr:BTzuZKs4wm4sWbz
  5.34.240.127:80:trafficr:BTzuZKs4wm4sWbz
  5.34.244.200:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.81:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.97:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.29:80:trafficr:BTzuZKs4wm4sWbz
  188.214.55.200:80:trafficr:BTzuZKs4wm4sWbz
  191.101.121.195:80:trafficr:BTzuZKs4wm4sWbz
  46.29.251.194:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.24:80:trafficr:BTzuZKs4wm4sWbz
  176.61.136.180:80:trafficr:BTzuZKs4wm4sWbz
  151.237.190.146:80:trafficr:BTzuZKs4wm4sWbz
  37.203.214.184:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.121:80:trafficr:BTzuZKs4wm4sWbz
  188.214.14.55:80:trafficr:BTzuZKs4wm4sWbz
  191.101.101.195:80:trafficr:BTzuZKs4wm4sWbz
  185.20.184.127:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.202:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.19:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.5:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.6:80:trafficr:BTzuZKs4wm4sWbz
  37.203.214.187:80:trafficr:BTzuZKs4wm4sWbz
  191.101.101.244:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.29:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.10:80:trafficr:BTzuZKs4wm4sWbz
  151.237.184.109:80:trafficr:BTzuZKs4wm4sWbz
  151.237.190.62:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.31:80:trafficr:BTzuZKs4wm4sWbz
  185.3.132.58:80:trafficr:BTzuZKs4wm4sWbz
  5.153.238.138:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.6:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.163:80:trafficr:BTzuZKs4wm4sWbz
  151.237.190.149:80:trafficr:BTzuZKs4wm4sWbz
  191.101.101.205:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.2:80:trafficr:BTzuZKs4wm4sWbz
  185.20.184.58:80:trafficr:BTzuZKs4wm4sWbz
  5.34.243.142:80:trafficr:BTzuZKs4wm4sWbz
  151.237.190.221:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.60:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.5:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.3:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.230:80:trafficr:BTzuZKs4wm4sWbz
  185.3.132.54:80:trafficr:BTzuZKs4wm4sWbz
  151.237.185.7:80:trafficr:BTzuZKs4wm4sWbz
  176.61.136.30:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.41:80:trafficr:BTzuZKs4wm4sWbz
  176.61.136.177:80:trafficr:BTzuZKs4wm4sWbz
  5.34.240.185:80:trafficr:BTzuZKs4wm4sWbz
  46.29.251.202:80:trafficr:BTzuZKs4wm4sWbz
  176.61.138.75:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.25:80:trafficr:BTzuZKs4wm4sWbz
  37.203.214.71:80:trafficr:BTzuZKs4wm4sWbz
  191.101.101.178:80:trafficr:BTzuZKs4wm4sWbz
  46.29.250.117:80:trafficr:BTzuZKs4wm4sWbz
  185.8.63.21:80:trafficr:BTzuZKs4wm4sWbz
  130.185.152.89:80:trafficr:BTzuZKs4wm4sWbz
  176.61.137.193:80:trafficr:BTzuZKs4wm4sWbz
}

proxies.each do |p|
  proxy = p.split(":")
  ProxyPool.instance << "http://#{proxy[2]}:#{proxy[3]}@#{proxy[0]}"
end
