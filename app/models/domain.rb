# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  url        :string
#  tld        :string
#  parts      :jsonb
#  server     :jsonb
#  properties :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "proxifier/env"

$proxy = nil

class TCPSocket
  def self.environment_proxy
    $proxy
  end
end

class Domain < ActiveRecord::Base
  class NlWhoisThrottled < StandardError; end

  TLDS_WITHOUT_WHOIS = %w{bh com.ar com.ph gr}

  def self.parse_url(d)
    if !d.starts_with? "http"
      d = "http://#{d}"
    end

    begin
      parsed_whole_domain = URI.parse(d).host
      PublicSuffix.parse(parsed_whole_domain).domain
    rescue => e
      #debugger
      puts "could not parse #{d}"
      puts e.message
      return nil
    end
  end

  def self.query(url)
    url = Domain.parse_url(url)
    tld = PublicSuffix.parse(url).tld

    if TLDS_WITHOUT_WHOIS.include?(tld)
      return nil
    end

    max_attempts = 8
    retry_attempts = 0

    begin
      proxy = MyProxy.rand
      proxy.update_column(:used, proxy.used + 1)

      $proxy = proxy.format
      w = Whois.lookup(url)

      if url.end_with?(".nl") && w.content.include?("maximum number of requests per second")
        raise NlWhoisThrottled
      end

      raise ::Whois::ResponseError if w.response_incomplete?

      raise ::Whois::ResponseIsThrottled if w.response_throttled?

      raise ::Whois::ResponseIsUnavailable if w.response_unavailable?

    rescue => e
      puts "*" * 100
      puts e.message

      if e.class == Timeout::Error
        proxy.update_column(:timeout_errors, proxy.timeout_errors + 1)
      else
        Airbrake.notify_or_ignore(error_class: "#{e.class}", error_message: "#{url} using #{$proxy}: #{e.message}")
      end

      if (retry_attempts += 1) < max_attempts
        retry
      else
        Airbrake.notify_or_ignore(error_class: "Whois Failed after max attempts", error_message: "#{url} - #{e.message}")
        return nil
      end
    end

    if tld.end_with?("cn") && w.content.include?("No matching record")
      Domain.create(url: url, tld: tld, parts: w.parts.as_json, server: w.server.as_json, properties: {"available?" => true})
    else
      parts = w.parts.as_json
      parts.each do |part|
        part["body"] = part["body"].encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => ''}).gsub("\u0000", "")
      end
      
      Domain.create(url: url, tld: tld, parts: parts, server: w.server.as_json, properties: w.properties.as_json)
    end
  end

  # look for it first, then query
  def self.lookup(url)
    url = Domain.parse_url(url)
    tld = PublicSuffix.parse(url).tld

    if TLDS_WITHOUT_WHOIS.include?(tld)
      return nil
    end

    d = Domain.where(url: url).where("created_at > ?", 1.day.ago).order("created_at desc").first
    if d.nil?
      d = Domain.query(url)
    end
    d
  end

  def available?
    self.properties["available?"]
  end

  def self.available?(url)
    d = Domain.lookup(url)
    if d.nil?
      return nil
    end
    return d.available?
  end

end
