class ChangeColumnsInUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :facebook_uuid
    add_column :users, :facebook_uuid, :string
  end

  def down
    remove_column :users, :facebook_uuid
    add_column :users, :facebook_uuid, :integer
  end
end
