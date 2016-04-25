require 'builder'

class Webinar < ActiveRecord::Base
  include Recommendable
  acts_as_ordered_taggable
  
  belongs_to :publication
  has_many :users, :through => :publication
  belongs_to :author, :class_name => 'User', :foreign_key => "author_id"

  before_save :save_tag_array_text
  
  validates_presence_of :title
  validates_presence_of :publication_id
  validates_presence_of :author_id
  validate :author_validation
  def author_validation
    return errors[:base] << "Webinar without author" if self.author_id.blank? or User.find_by_id(self.author_id).nil?
    true
  end

  ####################
  ## Model methods
  ####################

  def owner
    self.author
  end

end
