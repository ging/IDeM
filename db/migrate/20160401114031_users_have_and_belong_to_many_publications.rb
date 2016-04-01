class UsersHaveAndBelongToManyPublications < ActiveRecord::Migration
  def change
    create_table 'publications_users', :id => false do |t|
      t.column :user_id, :integer
      t.column :publication_id, :integer
    end
  end
end


