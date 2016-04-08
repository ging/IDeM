class AddUserExtraFields < ActiveRecord::Migration
  def change
    add_column :users, :loop_data, :text
    add_column :users, :loop_profile_url, :text
    add_column :users, :loop_avatar_url, :text
  end
end