class User < ActiveRecord::Base
  acts_as_taggable

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => IDeM::Application::config.omniauth_providers

  has_and_belongs_to_many :publications
  has_many :presentations, :through => :publications

  before_validation :fillPasswordFlag
  before_validation :fillLanguages
  before_validation :parse_for_meta
  before_save :parse_for_publications
  before_save :parse_for_contacts
  before_destroy :destroy_resources

  validates :name, :presence => true
  validates :ui_language, :presence => true
  validates :language, :presence => true
  validates_inclusion_of :ug_password_flag, :in => [true, false]
  validate :checkLanguages
  validates :loop_data, :presence => true
  validates :uid, :presence => true
  validates_inclusion_of :provider, :in => ["loop"]
  validates :loop_profile_url, :presence => true


  #################
  # Methods
  #################

  def loop_id
    self.uid if self.provider == "loop"
  end

  def followers
    Contact.where(receiver_id: self.id).map{|c| User.find_by_id(c.sender_id)}.compact
  end

  def followings
    Contact.where(sender_id: self.id).map{|c| User.find_by_id(c.receiver_id)}.compact
  end


  #################
  # Class methods
  #################

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.nil?
      #Create
      user = User.new
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = !auth.info.email.blank? ? auth.info.email : (auth.uid.to_s + "@" + auth.provider + ".com")
      user.password = Devise.friendly_token[0,20]
      user.language = !auth.info.language.blank? ? auth.info.language : I18n.locale.to_s
      user.ui_language = Utils.valid_locale?(user.language) ? user.language : I18n.locale.to_s
    end

    #Update or create LOOP data
    user.loop_data = auth.info.to_hash.to_json
    user.save!

    # user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   #Create user with data from the provide
    #   user.name = auth.info.name
    #   user.email = !auth.info.email.blank? ? auth.info.email : (auth.uid.to_s + "@" + auth.provider + ".com")
    #   user.password = Devise.friendly_token[0,20]
    #   user.language = !auth.info.language.blank? ? auth.info.language : I18n.locale.to_s
    #   user.ui_language = Utils.valid_locale?(user.language) ? user.language : I18n.locale.to_s
    #   user.loop_data = auth.info.to_hash.to_json
    # end
    
    user
  end


  private

  def parse_for_meta
    return if self.loop_data.blank?
    info = JSON.parse(self.loop_data)
    self.loop_profile_url = info["loop_profile_url"]
  end

  def parse_for_publications
    return if self.loop_data.blank?
    info = JSON.parse(self.loop_data)

    unless info["publications"].blank? or info["publications"]["value"].blank?
      info["publications"]["value"].each do |pInfo|
        p = Publication.new
        p.loop_data = pInfo.to_hash.to_json
        p.users = [self]
        p.save
      end
    end
  end

  def parse_for_contacts
    return if self.loop_data.blank?
    info = JSON.parse(self.loop_data)
    
    #Followings
    unless info["followings"].blank? or info["followings"]["value"].blank?
      info["followings"]["value"].each do |cInfo|
        userLoopId = cInfo["id"]
        user = User.where("provider='loop' and uid in (?)", [userLoopId].map{|id| id.to_s}).first
        next if user.nil?
        # The user exists in IDeM.

        #Check if the contact is already created. # If not, create it.
        contact = Contact.where(sender_id: self.id, receiver_id: user.id).first_or_create do |contact|
        end
      end
    end

    #Followers
    unless info["followers"].blank? or info["followers"]["value"].blank?
      info["followers"]["value"].each do |cInfo|
        userLoopId = cInfo["id"]
        user = User.where("provider='loop' and uid in (?)", [userLoopId].map{|id| id.to_s}).first
        next if user.nil?
        # The user exists in IDeM.

        #Check if the contact is already created. # If not, create it.
        contact = Contact.where(sender_id: user.id, receiver_id: self.id).first_or_create do |contact|
        end
      end
    end
  end

  def destroy_resources
    #Publications
    self.publications.each do |publication|
      if publication.users === [self]
        publication.destroy
      end
    end
  end

  def fillPasswordFlag
    if self.new_record?
      if self.provider.blank? or self.uid.blank?
        self.ug_password_flag = true
      else
        #User registered from external provider (using OAuth2 or other authentication mechanisms)
        self.ug_password_flag = false
      end
    end
    true
  end

  def fillLanguages
    self.ui_language = I18n.locale.to_s unless Utils.valid_locale?(self.ui_language)
    self.language = self.ui_language if self.language.blank?
    true
  end

  def checkLanguages
    return errors[:base] << "Invalid user UI locale" unless Utils.valid_locale?(self.ui_language)
    true
  end

end
