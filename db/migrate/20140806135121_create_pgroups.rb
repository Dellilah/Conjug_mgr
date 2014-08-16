class CreatePgroups < ActiveRecord::Migration
  def self.up
    create_table :pgroups do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :pgroups, :user_id
  end
  def self.down
    drop_table :pgroups
  end
end
