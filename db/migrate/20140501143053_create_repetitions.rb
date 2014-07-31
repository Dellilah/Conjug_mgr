class CreateRepetitions < ActiveRecord::Migration
  def self.up
    create_table :repetitions do |t|
      t.timestamp :next
      t.integer :count, default: 1
      t.integer :mistake, default: 0
      t.integer :n, default: 1
      t.float :ef, default: 2.5
      t.integer :interval, default: 1
      t.integer :remembered
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
