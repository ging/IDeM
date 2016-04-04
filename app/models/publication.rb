class Publication < ActiveRecord::Base
  acts_as_taggable

  has_and_belongs_to_many :users
  has_many :presentations

  before_validation :parse_for_meta

  validates :title, :presence => true
  validates :loop_url, :presence => true, :uniqueness => true
  validates :loop_id, :presence => true, :uniqueness => true
  validate :authors_validation
  def authors_validation
    return errors[:base] << "Publication without authors" if self.authors.blank?
    true
  end

  ####################
  ## Methods
  ####################

  def author
    users.first
  end

  def authors
    users
  end


  private

  def parse_for_meta
    pInfo = JSON.parse(self.loop_data)

    self.title = pInfo["title"]
    self.abstract = pInfo["abstract"]
    if !pInfo["authors"].blank? and pInfo["authors"].length > 0
      self.authors_name = pInfo["authors"].map{|loopAuthor| loopAuthor["fullName"]}.join(", ")
    end
    self.publication_date = pInfo["publicationDate"]
    self.loop_url = pInfo["loopUrl"]
    self.loop_id = pInfo["id"]

    if !pInfo["journal"].blank?
      self.publication_type = "journal"
    end
    self.publication_name = pInfo["journal"]["name"] if self.publication_type=="journal"
    self.issn = pInfo["journal"]["issn"] if self.publication_type=="journal"
    self.isbn = pInfo["journal"]["isbn"] if self.publication_type=="journal"
    self.volume = pInfo["journal"]["volume"] if self.publication_type=="journal"
    self.issue = pInfo["journal"]["issue"] if self.publication_type=="journal"

    #Additional authors
    if !pInfo["authors"].blank? and pInfo["authors"].length > 0
      loopIds = pInfo["authors"].map{|loopAuthor| loopAuthor["userIds"].first.to_s} rescue []
      users = User.where("provider='loop' and uid in (?)", loopIds)
      users = (self.users + users).uniq
      self.users = users if self.users != users
    end
  end

end