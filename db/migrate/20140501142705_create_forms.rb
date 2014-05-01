class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string :content
      t.integer :temp
      t.integer :person
      t.references :verb

      t.timestamps
    end
    add_index :forms, :verb_id
  end
  def self.down
    drop_table :forms
  end
end
