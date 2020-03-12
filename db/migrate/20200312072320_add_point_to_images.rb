class AddPointToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :lng, :float
    add_column :images, :lat, :float
    add_index :images, [:lng, :lat]
  end
end
