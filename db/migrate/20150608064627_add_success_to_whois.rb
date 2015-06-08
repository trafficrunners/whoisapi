class AddSuccessToWhois < ActiveRecord::Migration
  def change
    add_column :my_proxies, :successful_whois, :integer
  end
end
