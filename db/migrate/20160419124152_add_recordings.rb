class AddRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.column :publication_id, :integer
      t.column :webinar_id, :integer
      t.column :recording_id, :integer
      t.column :author_id, :integer
      t.column :title, :text
      t.timestamps
    end
  end
end
