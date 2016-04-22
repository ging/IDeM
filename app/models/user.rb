class User < ActiveRecord::Base
  include Recommendable
  acts_as_taggable

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => IDeM::Application::config.omniauth_providers

  has_and_belongs_to_many :publications
  has_many :presentations, :through => :publications
  has_many :webinars, :through => :publications

  before_validation :fillPasswordFlag
  before_validation :fillLanguages
  before_validation :fillTags
  before_validation :parse_for_meta
  after_save :save_tag_array_text
  before_destroy :destroy_resources

  validates :name, :presence => true
  validates :ui_language, :presence => true
  validates :language, :presence => true
  validates_inclusion_of :ug_password_flag, :in => [true, false]
  validate :checkLanguages
  validate :checkTags
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

  def avatar_url
    self.loop_avatar_url.blank? ? 'logos/small/user.png' : self.loop_avatar_url
  end

  def followers
    Contact.where(receiver_id: self.id).map{|c| User.find_by_id(c.sender_id)}.compact
  end

  def followings
    Contact.where(sender_id: self.id).map{|c| User.find_by_id(c.receiver_id)}.compact
  end

  def parsed_loop_data
    data = JSON.parse(self.loop_data) rescue {}
    data["user_data"] ||= {}
    data["followings"] ||= {}
    data["followers"] ||= {}
    data["followings"] = data["followings"]["value"] || {}
    data["followers"] = data["followers"]["value"] || {}
    data
  end

  def extend_profile(options={})
    {
      :language => self.language,
      :los => self.pastLos(options[:n])
    }
  end

  def pastLos(n=nil)
    n = IDeM::Application::config.max_user_pastlos unless n.is_a? Numeric
    []
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
      userInfo = auth.info["user_data"] rescue {}
      user.name = (userInfo["firstName"].blank? ? "" : userInfo["firstName"]) + (userInfo["lastName"].blank? ? "" : " " + userInfo["lastName"])
      user.email = userInfo["email"].blank? ? (auth.uid.to_s + "@" + auth.provider + ".dit.upm.es") : userInfo["email"]
      user.password = Devise.friendly_token[0,20]
      loopLanguage = userInfo["countryName"].blank? ? nil : Utils.getLanguageFromLoopCountry(userInfo["countryName"])
      user.language = loopLanguage.blank? ? I18n.locale.to_s : loopLanguage
      user.ui_language = Utils.valid_locale?(user.language) ? user.language : I18n.locale.to_s
    end

    #Update or create LOOP data
    user.loop_data = auth.info.to_hash.to_json
    user.before_login
    user.save!

    user
  end

  def before_login
    self.parse_for_publications
    self.parse_for_contacts
    self.parse_for_keywords
  end

  def parse_for_publications
    return if self.loop_data.blank?
    info = JSON.parse(self.loop_data)

    unless info["publications"].blank? or info["publications"]["value"].blank?
      allLoopPublications = info["publications"]["value"].reject{|pInfo| pInfo["id"].blank?}
      
      #Existing publications
      Publication.where("loop_id in (?)",allLoopPublications.map{|pInfo| pInfo["id"]}).each do |p|
        allLoopPublications.each do |pInfo|
          pInfo["idem_publication"] = p if pInfo["id"]==p.loop_id
        end
      end

      allLoopPublications.each do |pInfo|
        if pInfo["idem_publication"].blank?
          p = Publication.new
          p.users = [self]
        else
          p = pInfo["idem_publication"]
          pInfo.delete("idem_publication")
          p.users = ((p.users + [self]).uniq)
        end
        p.loop_data = pInfo.to_hash.to_json
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

  def parse_for_keywords
    publicationKeywords = self.publications.map{|p| p.tags.map{|t| t.plain_name}}.flatten
    publicationKeywords = publicationKeywords.sort_by{|k| -publicationKeywords.count(k)}.uniq
    userKeywords = publicationKeywords.first(3)
    self.tag_list = userKeywords unless self.tag_list == userKeywords
  end


  private

  def parse_for_meta
    return if self.loop_data.blank?
    info = JSON.parse(self.loop_data)
    return if info["user_data"].blank?
    self.loop_profile_url = info["user_data"]["profileUrl"]
    self.loop_avatar_url = info["user_data"]["pictureUrl"]
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
