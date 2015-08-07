class Proxxx < ActiveRecord::Migration
  def up
    MyProxy.load_from_csv
  end

  def down
    MyProxy.load_from_csv
  end
end
