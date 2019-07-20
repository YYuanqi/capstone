class ChangeImageCreatorIdType < ActiveRecord::Migration[5.2]
  def up
    change_column :images, :creator_id, :integer, using: 'creator_id::integer', null: false
  end

  def down
    change_column :images, :creator_id, :string, null: false
  end
end
