class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :caption
      t.string :creator_id, null: false

      t.timestamps
    end
    add_index :images, :creator_id
  end
end
