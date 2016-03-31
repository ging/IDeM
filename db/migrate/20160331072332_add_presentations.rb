class AddPresentations < ActiveRecord::Migration
  def change
  	create_table(:presentations) do |t|
  		t.integer  "user_id"
  		t.datetime "created_at",     :null => false
	    t.datetime "updated_at",     :null => false
	    t.text     "json"
	    t.text     "thumbnail_url"
	    t.boolean  "draft",          :default => false
	    t.datetime "scorm2004_timestamp"
	    t.string   "attachment_file_name"
	    t.string   "attachment_content_type"
	    t.integer  "attachment_file_size"
	    t.datetime "attachment_updated_at"
	    t.datetime "scorm12_timestamp"
	    t.string   "title",                                                             :default => ""
	    t.text     "description"
	    t.integer  "visit_count",                                                       :default => 0
	    t.string   "language"
	    t.integer  "age_min",                                                           :default => 0
	    t.integer  "age_max",                                                           :default => 0
	    t.integer  "license_id"
	    t.text     "original_author"
	    t.text     "license_attribution"
	    t.text     "license_custom"	    
  	end
  end
end
