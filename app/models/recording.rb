require 'builder'

class Recording < ActiveRecord::Base
  include Recommendable
  acts_as_taggable
  
  belongs_to :publication
  has_many :users, :through => :publication
  belongs_to :author, :class_name => 'User', :foreign_key => "author_id"

  before_validation :fill_publication_id

  validates_presence_of :title
  validates_presence_of :publication_id
  validates_presence_of :author_id
  validate :author_validation
  def author_validation
    return errors[:base] << "Recording without author" if self.author_id.blank? or User.find_by_id(self.author_id).nil?
    true
  end

  ####################
  ## Model methods
  ####################

  def owner
    self.author
  end


  private

  def fill_publication_id
    self.publication_id = self.webinar.publication_id if self.publication_id.blank? and !self.webinar.nil?
  end
  
end
