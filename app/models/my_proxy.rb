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

  def self.rand
    self.order("RANDOM()").first
  end

  def format
    "http://#{self.user}:#{self.pass}@#{self.ip}:#{self.port}"
  end

end
