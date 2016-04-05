class AddContacts < ActiveRecord::Migration
  create_table :contacts do |t|
    t.column :sender_id,        :integer
    t.column :receiver_id,      :integer
    t.column :contact_type,     :string
    t.column :reflective,       :boolean
    t.timestamps
  end
end
