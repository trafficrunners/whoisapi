class CreateBrokenDomains < ActiveRecord::Migration
  def change
    create_table :broken_domains do |t|
      t.string :url
      t.text :error

      t.timestamps null: false
    end
  end
end
