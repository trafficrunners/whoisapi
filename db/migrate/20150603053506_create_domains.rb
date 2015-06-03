class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :url
      t.string :tld
      t.jsonb :parts
      t.jsonb :server
      t.jsonb :properties

      t.timestamps null: false
    end
  end
end
