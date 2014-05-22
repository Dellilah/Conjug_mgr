class CreateRepetitions < ActiveRecord::Migration
  def self.up
    create_table :repetitions do |t|
      t.timestamp :last
      t.integer :count, default: 0
      t.integer :mistake, default: 0
      t.integer :correct, default: 0
      t.references :form
      t.references :user

      t.timestamps
    end
    add_index :repetitions, [:form_id, :user_id], :unique => true
  end
  def self.down
    drop_table :repetitions
  end
end
