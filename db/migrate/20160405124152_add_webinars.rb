class AddWebinars < ActiveRecord::Migration
  def change
    create_table :webinars do |t|
      t.column :publication_id, :integer
      t.column :author_id, :integer
      t.column :room_id, :text
      t.column :title, :text
      t.column :start_date, :datetime
      t.timestamps
    end
  end
end
