class AddDefaultValuesToRepetition < ActiveRecord::Migration
  def up
    change_column :repetitions, :count, :integer, :default => 1
    change_column :repetitions, :mistake, :integer, :default => 0
    change_column :repetitions, :correct, :integer, :default => 0
  end
end
