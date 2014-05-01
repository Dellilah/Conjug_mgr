class CreateVerbs < ActiveRecord::Migration
  def change
    create_table :verbs do |t|
      t.string :infinitive
      t.string :translation
      t.integer :group

      t.timestamps
    end
  end
end
