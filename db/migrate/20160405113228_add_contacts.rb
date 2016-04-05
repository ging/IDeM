class AddContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.column :sender_id,        :integer
      t.column :receiver_id,      :integer
      t.column :contact_type,     :string
      t.timestamps
    end
  end
end
