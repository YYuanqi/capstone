class AddCityNameConstraint < ActiveRecord::Migration[5.2]
  def up
    change_column :cities, :name, :string, {null: false}
  end

  def down
    change_column :cities, :name, :string, {null: true}
  end
end
