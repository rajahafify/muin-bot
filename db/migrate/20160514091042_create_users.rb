class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :facebook_uuid
      t.string :profile_pic
      t.string :locale
      t.string :gender

      t.timestamps
    end
  end
end
