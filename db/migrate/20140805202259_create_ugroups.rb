class CreateUgroups < ActiveRecord::Migration
  def self.up
    create_table :ugroups do |t|
      t.references :pgroup
      t.references :verb
      t.timestamps
    end
    add_index :ugroups, [:verb_id, :pgroup_id],  :unique => true
  end
  def self.down
    drop_table :ugroups
  end
end
