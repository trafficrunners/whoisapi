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
# Indexes
#
#  index_domains_on_url  (url)
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

  TLDS_WITH_WHOIS = Whois::Server.definitions[:tld].map { |a| a[0][1..-1] if a[1] }.compact

  def self.test_proxies
    require 'open-uri'
    MyProxy.all.each do |proxy|
      $proxy = proxy.format
      puts proxy.format

      begin
        puts open("https://trafficrunners.net")
      rescue => e
        puts e.message
      end

      $proxy = nil
    end
  end

  def self.parse_url(d)
    if !d.starts_with?("http:") && !d.starts_with?("https:")
      d = "http://#{d}"
    end

    begin
      parsed_whole_domain = URI.parse(d).host
      ps = PublicSuffix.parse(parsed_whole_domain)
      return [ps.domain, ps.tld]
    rescue => e
      return [nil, e.message]
    end
  end

  def self.query(url)
    url, tld = Domain.parse_url(url)
    if url.nil? || !TLDS_WITH_WHOIS.include?(tld)
      return nil
    end

    max_attempts = 8
    retry_attempts = 0

    proxy = nil
    begin
      proxy = MyProxy.rand
      MyProxy.update_counters proxy.id, used: 1

      $proxy = proxy.format
      w = Whois.lookup(url)
      $proxy = nil

      if url.end_with?(".nl") && w.content.include?("maximum number of requests per second")
        raise NlWhoisThrottled
      end

      raise ::Whois::ResponseError if w.response_incomplete?

      raise ::Whois::ResponseIsThrottled if w.response_throttled?

      raise ::Whois::ResponseIsUnavailable if w.response_unavailable?

    rescue => e
      puts "*" * 100
      puts e.message

      if e.class == Timeout::Error || e.class == Whois::ConnectionError
        MyProxy.update_counters proxy.id, timeout_errors: 1
        #proxy.update_column(:timeout_errors, proxy.timeout_errors + 1)
      else
        Airbrake.notify_or_ignore(error_class: "#{e.class}", error_message: "#{url} using #{proxy.ip}: #{e.message}")
      end

      if (retry_attempts += 1) < max_attempts
        retry
      else
        BrokenDomain.create!(url: url, error: e.message)
        Airbrake.notify_or_ignore(error_class: "Whois Failed after max attempts", error_message: "#{url} - #{e.message}")
        return nil
      end
    end

    begin
      if tld.end_with?("cn") && w.content.include?("No matching record")
        MyProxy.update_counters proxy.id, successful_whois: 1
        #Domain.create(url: url, tld: tld, parts: w.parts.as_json, server: w.server.as_json, properties: {"available?" => true})
        Domain.new(url: url, tld: tld, parts: w.parts.as_json, server: w.server.as_json, properties: {"available?" => true})
      else
        MyProxy.update_counters proxy.id, successful_whois: 1
        #Domain.create(url: url, tld: tld, parts: Domain.fix_encoding(w.parts.as_json), server: w.server.as_json, properties: Domain.fix_encoding(w.properties.as_json))
        Domain.new(url: url, tld: tld, parts: Domain.fix_encoding(w.parts.as_json), server: w.server.as_json, properties: Domain.fix_encoding(w.properties.as_json))
      end
    rescue => e
      BrokenDomain.create!(url: url, error: "#{e.class}: #{e.message}")
      Airbrake.notify_or_ignore(error_class: "Domain Creation Failed: #{e.class}", error_message: "#{url} - #{e.message}")
      return nil
    end
  end

  def self.fix_encoding(obj)
    if obj.is_a? String
      #obj.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => ''}).gsub("\u0000", "")
      obj.force_encoding("ASCII-8BIT").force_encoding('UTF-8').gsub("\u0000", "").scrub
    elsif obj.is_a? Array
      obj.map {|item| fix_encoding item }
    elsif obj.is_a? Hash
      obj.merge(obj) {|k, val| fix_encoding val }
    else
      obj
    end
  end


  # look for it first, then query
  def self.lookup(url)
    url, tld = Domain.parse_url(url)
    if url.nil? || !TLDS_WITH_WHOIS.include?(tld)
      return nil
    end

    #d = Domain.where(url: url).where("created_at > ?", 1.day.ago).order("created_at desc").first
    #if d.nil?
      d = Domain.query(url)
    #end
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
