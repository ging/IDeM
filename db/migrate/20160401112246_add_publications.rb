class AddPublications < ActiveRecord::Migration
  def change
    create_table(:publications) do |t|
      t.string  :publication_type
      t.text    :title
      t.text    :abstract
      t.text    :publication_date
      t.text    :authors_name
      t.text    :publication_name #journal, conference...
      t.string  :issn
      t.string  :isbn
      t.string  :volume
      t.string  :issue
      t.text    :loop_data
      t.text    :loop_url
      t.integer :loop_id
      t.timestamps null: false
    end
  end
end
