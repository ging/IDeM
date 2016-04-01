class Publication < ActiveRecord::Base
  acts_as_taggable

  has_and_belongs_to_many :users
  has_many :presentations


  def author
    users.first
  end

  def authors
    users
  end

end