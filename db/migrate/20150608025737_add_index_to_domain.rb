class AddIndexToDomain < ActiveRecord::Migration
  def change
    add_index :domains, :url
  end
end
