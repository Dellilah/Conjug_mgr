class CreateRepetitions < ActiveRecord::Migration
  def change
    create_table :repetitions do |t|
      t.timestamp :last
      t.integer :count
      t.integer :mistake
      t.integer :correct
      t.references :form, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
