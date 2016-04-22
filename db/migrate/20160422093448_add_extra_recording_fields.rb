class AddExtraRecordingFields < ActiveRecord::Migration
  def change
  	add_column :recordings, :processing, :boolean, :default => false
  end
end
