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

class Domain < ActiveRecord::Base
  class NlWhoisThrottled < StandardError; end

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

    begin
      w = Whois.lookup(url)

      if url.end_with?(".nl") && w.content.include?("maximum number of requests per second")
        raise NlWhoisThrottled
      end
    rescue Whois::ConnectionError, Timeout::Error => e
      puts e.message

      Airbrake.notify_or_ignore(e, parameters: {url: url})
      sleep 1
      retry
    rescue => e
      puts e.message

      Airbrake.notify_or_ignore(e, parameters: {url: url})
      sleep 1
      retry
    end

    Domain.create(url: url, tld: tld, parts: w.parts.as_json, server: w.server.as_json, properties: w.properties.as_json)
  end

  # look for it first, then query
  def self.lookup(url)
    url = Domain.parse_url(url)
    
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
    d.available?
  end

end
