class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.references :user, foreign_key: true, null: false
      t.string :role_name, null: false
      t.string :mname
      t.integer :mid

      t.timestamps
    end
    add_index :roles, :mname
    add_index :roles, :mid
    add_index :roles, [:mname, :mid]
  end
end
