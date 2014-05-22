class RemovePassFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :pass, :string
  end
end
