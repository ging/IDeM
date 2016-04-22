class AddTagFields < ActiveRecord::Migration
  def change
    add_column :tags, :plain_name, :string
    add_column :users, :tag_array_text, :text, :default => ""
    add_column :webinars, :tag_array_text, :text, :default => ""
    add_column :publications, :tag_array_text, :text, :default => ""
    add_column :presentations, :tag_array_text, :text, :default => ""
    add_column :recordings, :tag_array_text, :text, :default => ""
  end
end
