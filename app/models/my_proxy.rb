# == Schema Information
#
# Table name: my_proxies
#
#  id             :integer          not null, primary key
#  ip             :string
#  port           :string
#  user           :string
#  pass           :string
#  timeout_errors :integer          default(0)
#  used           :integer          default(0)
#

require 'csv'

class MyProxy < ActiveRecord::Base

  def self.load_from_csv
    MyProxy.delete_all

    CSV.foreach("#{Rails.root.join('db/proxies.csv')}", {headers: true, col_sep: ":"} ) do |row|
      MyProxy.create!(row.to_hash.slice(*MyProxy.column_names))
    end
  end

  def self.rand(provider: :luminati)
  # def self.rand(provider: :buyproxies)
    options =
      case provider
      when :buyproxies
        Buyproxies.from_config.proxies.sample
      when :luminati
        # luminati_hsh = JSON.parse(LuminatiProxy.get_super_proxy)
        luminati_hsh = {
          'ip_address' => '198.199.82.181',
          'port' => '22225',
          'password' => 'cbde2045a4f4'
        }

        {
          ip: luminati_hsh['ip_address'],
          port: luminati_hsh['port'],
          user: "lum-customer-domainreanimator-zone-gen-session-#{Random.rand(100000000)}",
          # user: luminati_hsh['username'],
          pass: luminati_hsh['password']
        }
      else
        fail 'Unknown proxies provider'
      end
    new options
  end

  def format
    "http://#{self.user}:#{self.pass}@#{self.ip}:#{self.port}"
  end

end
