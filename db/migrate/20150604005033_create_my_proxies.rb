class CreateMyProxies < ActiveRecord::Migration
  def change
    create_table :my_proxies do |t|
      t.string :ip
      t.string :port
      t.string :user
      t.string :pass
      t.integer :timeout_errors, default: 0
      t.integer :used, default: 0
    end
  end
end
