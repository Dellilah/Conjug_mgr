class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :content
      t.integer :temp
      t.integer :person
      t.references :verb, index: true

      t.timestamps
    end
  end
end
