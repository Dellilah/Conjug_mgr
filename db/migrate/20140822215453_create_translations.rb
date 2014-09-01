class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string :content
      t.references :user
      t.references :verb

      t.timestamps
    end
    add_index :translations, [:verb_id, :user_id], :unique => true
  end

  def self.down
  	drop_table :translations
  end
end