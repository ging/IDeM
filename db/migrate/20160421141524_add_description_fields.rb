class AddDescriptionFields < ActiveRecord::Migration
  def change
    add_column :webinars, :description, :string
    add_column :recordings, :description, :string
  end
end
